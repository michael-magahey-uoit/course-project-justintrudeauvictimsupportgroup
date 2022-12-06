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
      //Background image for the app
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://wallpapercave.com/wp/wp4694506.jpg'
          ),
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 60, top: 80),
              child: const Text(
                "Claw City",
                style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'ZenDots'),
              ),
            ),
            //Button to bring the user to the claw machine controller
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/playClaw');
              },
              child: Container(
                width: _width / 1.5,
                height: _height / 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
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
                width: _width / 1.5,
                height: _height / 12,
                decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.history, size: 30,),
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
                width: _width / 1.5,
                height: _height / 12,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
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
                width: _width / 1.5,
                height: _height / 12,
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
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
