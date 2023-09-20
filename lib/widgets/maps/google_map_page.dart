// ignore_for_file: prefer_is_empty, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:app/constants.dart';
import 'package:app/widgets/app_bar.dart';

class GoogleMapPage extends StatefulWidget {
  final Function setLoc;
  const GoogleMapPage(this.setLoc, {Key? key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  bool loading = false;
  String myLocation = "Checking ...";
  double lat = 0;
  double lng = 0;
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];

  // ignore: prefer_const_constructors
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: const LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    getMyLocation();
  }

  void getMyLocation() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      String locationData = await Constants.getLocation();
      List<String> location = locationData.split(":");
      lat = double.tryParse(location[0]) ?? 0;
      lng = double.tryParse(location[1]) ?? 0;
      final CameraPosition myPosition =
          CameraPosition(target: LatLng(lat, lng), zoom: 19.151926040649414);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(myPosition));
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.length > 0) {
        bool found = false;
        placemarks.forEach((placeMark) async {
          if (!found && placeMark.locality != "" && placeMark.country != "") {
            var myLoc =
                placeMark.locality! + ", " + placeMark.country.toString();
            List<Marker> tempMarkers = [];
            tempMarkers.add(
              Marker(
                markerId: const MarkerId("myLoc"),
                position: (LatLng(lat, lng)),
                infoWindow: InfoWindow(
                  snippet: myLoc,
                  title: myLoc,
                ),
              ),
            );
            var tMarkers = await Constants.createMarkers(
                // get this checked with bhai
                tempMarkers,
                placemarks[0].locality.toString(),
                placemarks[0].country.toString());

            setState(() {
              myLocation = myLoc;
              markers = tMarkers;
              loading = false;
            });

            found = true;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to find your location, please try again later',
            ),
          ),
        );
        setState(() {
          loading = false;
        });
      }
    }
  }

  void save() {
    widget.setLoc(myLocation, lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.appBarPreferredHeight),
        child: myAppBarWithRoundedBackButton("My Location", context),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: GoogleMap(
                  markers: Set.of(markers),
                  mapType: MapType.satellite,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(child: const Text("Refresh"), onPressed: getMyLocation),
              ElevatedButton(child: const Text("Save"), onPressed: save),
            ],
          ),
        ],
      ),
    );
  }
}
