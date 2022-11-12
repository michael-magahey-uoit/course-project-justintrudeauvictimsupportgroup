import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  List<charts.Series<dynamic, num>> seriesList;
  final bool? animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.

  @override
  Widget build(BuildContext context) {
    seriesList = _createSampleData();
    return new charts.LineChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<int, int>> _createSampleData() {
    final data = [
      //Currently hardcoded data to mock "Play_times" statistic
      [1, 2, 3, 4, 4, 5, 2, 3],
    ];

    return [
      charts.Series<int, int>(
        id: 'Play Times',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (_, __) => data.length,
        measureFn: (_, __) => data.length,
        data: data[0],
      )
    ];
  }
}
