import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ChooseAutoScreen extends StatefulWidget {
  final double currentLatitude;
  final double currentLongitude;
  final double dropLatitude;
  final double dropLongitude;
  const ChooseAutoScreen(
      {super.key,
      required this.currentLatitude,
      required this.currentLongitude,
      required this.dropLatitude,
      required this.dropLongitude});
  @override
  State<StatefulWidget> createState() {
    return ChooseAutoScreenWidget();
  }
}

class ChooseAutoScreenWidget extends State<ChooseAutoScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  DateTime date = DateTime.now();
  int selectedIndex = 0;
  Map<PolylineId, Polyline> polylines = {};
   @override
  void initState() {
    super.initState();
    _getPolyline();
  }
  @override
  Widget build(BuildContext context)  {
    Set<Marker> marker = {
      Marker(
        markerId: MarkerId('start'),
        position: LatLng(widget.currentLatitude, widget.currentLongitude),
        infoWindow: InfoWindow(title: 'My Location'),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: LatLng(widget.dropLatitude, widget.dropLongitude),
        infoWindow: InfoWindow(title: 'End Location'),
      ),
    };
    
    String time = DateFormat.jm().format(date);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: GoogleMap(
                mapType: MapType.hybrid,
                markers: marker,
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.currentLatitude, widget.currentLongitude),zoom: 5),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.black,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
          ),
          DraggableScrollableSheet(
            builder: (BuildContext context, scrollController) {
              return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          child: ListTile(
                            onTap: () {
                              setState(() {});
                              selectedIndex = index;
                            },
                            shape: Border.all(color: Colors.white, width: 20),
                            leading: Image.asset("assets/auto.png"),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "Uber Auto",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "3",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 32, 22, 22)),
                                    )
                                  ],
                                ),
                                Text(
                                  "${time}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "2 mins Away",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            trailing: Text(
                              "\u{20B9} 98.10",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }));
            },
          ),
          Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                height: size.height * 0.12,
                color: Colors.black,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        const Icon(
                          Icons.money_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        const Text(
                          "Cash",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: size.height * 0.02,
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: size.width * 0.9,
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.8)),
                      child: Text(
                        "Choose Uber Auto",
                        style: TextStyle(fontSize: size.height * 0.02),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
   _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCqvFeXeNMAHIHJK5Abq17UBN42V5ZYmWw",
      PointLatLng(widget.currentLatitude, widget.currentLongitude),
      PointLatLng(widget.dropLatitude, widget.dropLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      PolylineId id = PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      );
      polylines[id] = polyline;
    });
  }
}
