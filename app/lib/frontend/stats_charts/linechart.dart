import 'package:flutter/material.dart';
import 'package:line_chart/charts/line-chart.widget.dart';
import 'package:line_chart/model/line-chart.model.dart';

class SimpleLineChart extends StatelessWidget {
  List<double>? seriesList;
  List<LineChartModel>? modelList;
  final bool? animate;

  SimpleLineChart({this.seriesList, this.modelList, this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  @override
  Widget build(BuildContext context) {
    //currently hardcoded; should be read thru JSON
    modelList = _convertData(seriesList!);
    return LineChart(
      width: 300,
      height: 180,
      data: modelList!,
      linePaint: Paint()
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..color = Colors.red,
    );
  }

  /// Create one series with sample hard coded data.
  static List<LineChartModel> _convertData(List<double> nums) {
    List<LineChartModel> data = [];
    for (double i in nums) {
      data.add(LineChartModel(amount: i));
    }

    return data;
  }
}
