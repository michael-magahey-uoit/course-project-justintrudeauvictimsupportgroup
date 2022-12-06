import 'package:flutter/material.dart';
import 'package:claw/frontend/geo_location/map_maker/mapMarkers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class winnerLocationPage extends StatefulWidget {
  const winnerLocationPage({Key? key}) : super(key: key);
  @override
  State<winnerLocationPage> createState() => _winnerLocationPageState();
}

class _winnerLocationPageState extends State<winnerLocationPage> {
  List<MapMarker> currentRecordedLocation = [];

  @override
  Widget build(BuildContext context){

    //call for geolocation tracking
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);
    Geolocator.checkPermission().then(
            (LocationPermission permission){
          //output to console
          print("Location permission: $permission");
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Page'),
        backgroundColor: const Color.fromARGB(250, 250, 140, 0),
      ),
      body: buildForm(context),
    );
  }
  @override
  Widget buildForm(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    String? submittedLoc;
    LatLng latLng;

    return Form(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              width: width,
              child: TextFormField(
                style: const TextStyle(fontSize: 19),
                decoration: const InputDecoration(
                  label: Text('Enter Your Current Address Location'),
                  hintText: "2000 Simcoe St N, Oshawa L1G 0C5, Canada",
                  contentPadding: EdgeInsets.all(15.0),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey,
                ),
                onChanged: (String? value){
                  submittedLoc = value;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  //add location
                  latLng = await getCoordinates();

                  currentRecordedLocation.add(MapMarker(image: 'person.jpg', title: 'Your Location', address: submittedLoc, location: LatLng(latLng.latitude, latLng.longitude)));

                  Navigator.of(context).pop(currentRecordedLocation);
                },
                child: const Text("Submit")
            )
          ],
        )
    );
  }

  Future<LatLng> getCoordinates() async {

    //create a variable to grab the current position
    Position currPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    //print(currPos);

    //get a new position
    LatLng newMark =LatLng(
        currPos.latitude,
        currPos.longitude
    );

    return newMark;
  }
}