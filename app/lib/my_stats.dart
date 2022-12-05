import 'package:claw/play_item.dart';
import 'package:claw/play_model.dart';
import 'package:flutter/material.dart';

class MyStats extends StatefulWidget {
  MyStats({Key? key, this.title}) : super(key: key);

  String? title;

  @override
  State<MyStats> createState() => _MyStatsState();
}

class _MyStatsState extends State<MyStats> {

  List<PlayItem>? _plays;
  final _model = PlayModel();

  @override
  void initState(){
    super.initState();
    getPlays();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.sort)
          )
        ],
      ),
      body: _buildStatsTable(),
    );
  }

  Future getPlays() async{
    List temp = await _model.getAllPlays();
    _plays = temp.cast<PlayItem>();
  }

  Future<bool> buildReady() async{
    await getPlays();
    return true;
  }

  Widget _buildStatsTable(){
    return FutureBuilder(
        future: buildReady(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Play Time (s)"))
                ],
                rows: _plays!.map(
                        (play) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                              Text(play.date!)
                          ),
                          DataCell(
                              Text(play.playTime!)
                          ),
                        ]
                    )
                ).toList(),
              ),
            );
          }
          return const SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(),
          );
        }
    );
  }
}
