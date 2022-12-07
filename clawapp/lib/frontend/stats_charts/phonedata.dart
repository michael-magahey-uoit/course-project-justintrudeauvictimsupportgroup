import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Classes for data from firebase
 * to be used for pie and line charts
 */
class Phones {
  String? name;
  double? num;
  DocumentReference? reference;

  Phones.fromMap(var map, {this.reference}) {
    this.name = map['key'];
    this.num = map['value'];
  }

  Map<String, Object?> toMap() {
    return {
      'key': this.name,
      'value': this.num,
    };
  }
}

class ChartData {
  int? index;
  double? yValue;
  DocumentReference? reference;

  ChartData.fromMap(var map, {this.reference}) {
    this.yValue = map['time'];
  }
}
