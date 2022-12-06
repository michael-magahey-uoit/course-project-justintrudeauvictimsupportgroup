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
  bool _filter = false;
  String? _dateFilter;
  int? _sortColumnIndex;

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
                  _filter = true;
                  _dateFilter = "${value.year}-${value.month}-${value.day}";
                  getPlays();
                  setState(() {
                    _plays;
                  });
                });
              },
              icon: const Icon(Icons.sort),
              tooltip: "Choose a date to filter by.",
          ),
          IconButton(
              onPressed: (){
                _filter = false;
              },
              icon: const Icon(Icons.format_clear),
              tooltip: "Clear the date filter.",
          ),
        ],
      ),
      body: _buildStatsTable(),
    );
  }

  Future getPlays() async{
    List allPlays = await _model.getAllPlays();
    if(_filter == true){
      _plays = [];
      for(PlayItem play in allPlays){
        print("1.${play.date}  2.$_dateFilter");
        if(play.date == _dateFilter){
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
            return Row(
              children: 
              [
                Expanded(
                  child: SingleChildScrollView(
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
              ),
                ),
            ]
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
