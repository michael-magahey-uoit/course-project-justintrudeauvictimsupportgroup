import 'package:flutter/material.dart';
import 'package:line_chart/charts/line-chart.widget.dart';
import 'package:line_chart/model/line-chart.model.dart';

class SimpleLineChart extends StatelessWidget {
  List<LineChartModel>? seriesList;
  final bool? animate;

  SimpleLineChart({this.seriesList, this.animate});

  /// Creates a [LineChart] with sample data and no transition.

  @override
  Widget build(BuildContext context) {
    //currently hardcoded; should be read thru JSON
    seriesList = _createSampleData([1, 2, 3, 4, 4, 5, 2, 3]);
    return LineChart(
      width: 300,
      height: 180,
      data: seriesList!,
      linePaint: Paint()
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..color = Colors.red,
    );
  }

  /// Create one series with sample hard coded data.
  static List<LineChartModel> _createSampleData(List<double> nums) {
    List<LineChartModel> data = [];
    for (double i in nums) {
      data.add(LineChartModel(amount: i));
    }

    return data;
  }
}
