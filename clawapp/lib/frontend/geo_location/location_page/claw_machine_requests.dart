import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

//create a class to get the location of the claw machine
class ClawIPInfo{
  String? ClawIP;

  static Future<String?> getClawIP() async{
    try {
      final url = Uri.parse('http://10.102.61.3/location');
      final response = await http.get(url);

      return response.statusCode == 200 ? response.body : null;
    } on Exception catch (e) {
      return null;
    }
  }
}