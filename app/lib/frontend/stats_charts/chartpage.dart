import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'linechart.dart' as ch;
import 'piechart.dart' as pi;

List<double> _lineData = [];
Map<String, double> _piData = {};

class ChartPage extends StatefulWidget {
  ChartPage({Key? key, this.data}) : super(key: key);
  String? data;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  var _stats;
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/stats.json');
    final data = await json.decode(response);
    var lineData = data["play_time"];
    var list1;
    for (var i in lineData) {
      list1.add(i.toDouble());
    }
    var pidata = data["phones"];
    setState(() {
      _lineData = list1;
      _piData = json.decode(json.encode(pidata)) as Map<String, double>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Global Stats"),
        ),
        body: Center(
          child: (_lineData.isNotEmpty && _piData.isNotEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.data == 'pi') ...[
                      buildPieChart(_piData),
                    ] else ...[
                      buildLineChart(_lineData),
                    ],
                  ],
                )
              : Column(
                  //hardcoded alternative IF JSOn read returns empty lists.
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.data == 'pi') ...[
                      buildPieChart({
                        "Nokia": 10,
                        "Samsung": 23,
                        "Apple": 102,
                        "OnePlus": 6
                      }),
                    ] else ...[
                      buildLineChart([1, 2, 3, 4, 4, 5, 2, 3]),
                    ],
                  ],
                ),
        ));
  }
}

buildPieChart(Map<String, double> data) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Phone Types'),
        pi.SimplePieChart(
          seriesList: data,
        )
      ],
    ),
  );
}

buildLineChart(List<double> data) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Play Times'),
        ch.SimpleLineChart(
          seriesList: data,
        ),
      ],
    ),
  );
}
