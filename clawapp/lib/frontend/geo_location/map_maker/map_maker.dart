import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'constants.dart';
import 'mapMarkers.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// Future<IP> fetchAlbum() async {
//   final response = await http.get(Uri.parse('http://10.0.2.2:80/location'));
//
//   // Appropriate action depending upon the
//   // server response
//   if (response.statusCode == 200) {
//     return IP.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load album');
//   }
// }

// class IP {
// }

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  List<MapMarker> locations = [];
  late MapController mapController;
  late Position currPosition;
  var currentLocation = AppConstants.myLocation;

  //create a function to randomly change locations
  randomLocationsChange(LatLng newMark) {
    mapController.move(newMark, 15);
  }

  //initialize map controller and the initialstate
  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    //call for geolocation tracking
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);
    Geolocator.checkPermission().then((LocationPermission permission) {
      //output to console
      print("Location permission: $permission");
    });

    //output the map look and tracking functions
    return Scaffold(
      //call the function which generates a map
      body: generateMap(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.orange,
        backgroundColor: Colors.orange,
        onPressed: () {
          //call the function that grabs the addresses
          getAddress();
        },
        child: const Icon(
          Icons.add_location,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget generateMap() {
    List<LatLng> trackers = [];

    //call for geolocation tracking
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);
    Geolocator.checkPermission().then((LocationPermission permission) {
      //output to console
      print("Location permission: $permission");
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 250, 140, 0),
        title: const Text('Claw Machines Locator'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 13,
              center: AppConstants.myLocation,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/haarisahmed/clabxwqi8002j15nsc4fpay2x/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGFhcmlzYWhtZWQiLCJhIjoiY2xhYnhmc2I0MDR4MjNycGUzaHl5ZmQ3YSJ9.wP2USfn6Uhyto8qnogGhuQ',
                additionalOptions: {
                  'mapStyleId': AppConstants.mapBoxStyleId,
                  'accessToken': AppConstants.mapBoxAccessToken,
                },
              ),
              MarkerLayerOptions(
                markers: [
                  for (int i = 0; i < mapMarkers.length; i++)
                    Marker(
                      height: 40,
                      width: 40,
                      point: mapMarkers[i].location ?? AppConstants.myLocation,
                      builder: (_) {
                        return Container(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                pageController.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                selectedIndex = i;
                                currentLocation = mapMarkers[i].location!;
                              });
                            },
                            icon: Icon(
                              Icons.location_on,
                              color: selectedIndex == i
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            iconSize: 50,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 60,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              controller: pageController,
              itemCount: mapMarkers.length,
              onPageChanged: (value) {
                setState(() {
                  selectedIndex = value;
                  currentLocation = mapMarkers[value].location!;
                  _animatedMapMove(currentLocation, 11.5);
                });
              },
              itemBuilder: (context, index) {
                var item = mapMarkers[index];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color.fromARGB(180, 250, 140, 0),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.title ?? '',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item.address ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                  'https://i.ebayimg.com/images/g/w2wAAOSwBYtg69oT/s-l1600.jpg'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  getAddress() async {
    //create a variable to grab the current position
    Position currPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(currPos);

    //create a main list that will be the locations where the markers are placed
    final List<Placemark> marks =
        await placemarkFromCoordinates(currPos.latitude, currPos.longitude);

    //get a new position
    LatLng newMark = LatLng(currPos.latitude, currPos.longitude);

    //new places will be at the beginning
    MapMarker newArea = MapMarker(
        image: 'person.jpg',
        title: 'Your Location',
        address: "${marks[0].subThoroughfare} ${marks[0].thoroughfare}",
        location: newMark);

    //create a set state to show new information
    setState(() {
      //add a location to the map
      mapMarkers.add(newArea);
    });

    //call random locations function
    randomLocationsChange(newMark);

    print('${newArea}');
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
