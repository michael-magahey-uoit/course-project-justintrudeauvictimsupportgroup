import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ClawController extends StatefulWidget {
  ClawController({Key? key, this.title}) : super(key: key);

  String? title;

  @override
  State<ClawController> createState() => _ClawControllerState();
}

class _ClawControllerState extends State<ClawController> {
  late YoutubePlayerController controller;

  @override
  void initState(){
    super.initState();

    const url = 'https://www.youtube.com/watch?v=jfKfPfyJRdk';

    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      )
    );
  }

  @override
  void deactivate() {
    controller.pause();

    super.deactivate();
  }

  @override
  void dispose(){
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
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
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width/1.1,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: player,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width/1.2,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(width/2)
              ),
              child: const Center(
                child: Text(
                    "You are # out of # players!",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    )
                ),
              )
            )
          ],
        )
      ],
    );
  }

}
