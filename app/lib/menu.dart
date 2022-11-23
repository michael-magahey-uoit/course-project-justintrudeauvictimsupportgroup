import 'package:flutter/material.dart';
import 'frontend/stats_charts/chartpage.dart' as chart;
import 'package:claw/frontend/geo_location/map_maker/map_maker.dart' as map_maker;

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cool app title"),
      ),
      body: _buildMainMenu(),
    );
  }

  Widget _buildMainMenu() {
    double _width = MediaQuery.of(context).size.width; //Width of device
    double _height = MediaQuery.of(context).size.height; //Height of device
    TextStyle _textSize = TextStyle(fontSize: 40);
    return Center(
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
              height: _height / 16,
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
            onTap: () {},
            child: Container(
              color: Colors.yellow,
              width: _width / 1.5,
              height: _height / 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.insert_chart),
                  Text("My Stats", style: TextStyle(fontSize: 40))
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          //Button to bring the user to global stats
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => chart.ChartPage()));
            },
            child: Container(
              color: Colors.blue,
              width: _width / 1.5,
              height: _height / 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_city_outlined),
                  Text("Global Stats", style: TextStyle(fontSize: 40))
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          //Button to bring the user to global stats
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => map_maker.MapPage()));
            },
            child: Container(
              color: Color.fromARGB(120, 250, 0, 0),
              width: _width / 1.5,
              height: _height / 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_city_outlined),
                  Text("CM Location", style: TextStyle(fontSize: 40))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
