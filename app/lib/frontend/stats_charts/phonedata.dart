import 'package:cloud_firestore/cloud_firestore.dart';

class Phones {
  /**
   * Class for datatype phones from Firebase
   * name is the type of phone
   * num is the quantity that type has
   */
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
