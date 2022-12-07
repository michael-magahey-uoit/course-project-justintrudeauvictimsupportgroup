import 'package:claw/frontend/local_storage/play_item.dart';
import 'package:claw/frontend/local_storage/play_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'notifications_service.dart';
import 'dart:convert';
import 'dart:io';

class ClawController extends StatefulWidget {
  ClawController({Key? key, this.title}) : super(key: key);

  String? title;

  @override
  State<ClawController> createState() => _ClawControllerState();
}

class _ClawControllerState extends State<ClawController> {
  late YoutubePlayerController videoPlayer;
  List<String>? queue = null;
  String? current_player = null;
  IO.Socket? connection = null;
  bool connected = false;
  bool playing = false;
  final _model = PlayModel();
  final stopwatch = Stopwatch();
  NotificationService notifier = NotificationService();

  @override
  void initState() {
    initSocket();
    super.initState();

    //TODO: Put actual url in
    //url of claw machine stream
    const url = 'https://youtu.be/vg9v-qLQ0Qs';

    //Create the youtube player and set it to auto play
    //when loaded and give it livestream attributes
    videoPlayer = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        isLive: true
      )
    );
  }

  //Initializes the connection to the backend webserver
  initSocket() {
    IO.Socket socket = IO.io('http://efc88c662ff438.lhr.life',
      OptionBuilder()
              .setTransports(['websocket'])
              .build()); //Change this to internet later, 10.0.2.2 = host's localhost for emulator

    //OnConnect event runs when we achieve a connection to the backend server
    socket.onConnect((_) async {
      socket.emit('dbg', "Connected!");
      await notifier.init();
      await notifier.notify("Claw Controller", "Connected!");
      //Record Keeping Here (Cloud Storage)
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      switch (Platform.operatingSystem)
      {
        case "android":
          {
            AndroidDeviceInfo androidDevice = await deviceInfo.androidInfo;
            String? imei = await UniqueIdentifier.serial;
            print("${androidDevice.device} - ${imei != null ? imei : ""}");
            //These prints will eventually be sent to firebase
          }
          break;
        case "ios":
          {
            IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
            print(iosDevice.name);
            //These wont be pushed because we have no way to test all the platforms. If we could, we would build OS version/brand variables for all
            //Platforms then send to firebase.
          }
          break;
        case "windows":
          {
            WindowsDeviceInfo windowsDevice = await deviceInfo.windowsInfo;
            print(windowsDevice.editionId);
          }
          break;
        case "macos":
          {
            MacOsDeviceInfo macosDevice = await deviceInfo.macOsInfo;
            print(macosDevice.osRelease);
          }
          break;
        case "linux":
          {
            LinuxDeviceInfo linuxDevice = await deviceInfo.linuxInfo;
            print(linuxDevice.variant);
          }
          break;
      }
      setState(() {
        connected = true;
      });
    });

    //OnConnecting event fires when a connection is being attempted
    socket.onConnecting((_) {
      connected = false;
      print("Connecting...");
    });

    //OnConnectError event fires when we fail to connect to the webserver
    socket.onConnectError((err) {
      connected = false;
      print("Socket Error: ${err}");
    });

    //OnDisconnect event fires when we disconnect from the webserver, perfect for
    //cleaning our properties between plays
    socket.onDisconnect((_) {
      connected = false;
      setState(() {
        queue = null;
        current_player = null;
        playing = false;
      });
      print('Disconnected!');
    });

    //queue event fires when we receive an update for the queue, this allows us to send
    //notifications to the user about their position in line.
    socket.on('queue', (queue_packet) async {
      print(queue_packet);
      Map<String, dynamic> queueData = jsonDecode(queue_packet);
      print(queueData);
      await notifier.notify("Queue Update!", queueData['status'][0] == socket.id ? "You're now playing!" : "You are now ${queueData['status'].indexOf(socket.id) + 1} out of ${queueData['status'].length}");
      setState(() {
        queue = queueData['status'].cast<String>();
        current_player = queueData['current'].toString();
      });
    });

    //status event only fires when it is the users turn to play.
    socket.on('status', (status) async {
      print("[${socket.id}] -> ${status}");
      setState(() {
        playing = true;
      });
      stopwatch.start();
    });
    connection = socket;
  }

  @override
  Widget build(BuildContext context) =>
      YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: videoPlayer,
        ),
        builder: (context, player) =>
            Scaffold(
              appBar: AppBar(
                title: Text(connected == false || current_player == null ? widget.title! : 
                              connected && current_player != connection!.id.toString() ? 
                                  "Playing: ${current_player!}" 
                                  : 
                                  "You're Up!"),
              ),
              body: _buildClawController(player),
            ),
      );

  Widget _buildClawController(Widget player) {
    double _width = MediaQuery.of(context).size.width; //Width of device
    double _height = MediaQuery.of(context).size.height; //Height of device
    double _buttonSize = 60.0; //Size of controller buttons
    double _buttonPadding = 5.0; //Size of button padding

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://wallpapercave.com/wp/wp4694506.jpg'
              ),
              fit: BoxFit.cover
          )
      ),
      child: Column(
        children: [
          //Puts the video player at the top of the column
          //and gives some padding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: _width/1.1,
                padding: EdgeInsets.only(top: _height/36, bottom: _height/6),
                child: player,
              )
            ],
          ),
          //Button arrangement, when clicked calls a function from claw_movement
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                //Send the server a packet when we start pressing and one when we stop
                //This allows for fluid play without spamming the server.
                onTapDown: (_) => { connection!.emit('up', "") },
                onTapUp: (_) => { connection!.emit('clear', "") },
                child: Icon(Icons.keyboard_arrow_up_rounded, size: _buttonSize, color: Colors.white,),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: (_) => { connection!.emit('left', "") },
                onTapUp: (_) => { connection!.emit('clear', "") },
                child: Icon(Icons.keyboard_arrow_left_rounded, size: _buttonSize, color: Colors.white),
              ),
              //When the player drops the claw a play is recorded into the database
              GestureDetector(
                onTapDown: (_) async {
                  connection!.emit('drop', "");
                  playing = false;
                  DateTime end = DateTime.now();
                  String date = "${end.year}-${end.month}-${end.day}";
                  stopwatch.stop();
                  String playTime = "${stopwatch.elapsedMilliseconds/1000}";
                  print("Date: $date");
                  print("Playtime: $playTime");

                  PlayItem playItem = PlayItem(date: date, playTime: playTime);
                  _model.insertPlay(playItem);
                  stopwatch.reset();

                  showDialog(context: context,
                      barrierDismissible: false,
                      builder: (context){
                        return AlertDialog(
                          title: const Text("Good try!!!"),
                          content: const Text("Would you like to try again?"),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  //Reset the socket so that the user is at the back of the queue
                                  connection!.disconnect();
                                  initSocket();
                                  connection!.connect();
                                },
                                child: const Text("Yes")
                            ),
                            // If user doesn't want to play again returns them
                            // to the home page
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No")
                            ),
                          ],
                        );
                      }
                  );
                },
                onTapUp: (_) => { connection!.emit('clear', "") },
                child: Icon(Icons.circle, size: _buttonSize, color: Colors.white),
              ),
              GestureDetector(
                onTapDown: (_) => { connection!.emit('right', "") },
                onTapUp: (_) => { connection!.emit('clear', "") },
                child: Icon(Icons.keyboard_arrow_right_rounded, size: _buttonSize, color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapDown: (_) => { connection!.emit('down', "") },
                onTapUp: (_) => { connection!.emit('clear', "") },
                child: Icon(Icons.keyboard_arrow_down_rounded, size: _buttonSize, color: Colors.white),
              ),
            ],
          ),
          //Text box that tells the user how many people are ahead of them
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: _height/10),
                child: Container(
                  width: _width/1.2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(_width/2)
                  ),
                  child: Center(
                    child: connected == true ?
                      queue != null ?
                            Text("You are ${queue!.indexOf(connection!.id!) + 1} out of ${queue!.length.toString()} players!", style: TextStyle(fontSize: 20,
                                                                                color: Colors.white)) :
                            Text("Joining Queue...", style: TextStyle(fontSize: 20,
                                                                      color: Colors.white)) :
                    Text("Disconnected!", style: TextStyle(fontSize: 20,
                                                          color: Colors.white)),
                  )
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
