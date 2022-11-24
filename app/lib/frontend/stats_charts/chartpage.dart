import 'package:flutter/material.dart';
import 'linechart.dart' as ch;
import 'piechart.dart' as pi;

class ChartPage extends StatefulWidget {
  ChartPage({Key? key, this.data}) : super(key: key);
  String? data;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Global Stats"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.data == 'pi') ...[
                buildPieChart(),
              ] else ...[
                buildLineChart(),
              ],
            ],
          ),
        ));
  }
}

buildPieChart() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Text('Phone Types'), pi.SimplePieChart()],
    ),
  );
}

buildLineChart() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Play Times'),
        ch.SimpleLineChart(),
      ],
    ),
  );
}
