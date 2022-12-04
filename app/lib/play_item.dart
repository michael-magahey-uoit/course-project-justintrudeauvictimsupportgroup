class PlayItem{
  int? id;
  String? date;
  String? playTime;

  PlayItem({this.id, this.date, this.playTime});

  PlayItem.fromMap(Map map){
    this.id = map['id'];
    this.date = map['date'];
    this.playTime = map['playTime'];
  }

  Map<String, Object?> toMap(){
    return{
      'id': this.id,
      'date': this.date,
      'playTime': this.playTime
    };
  }
}