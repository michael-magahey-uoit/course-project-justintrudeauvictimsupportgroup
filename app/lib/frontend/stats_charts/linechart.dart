import 'package:flutter/material.dart';
import 'package:line_chart/charts/line-chart.widget.dart';
import 'package:line_chart/model/line-chart.model.dart';
import 'package:charts_flutter_new/flutter.dart' as nw;

class SimpleLineChart extends StatelessWidget {
  /***
   * SeriesList: List<Double> list of numbers to use for line chart data
   * modeList: List<LineChartModel> converted list of line chart points
   * This class takes in a list of numbers and returns a line chart.
   */
  List<double>? seriesList;
  nw.Series<dynamic, num>? modelList;
  final bool? animate;

  SimpleLineChart({this.seriesList, this.modelList, this.animate});

  @override
  Widget build(BuildContext context) {
    modelList = _convertData(seriesList!);
    return Container(height: 300, child: nw.LineChart([modelList!]));
  }

  /*
      width: 300,
      height: 180,
      data: modelList!,
      linePointerDecoration: BoxDecoration(
        color: Colors.black,
      ),
      linePaint: Paint()
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..color = Colors.red,
    );
  }*/

  static nw.Series<dynamic, num> _convertData(List<dynamic> nums) {
    //Takes a list of numbers and returns list of chartmodel

    return nw.Series<dynamic, int>(
      id: '',
      colorFn: (_, __) => nw.MaterialPalette.red.shadeDefault,
      domainFn: (_, __) => 10,
      measureFn: (__, _) => 6,
      data: nums,
    );
  }

// Class for chart data source, this can be modified based on the data in Firestore

}

class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}
