import 'package:flutter/material.dart';
import 'frontend/stats_charts/chartmenu.dart' as chart;
import 'package:firebase_core/firebase_core.dart';
import 'package:claw/frontend/geo_location/map_maker/map_maker.dart'
    as map_maker;

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error initializing Firebase");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print("Successfully connected to Firebase");
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Main Menu"),
            ),
            body: _buildMainMenu(),
          );
        });
  }

  Widget _buildMainMenu() {
    double _width = MediaQuery.of(context).size.width; //Width of device
    double _height = MediaQuery.of(context).size.height; //Height of device
    TextStyle _textSize = TextStyle(fontSize: 40);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/background.jpg'
          ),
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Button to bring the user to the claw machine controller
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/playClaw');
              },
              child: Container(
                color: Colors.red,
                width: _width / 1.5,
                height: _height / 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.gamepad),
                    Text("Play", style: TextStyle(fontSize: 40))
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            //Button to bring the user to their stats
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/myStats');
              },
              child: Container(
                color: Colors.yellow,
                width: _width / 1.5,
                height: _height / 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.insert_chart),
                    Text("Play History", style: TextStyle(fontSize: 40))
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            //Button to bring the user to global stats
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => chart.ChartMenu()));
              },
              child: Container(
                color: Colors.blue,
                width: _width / 1.5,
                height: _height / 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_city_outlined),
                    Text("Global Stats", style: TextStyle(fontSize: 40))
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            //Button to bring the user to global stats
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => map_maker.MapPage()));
              },
              child: Container(
                color: const Color.fromARGB(120, 250, 0, 0),
                width: _width / 1.5,
                height: _height / 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.map),
                    Text("CM Location", style: TextStyle(fontSize: 40))
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 40))
          ],
        ),
      ),
    );
  }
}
