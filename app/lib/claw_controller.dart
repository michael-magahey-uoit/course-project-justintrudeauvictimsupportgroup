import 'package:claw/play_item.dart';
import 'package:claw/play_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'dart:io';

import 'claw_movement.dart';

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
  final _claw = ClawMovement();
  final _model = PlayModel();
  final stopwatch = Stopwatch();

  @override
  void initState(){
    initSocket();
    super.initState();

    //TODO: Put actual url in
    //url of claw machine stream
    const url = 'https://www.youtube.com/watch?v=jfKfPfyJRdk';

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

  initSocket() {
    //Create connection with the backend webserver
    IO.Socket socket = IO.io('http://10.0.2.2:80',
      OptionBuilder()
              .setTransports(['websocket'])
              .build()); //Change this to internet later, 10.0.2.2 = host's localhost for emulator
    socket.onConnect((_) async {
      socket.emit('dbg', "Connected!");
      //Record Keeping Here (Cloud Storage)
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      switch (Platform.operatingSystem)
      {
        case "android":
          {
            AndroidDeviceInfo androidDevice = await deviceInfo.androidInfo;
            print(androidDevice.toMap());
            //These prints will eventually be sent to firebase
          }
          break;
        case "ios":
          {
            IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
            print(iosDevice.toMap());
          }
          break;
        case "windows":
          {
            WindowsDeviceInfo windowsDevice = await deviceInfo.windowsInfo;
            print(windowsDevice.toMap());
          }
          break;
        case "macos":
          {
            MacOsDeviceInfo macosDevice = await deviceInfo.macOsInfo;
            print(macosDevice.toMap());
          }
          break;
        case "linux":
          {
            LinuxDeviceInfo linuxDevice = await deviceInfo.linuxInfo;
            print(linuxDevice.toMap());
          }
          break;
      }
      setState(() {
        connected = true;
      });
    });
    socket.onConnecting((_) {
      connected = false;
      print("Connecting...");
    });
    socket.onConnectError((err) {
      connected = false;
      print("Socket Error: ${err}");
    });
    socket.onDisconnect((_) {
      connected = false;
      setState(() {
        queue = null;
        current_player = null;
        playing = false;
      });
      print('Disconnected!');
    });
    socket.on('queue', (queue) {
      print(queue);
      Map<String, dynamic> queueData = jsonDecode(queue);
      print(queueData);
      setState(() {
        queue = queueData['status'];
        current_player = queueData['current'];
      });
    });
    socket.on('status', (status) async {
      print("[${socket.id}] -> ${status}");
      setState(() {
        playing = true;
      });
      //Notification Here (You are playing)
      stopwatch.start();
    });
    connection = socket;
    //Make a dispose function to clear the connection memory
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
    double _buttonSize = 50.0; //Size of controller buttons
    double _buttonPadding = 5.0; //Size of button padding

    return Column(
      children: [
        //Puts the video player at the top of the column
        //and gives some padding
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _width/1.1,
              padding: EdgeInsets.only(top: _height/36, bottom: _height/7),
              child: player,
            )
          ],
        ),
        //Button arrangement, when clicked calls a function from claw_movement
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapDown: (_) => { connection!.emit('up', "") },
              onTapUp: (_) => { connection!.emit('clear', "") },
              child: Icon(Icons.keyboard_arrow_up_rounded, size: _buttonSize),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapDown: (_) => { connection!.emit('left', "") },
              onTapUp: (_) => { connection!.emit('clear', "") },
              child: Icon(Icons.keyboard_arrow_left_rounded, size: _buttonSize),
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
              },
              onTapUp: (_) => { connection!.emit('clear', "") },
              child: Icon(Icons.circle, size: _buttonSize),
            ),
            GestureDetector(
              onTapDown: (_) => { connection!.emit('right', "") },
              onTapUp: (_) => { connection!.emit('clear', "") },
              child: Icon(Icons.keyboard_arrow_right_rounded, size: _buttonSize),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapDown: (_) => { connection!.emit('down', "") },
              onTapUp: (_) => { connection!.emit('clear', "") },
              child: Icon(Icons.keyboard_arrow_down_rounded, size: _buttonSize),
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
                          Text("You are ${queue!.indexOf(connection!.id!)} out of ${queue!.length.toString()} players!", style: TextStyle(fontSize: 20,
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
    );
  }

}
