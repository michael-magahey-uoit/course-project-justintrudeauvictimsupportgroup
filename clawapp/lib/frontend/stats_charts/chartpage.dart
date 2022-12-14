import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'phonedata.dart';
import 'linechart.dart' as ch;
import 'piechart.dart' as pi;

List<double> _lineData = [];
Map<String, double> _piData = {
  "Nokia": 10,
  "Apple": 102,
  "Samsung": 23,
  "Oneplus": 6
};

class ChartPage extends StatefulWidget {
  /**
   * Connects to firebase, builds charts from data
   * Contains futurebuilders for both charts
   */
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
            child: Container(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.data == 'pi') ...[
                      buildPieChart(),
                    ] else if (widget.data == 'line') ...[
                      buildLineChartHard([1, 2, 4, 3, 5]),
                    ] else ...[
                      Text("Please Select an Option"),
                    ],
                  ],
                ))));
  }

  buildPieChart() {
    return Container(
        height: 300,
        child: FutureBuilder(
            future: getPhones(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                if (snapshot.data.docs.length > 0) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Text('Phone Types'),
                        pi.SimplePieChart(
                          seriesList: snapshot.data.docs.map(
                              (document) => _buildPhones(context, document)),
                        )
                      ]));
                }
              }
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text('Phone Types'),
                    pi.SimplePieChart(
                      seriesList: _piData,
                    )
                  ]));
            }));
  }

  //retriever functions for firebase data
  _buildPhones(BuildContext context, DocumentSnapshot productData) {
    print("building phones ${productData.data()}");
    var phones =
        Phones.fromMap(productData.data(), reference: productData.reference);
  }

  _buildList(BuildContext context, DocumentSnapshot productData) {
    print("building list ${productData.data()}");
    var list =
        ChartData.fromMap(productData.data(), reference: productData.reference);
  }

  Future getPlaytimes() async {
    print("Getting the playtimes...");
    var temp = await FirebaseFirestore.instance.collection('play_times').get();
    FirebaseFirestore.instance.collection('play_times').get().then((value) {
      value.docs.forEach((element) {
        print(element.data()["time"]);
      });
    });
    return temp;
  }

  buildLineChart(List<double> data) {
    return FutureBuilder(
        future: getPlaytimes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          if (snapshot.data != null) {
            if (snapshot.data.docs.length > 0) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text('Play Times'),
                    pi.SimplePieChart(
                      seriesList: snapshot.data.docs
                          .map((document) => _buildList(context, document)),
                    )
                  ]));
            }
          }
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Text('Play Times'),
                ch.SimpleLineChart(
                  seriesList: _lineData,
                )
              ]));
        });
  }

  buildLineChartHard(List<double> data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Play Times'),
          ch.SimpleLineChart(
            seriesList: [1, 2, 4, 3, 5, 3],
          ),
        ],
      ),
    );
  }

  Future getPhones() async {
    print("Getting the phones...");
    //problem is this returns 0 length

    return await FirebaseFirestore.instance.collection('phones').get();
  }
}
