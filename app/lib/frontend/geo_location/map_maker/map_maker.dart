import 'package:claw/frontend/geo_location/location_page/locations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'constants.dart';
import 'mapMarkers.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<IP> fetchAlbum() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:80/location'));

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return IP.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 250, 140, 0),
        title: const Text('Claw Machines Locator'),
        actions: [
          IconButton(
            tooltip: "Get Your Current Location",
              onPressed: () async{
                MapMarker currLocation = await Navigator.pushNamed(context, '/getLocation') as MapMarker;

                //add current marker to map marker
                //mapMarkers.add(MapMarker(image: currLocation.image, title: currLocation.title, address: currLocation.address, location: currLocation.location));
                print(currLocation.title);
                print(currLocation.address);
                print(currLocation.location);
              },
              icon: const Icon(Icons.location_searching)
          )
        ],

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
            bottom: 2,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (value) {},
              itemCount: mapMarkers.length,
              itemBuilder: (_, index) {
                final item = mapMarkers[index];
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
}