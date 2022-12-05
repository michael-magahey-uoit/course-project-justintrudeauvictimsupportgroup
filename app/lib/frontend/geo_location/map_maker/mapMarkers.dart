//import 'dart:js_util';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });
  List<MapMarker> locations = mapMarkers;

  List<MapMarker> addLocations(String? image, String? title, String? address, LatLng? location){
    List<MapMarker> newList = [];
    newList.add(MapMarker(image: image, title: title, address: address, location: location));

    return newList;
  }

  List<MapMarker> addStoredLocations(List<MapMarker> m){
    List<MapMarker> newList = [];
    for(int i = 0; i < mapMarkers.length; i++){
      newList.add(MapMarker(image: mapMarkers[i].image, title: mapMarkers[i].title, address: mapMarkers[i].address, location: mapMarkers[i].location));
    }

    return newList;
  }

  List<MapMarker> addMultipleLocations(List<MapMarker> m){
    List<MapMarker> newList = [];
    for(int i = 0; i < m.length; i++){
      newList.add(MapMarker(image: m[i].image, title: m[i].title, address: m[i].address, location: m[i].location));
    }

    return newList;
  }

  List<MapMarker> clearMapList(List<MapMarker> m){
    m.clear();
    return m;
  }
}

final mapMarkers = [
  MapMarker(
      image: 'clawmachine_test.png',
      title: 'Claw Machine Location.',
      address: '2000 Simcoe St N, Oshawa L1G 0C5, Canada',
      location: LatLng(43.944, -78.896)),
  MapMarker(
      image: 'clawmachine_test.png',
      title: 'McCoy\'s Burgers.',
      address: '2069 Simcoe St N, Oshawa, L1G 0C7, Canada',
      location: LatLng(43.961, -78.891)),
];