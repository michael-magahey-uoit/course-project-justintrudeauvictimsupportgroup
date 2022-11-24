import 'package:flutter/material.dart';
import 'chartpage.dart' as chart;

class ChartMenu extends StatefulWidget {
  ChartMenu({Key? key, this.data}) : super(key: key);
  String? data;
  @override
  State<ChartMenu> createState() => _ChartMenuState();
}

class _ChartMenuState extends State<ChartMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Global Stats"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return chart.ChartPage(data: 'line');
                      },
                    );
                  },
                  child: Text("Play Times"),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 75, vertical: 35),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return chart.ChartPage(data: 'pi');
                      },
                    );
                  },
                  child: Text("Phone Types"),
                ),
              ),
            ])));
  }
}
