import 'play_item.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'db_utils.dart';

class PlayModel {
  Future<int> insertPlay(PlayItem playItem) async{
    final db = await DBUtils.init();
    return db.insert(
        'play_items',
        playItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future getAllPlays() async{
    final db = await DBUtils.init();
    final List maps = await db.query('play_items');
    List result = [];
    if(maps.isNotEmpty){
      for(int i = 0; i < maps.length; i++){
        result.add(PlayItem.fromMap(maps[i]));
      }
    }
    return result;
  }
}