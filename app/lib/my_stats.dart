import 'package:flutter/material.dart';

class MyStats extends StatefulWidget {
  MyStats({Key? key, this.title}) : super(key: key);

  String? title;

  @override
  State<MyStats> createState() => _MyStatsState();
}

class _MyStatsState extends State<MyStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: _buildStatsTable(),
    );
  }

  Widget _buildStatsTable(){
    return Container();
    // return PaginatedDataTable(
    //     columns: const [
    //       DataColumn(label: Text("Date"))
    //     ],
    //     source: source
    // );
  }
}
