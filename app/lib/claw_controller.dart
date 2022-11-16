import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'claw_movement.dart';

class ClawController extends StatefulWidget {
  ClawController({Key? key, this.title}) : super(key: key);

  String? title;

  @override
  State<ClawController> createState() => _ClawControllerState();
}

class _ClawControllerState extends State<ClawController> {
  late YoutubePlayerController videoPlayer;
  final _claw = ClawMovement();

  @override
  void initState(){
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
                  _claw.moveForward();
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
                onPressed: (){
                  _claw.moveLeft();
                },
                icon: const Icon(Icons.keyboard_arrow_left_rounded)
            ),
            IconButton(
                iconSize: _buttonSize,
                onPressed: (){
                  _claw.drop(context);
                },
                icon: const Icon(Icons.circle)
            ),
            IconButton(
                iconSize: _buttonSize,
                padding: EdgeInsets.only(left: _buttonPadding),
                onPressed: (){
                  _claw.moveRight();
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
                  _claw.moveBackwards();
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
                child: const Center(
                  child: Text(
                    //TODO: Replace # with number
                      "You are # out of # players!",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      )
                  ),
                )
              ),
            )
          ],
        )
      ],
    );
  }

}
