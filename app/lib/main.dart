import 'package:flutter/material.dart';
import 'claw_controller.dart';
import 'menu.dart';
import 'my_stats.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(), //ClawController(title: "Claw Machine"),
      routes: <String, WidgetBuilder>{
        '/playClaw': (BuildContext context){
          return ClawController(title: "CLAWWWW",);
        },
        '/myStats': (BuildContext context){
          return MyStats(title: "My Stats",);
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
