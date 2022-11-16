import 'package:flutter/material.dart';
import 'linechart.dart' as ch;
import 'piechart.dart' as pi;

class ChartPage extends StatefulWidget {
  ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Grade Frequency"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Play Times'),
              ch.SimpleLineChart(),
              Text('Phone Types'),
              pi.SimplePieChart()
            ],
          ),
        ));
  }
}
