import 'package:claw/frontend/geo_location/location_page/locations_page.dart';
import 'package:flutter/material.dart';
import 'claw_controller.dart';
import 'menu.dart';
import 'frontend/local_storage/my_stats.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Project',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainMenu(), //ClawController(title: "Claw Machine"),
      routes: <String, WidgetBuilder>{
        '/playClaw': (BuildContext context) {
          return ClawController(
            title: "The Claw",
          );
        },
        '/myStats': (BuildContext context) {
          return MyStats(
            title: "Play History",
          );
        },
        '/getLocation': (BuildContext context) {
          return const winnerLocationPage();
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
