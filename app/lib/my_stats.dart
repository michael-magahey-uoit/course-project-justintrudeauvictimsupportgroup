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
  var snackBar = const SnackBar(
    content: Text("Filter Cleared.",
      style: TextStyle(fontSize: 20),
    ),
  );

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
          //A button that when pressed brings up a date picker that allows
          //the user to pick a date they want to filter the results they see
          //in the datatable to.
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
          //Simple button that clears the filter set by the user
          IconButton(
              onPressed: (){
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _filter = false;
                getPlays();
                setState(() {
                  _plays;
                });
              },
              icon: const Icon(Icons.format_clear),
              tooltip: "Clear the date filter.",
          ),
        ],
      ),
      body: _buildStatsTable(),
    );
  }

  //Sets the list of plays to be all plays in the local database
  //if no filter is active, if there is a filter only
  //adds the plays that match the filtered date
  Future getPlays() async{
    List allPlays = await _model.getAllPlays();
    if(_filter == true){
      _plays = [];
      for(PlayItem play in allPlays){
        if(play.date == _dateFilter){
          _plays?.add(play);
        }
      }
    }
    else {
      _plays = allPlays.cast<PlayItem>();
    }
  }

  //Checks if the datatable is ready to build
  Future<bool> buildReady() async{
    await getPlays();
    return true;
  }

  //Returns a datatable that shows the day the user played as well
  //as how long they played for
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
                      DataColumn(
                          label: Text("Date", style: TextStyle(fontSize: 20)),
                        tooltip: "Date played"
                      ),
                      DataColumn(
                          label: Text("Play Time (s)", style: TextStyle(fontSize: 20)),
                        tooltip: "Time played for in seconds"
                      )
                    ],
                    rows: _plays!.map(
                            (play) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                  Text(play.date!, style: const TextStyle(fontSize: 20))
                              ),
                              DataCell(
                                  Text(play.playTime!, style: const TextStyle(fontSize: 20))
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
          //If the data table isn't ready display a leading icon
          return const SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(),
          );
        }
    );
  }
}
