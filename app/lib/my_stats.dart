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
  bool filter = false;
  String? dateFilter;

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
              onPressed: (){
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    helpText: "Pick a date you want to see your plays on"
                ).then((value){
                  if(value == null){
                    return;
                  }
                  filter = true;
                  dateFilter = "${value!.year}-${value!.month}-${value!.day}";
                  getPlays();
                  setState(() {
                    _plays;
                  });
                });
              },
              icon: const Icon(Icons.sort)
          ),
          IconButton(
              onPressed: (){
                _model.insertPlay(PlayItem(date: "2021-7-17", playTime: "40"));
                _model.insertPlay(PlayItem(date: "2021-9-19", playTime: "35"));
                _model.insertPlay(PlayItem(date: "2021-12-4", playTime: "23"));
                _model.insertPlay(PlayItem(date: "2021-12-5", playTime: "32"));
                _model.insertPlay(PlayItem(date: "2021-12-6", playTime: "40"));
                _model.insertPlay(PlayItem(date: "2022-4-22", playTime: "12"));
                _model.insertPlay(PlayItem(date: "2022-11-14", playTime: "33"));
                _model.insertPlay(PlayItem(date: "2022-11-14", playTime: "14"));
                _model.insertPlay(PlayItem(date: "2022-11-14", playTime: "37"));
              },
              icon: Icon(Icons.format_clear)
          ),
        ],
      ),
      body: _buildStatsTable(),
    );
  }

  Future getPlays() async{
    List allPlays = await _model.getAllPlays();
    if(filter == true){
      _plays = [];
      for(PlayItem play in allPlays){
        print("1.${play.date}  2.$dateFilter");
        if(play.date == dateFilter){
          _plays?.add(play);
        }
      }
    }
    else {
      _plays = allPlays.cast<PlayItem>();
    }
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
