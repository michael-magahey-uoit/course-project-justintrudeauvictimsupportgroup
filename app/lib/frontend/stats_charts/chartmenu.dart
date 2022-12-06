import 'package:flutter/material.dart';
import 'chartpage.dart' as chart;
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
      body: SlidingUpPanel(
        panel: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return chart.ChartPage(); //data:'pi'
                        },
                      );
                    },
                    child: Text("Play Times"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 75, vertical: 35),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return chart.ChartPage();
                        },
                      );
                    },
                    child: Text("Phone Types"),
                  ),
                ),
              ]),
        ),
        collapsed: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              // changing radius that we define above
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0))),
          // collapsed text
          child: Center(
            child: Text("Slide for Options"),
          ),
        ),
        // main body or content behind the panel
        body: Center(
          child: Text("Choose a chart to display"),
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
    );
  }
}
