import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:uber_clone/screens/confirmdestination.dart';
import 'package:geocoding/geocoding.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyHomePageWidget();
  }
}

class MyHomePageWidget extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double latitude = 17.8898;
  double longitude = 87.0090;
  Set<Marker> marker = {};
  String userLocation = "";
  String address="";
  Future<bool> locationPermission() async {
    if (!await permission.Permission.location.isGranted) {
      permission.PermissionStatus status =
          await permission.Permission.location.request();
      if (status != permission.PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  
 

  Future<String> getLocation() async {
    bool hasPermission = await locationPermission();
    if (hasPermission) {
      try {
        var location = await Geolocator.getCurrentPosition();
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        userLocation = "${position.latitude},${position.longitude}";
        longitude = position.longitude;
        latitude = position.latitude;
        setState(() {});
        _getAddressFromLatLng(position);
        if (userLocation.isNotEmpty) {
          marker.add(Marker(
              markerId: const MarkerId("Id1"),
              position: createLatLngFromString(userLocation)));
        }
      } catch (e) {
        print(e.toString());
      }
    }
    return userLocation;
  }
   _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude
      );
      Placemark place = placemarks[0];
      setState(() {
        address = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  createLatLngFromString(String latitude) {
    var split = latitude.split(",");
    return LatLng(double.parse(split[0]), double.parse(split[1]));
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: GoogleMap(
                mapType: MapType.hybrid,
                markers: marker,
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude)),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmDestination(currentAddress: address,latitude: latitude,longitude: longitude,)));
              },
              child: Container(
                margin: const EdgeInsets.all(40),
                width: size.width * 0.9,
                height: size.width * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Icon(Icons.search, color: Colors.white, size: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Where to go",style: TextStyle(color: Colors.white,fontSize: size.height*0.02),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
