import 'package:flutter/material.dart';
class winnerLocationPage extends StatefulWidget {
  winnerLocationPage({Key? key, this.title}) : super(key: key);
  String? title;
  @override
  State<winnerLocationPage> createState() => _winnerLocationPageState();
}

class _winnerLocationPageState extends State<winnerLocationPage> {

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                  label: Text('Address'),
                  hintText: "### address name, city name, province abreviation(e.g: ON) Postal Code"
              ),
            )
          ],
        )
    );
  }
}