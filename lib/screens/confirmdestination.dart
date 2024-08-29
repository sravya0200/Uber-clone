import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uber_clone/screens/chooseautoscreen.dart';

class ConfirmDestination extends StatefulWidget {
  final String currentAddress;
  final double latitude;
  final double longitude;
  const ConfirmDestination(
      {super.key,
      required this.currentAddress,
      required this.latitude,
      required this.longitude});
  @override
  State<StatefulWidget> createState() {
    return ConfirmDestinationWidget();
  }
}

class ConfirmDestinationWidget extends State<ConfirmDestination> {
  TextEditingController searchController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  double dropLatitude = 0.0;
  double dropLongitude = 0.0;
  double getLatitude = 0.0;
  double getLongitude = 0.0;
  Future<void> dropCoordinates(String address) async {
    print("hii");
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        print("hello");
        dropLatitude = locations.first.latitude;
        dropLongitude = locations.first.longitude;
        print('Latitude: $dropLatitude, Longitude: $dropLongitude');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    searchController.text = widget.currentAddress;
    getLatitude = widget.latitude;
    getLongitude = widget.longitude;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          Container(
            margin: const EdgeInsets.all(15),
            width: size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
                textAlign: TextAlign.center,
                controller: searchController,
                onChanged: (val) {
                  setState(() {});
                },
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: InkWell(
                        onTap: () {
                          searchController.clear();
                        },
                        child: Icon(
                          Icons.clear_outlined,
                          size: searchController.text.isEmpty ? 0 : 24,
                          color: Colors.black,
                        )))),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Container(
            margin: const EdgeInsets.all(15),
            width: size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black)),
            child: TextFormField(
                textAlign: TextAlign.center,
                controller: destinationController,
                onChanged: (val) {
                  setState(() {});
                },
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    hintText: "Enter Your Destination Location",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: InkWell(
                        onTap: () {
                          destinationController.clear();
                        },
                        child: Icon(
                          Icons.clear_outlined,
                          size: destinationController.text.isEmpty ? 0 : 24,
                          color: Colors.black,
                        )))),
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              getCoordinates(searchController.text);
              dropCoordinates(destinationController.text);
              if (dropLatitude != 0.0 &&
                  dropLongitude != 0.0 &&
                  getLatitude != 0.0 &&
                  getLongitude != 0.0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChooseAutoScreen(
                              currentLatitude: getLatitude,
                              currentLongitude: getLongitude,
                              dropLatitude: dropLatitude,
                              dropLongitude: dropLongitude,
                            )));
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: size.width * 0.7,
              height: size.height * 0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey),
              child: Text(
                "Confirm Pickup",
                style: TextStyle(
                    color: Colors.white, fontSize: size.height * 0.025),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          )
        ],
      ),
    );
  }

  Future<void> getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        getLatitude = locations.first.latitude;
        getLongitude = locations.first.longitude;
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
