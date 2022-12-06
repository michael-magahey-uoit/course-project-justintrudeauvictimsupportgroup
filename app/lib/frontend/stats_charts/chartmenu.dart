import 'package:flutter/material.dart';
import 'chartpage.dart' as chart;

class ChartMenu extends StatefulWidget {
  ChartMenu({Key? key, this.data}) : super(key: key);
  String? data;

  @override
  State<ChartMenu> createState() => _ChartMenuState();
}

class _ChartMenuState extends State<ChartMenu> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      print('index :$selectedIndex');
    });
  }

  switchPage(int index) {
    if (index == 0) {
      return chart.ChartPage(data: 'line');
    } else if (index == 1) {
      return chart.ChartPage(data: 'pi');
    } else {
      return chart.ChartPage(data: 'any');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switchPage(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined_rounded),
            label: 'Play Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_rounded),
            label: 'Phones',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
