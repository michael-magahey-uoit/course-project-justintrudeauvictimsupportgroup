import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SimplePieChart extends StatelessWidget {
  Map<String, double>? seriesList;
  final bool? animate;

  SimplePieChart({required this.seriesList, this.animate});

  @override
  Widget build(BuildContext context) {
    return PieChart(dataMap: seriesList!);
  }
}
