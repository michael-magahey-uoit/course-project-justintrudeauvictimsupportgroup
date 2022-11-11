import 'package:flutter/material.dart';

class ClawController extends StatefulWidget {
  ClawController({Key? key, this.title}) : super(key: key);

  String? title;

  @override
  State<ClawController> createState() => _ClawControllerState();
}

class _ClawControllerState extends State<ClawController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: _buildClawController(),
    );
  }

  Widget _buildClawController() {
    return Row(
      children: [
        Row()
      ],
    );
  }

}
