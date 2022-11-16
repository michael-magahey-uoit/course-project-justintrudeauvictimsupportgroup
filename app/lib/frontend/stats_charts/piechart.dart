import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SimplePieChart extends StatelessWidget {
  Map<String, double>? seriesList;
  final bool? animate;

  SimplePieChart({this.seriesList, this.animate});

  @override
  Widget build(BuildContext context) {
    //currently hardcoded; should be read thru JSON
    seriesList = _createSampleData();
    return PieChart(dataMap: seriesList!);
  }

  /// Create one series with sample hard coded data.
  static Map<String, double> _createSampleData() {
    Map<String, double> data = {
      "Nokia": 10,
      "Samsung": 23,
      "Apple": 102,
      "OnePlus": 6
    };
    return data;
  }
}
