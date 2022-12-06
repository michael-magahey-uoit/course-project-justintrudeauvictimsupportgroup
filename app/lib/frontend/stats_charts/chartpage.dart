import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'phonedata.dart';
import 'linechart.dart' as ch;
import 'piechart.dart' as pi;

List<double> _lineData = [];
Map<String, double> _piData = {"this": 10};

class ChartPage extends StatefulWidget {
  ChartPage({Key? key, this.data}) : super(key: key);
  String? data;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  var _stats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Global Stats"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.data == 'pi') ...[
              buildPieChart(),
            ] else ...[
              buildLineChart(_lineData),
            ],
          ],
        )));
  }
}

buildPieChart() {
  getPhones();
  return FutureBuilder(
      future: getPhones(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //_buildPhones(context, snapshot.data.docs[0].data()['phone_types']);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Phone Types'),
              pi.SimplePieChart(
                seriesList: _piData,
              )
            ],
          ),
        );
      });
}

List<double> _buildList(BuildContext context, DocumentSnapshot productData) {
  var list = [];

  for (var i = 0; i < productData.toString().length; i++) {
    print("o");
  }
  return [1];
}

_buildPhones(BuildContext context, DocumentSnapshot productData) {
  var phones =
      Phones.fromMap(productData.data(), reference: productData.reference);
  print(phones);
}

/*buildLineChart(List<double> data) {
  return FutureBuilder(
      future: getPlaytimes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading");
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Play Times'),
              ch.SimpleLineChart(
                seriesList: snapshot.data.docs
                    .map((document) => _buildList(context, document)),
              ),
            ],
          ),
        );
      });}*/

buildLineChart(List<double> data) {
  return FutureBuilder(
      future: getPlaytimes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print("Snapshot: $snapshot");
        if (!snapshot.hasData) {
          print("Data is missing");
          return CircularProgressIndicator();
        } else {
          print("Data found");
          print("Length: ${snapshot.data.docs.length}");
          Color _color = Colors.white;
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: ListTile(
                    title: Text(snapshot.data.docs[index].data()["time"]),
                  ),
                ),
              );
            },
          );
        }
      });
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

Future getPhones() async {
  print("Getting the phones...");
  FirebaseFirestore.instance.collection('phones').get().then((value) {
    value.docs.forEach((element) {
      print("urm om");
      print(element.data()["nokia"]);
    });
    print("ur dad");
  });
  return await FirebaseFirestore.instance.collection('phones').get();
}
