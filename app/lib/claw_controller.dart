import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert';

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
  IO.Socket? connection = null;
  bool connected = false;
  final _claw = ClawMovement();

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
    socket.onConnect((_) {
      socket.emit('dbg', "Connected!");
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
      print('Disconnected!');
    });
    socket.on('queue', (queue) {
      print(queue);
      Map<String, dynamic> queueData = jsonDecode(queue);
      //String = queueData['player']
      setState(() {
        queue = queueData['status'];
      });
    });
    socket.on('status', (status) {
      print("[${socket.id}] -> ${status}");
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
                title: Text(widget.title!),
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
            IconButton(
              iconSize: _buttonSize,
                padding: EdgeInsets.only(bottom: _buttonPadding),
                onPressed: (){
                  connection!.emit('up', "");
                },
                icon: const Icon(Icons.keyboard_arrow_up_rounded)
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                iconSize: _buttonSize,
                padding: EdgeInsets.only(right: _buttonPadding),
                onPressed: () {
                  connection!.emit('left', "");
                },
                icon: const Icon(Icons.keyboard_arrow_left_rounded)
            ),
            IconButton(
                iconSize: _buttonSize,
                onPressed: (){
                  connection!.emit('drop', "");
                },
                icon: const Icon(Icons.circle)
            ),
            IconButton(
                iconSize: _buttonSize,
                padding: EdgeInsets.only(left: _buttonPadding),
                onPressed: (){
                  connection!.emit('right', "");
                },
                icon: const Icon(Icons.keyboard_arrow_right_rounded)
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                iconSize: _buttonSize,
                padding: EdgeInsets.only(top: _buttonPadding),
                onPressed: (){
                  connection!.emit('down', "");
                },
                icon: const Icon(Icons.keyboard_arrow_down_rounded)
            )
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
