import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalker/helpers/commons.dart';
import 'package:stalker/providers/user.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool isFull = false;
  bool isTracking=false;

  List<GeoPoint> geoPoint =[];
  StreamSubscription _locationSubcription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;



  static final CameraPosition initialLocation =
      CameraPosition(target: LatLng(31.2882978, 34.2540296), zoom: 14);

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      LocationData newLocationData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocationData.latitude, newLocationData.longitude);
    this.setState(() {
      marker = Marker(
        markerId: MarkerId("home"),
        position: latLng,
        rotation: newLocationData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData),
      );

      circle = Circle(
        circleId: CircleId("car"),
        radius: newLocationData.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latLng,
        fillColor: Colors.blue.withAlpha(70),
      );
    });
  }

  //here we getCurrentLocation of Driver And Sen it to FireStore
  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubcription != null) {
        _locationSubcription.cancel();
      }

      //here we go
      _locationSubcription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
            if (_controller != null) {
              _controller.animateCamera(CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 192.833490139799,
                      target:LatLng(newLocalData.latitude, newLocalData.longitude),
                      tilt: 0,
                      zoom: 18
                  )));
              updateMarkerAndCircle(newLocalData, imageData);
            }
            //the code to do list and save all GeoPoint on It And After That Send Al the List To FireStore In Same Time
            geoPoint.add(GeoPoint(newLocalData.latitude,newLocalData.longitude));

//here we store life location in fire base fire store
           FirebaseFirestore.instance.collection('buss').doc(UserProvider.userModel.id).update(
               {
                 'name' : UserProvider.userModel.name,
                 'location' : GeoPoint(newLocalData.latitude,newLocalData.longitude),
                 'check' : isFull,
                 "route" : geoPoint,
                 "newLocalData":newLocalData.heading,
               });
//end

      });
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED"){
        debugPrint("Permission Denied");
      }
    }
  }


  @override
  void dispose() {
    if (_locationSubcription != null) {
      _locationSubcription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: DriverDrawer(),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController googleMapController) {
          _controller = googleMapController;
        },
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.height*0.03,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: Icon(Icons.location_searching),
              onPressed: () {
                getCurrentLocation();
                isTracking=true;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:(isTracking)? FloatingActionButton(onPressed: (){
              setState(() {
                if(isFull){
                  isFull=false;
                  FirebaseFirestore.instance.collection('buss').doc(UserProvider.userModel.id).update(
                      {
                        'check' : isFull,
                      });
                }else{
                  isFull=true;
                  FirebaseFirestore.instance.collection('buss').doc(UserProvider.userModel.id).update(
                      {
                        'check' : isFull,
                      });
                }
              });
            },child:(!isFull)? Icon(Icons.disc_full_outlined):Icon(Icons.disc_full,color: red,),):null,
          ),
        ],
      ),
    );
  }
}

/*
var myMarkers = HashSet<Marker>();
  BitmapDescriptor customMarker;
  List<Polyline> myPolyline = [];

  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/bussmarker.png');
  }

  @override
  void initState() {
    super.initState();
    getCustomMarker();
    createPolyline();
  }

  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = new List<LatLng>();
    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08332357078792));
    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));

    Set<Polygon> polygonSet = new Set<Polygon>();
    polygonSet.add(Polygon(
        polygonId: PolygonId('1'),
        strokeWidth: 1,
        points: polygonCoords,
        strokeColor: Colors.red));

    return polygonSet;
  }

  createPolyline() {
    myPolyline.add(
      Polyline(
        polylineId: PolylineId("1"),
        color: Colors.blue,
        width: 3,
        points: [LatLng(31.287, 34.25952),LatLng(31.280, 34.25952)],
        patterns: [PatternItem.dot/*PatternItem.dash(20),PatternItem.gap(10)*/],
      ),
    );
  }

  Set<Circle> myCircle = Set.from([
    Circle(
      circleId: CircleId("1"),
      center: LatLng(31.287, 34.25952),
      radius: 500,
      strokeWidth: 1,
    )
  ]);
 //here is the google map
 GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(31.287, 34.25952),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController googleMapController) {
          setState(() {
            myMarkers.add(
              Marker(
                icon: customMarker,
                onTap: () {
                  print("object");
                },
                markerId: MarkerId('1'),
                position: LatLng(31.287, 34.25952),
                infoWindow: InfoWindow(
                  title: "start",
                  snippet: "Here We Go",
                  onTap: () {
                    print("printed");
                  },
                ),
              ),
            );
          });
        },
        markers: myMarkers,
        polygons: myPolygon(),
        circles: myCircle,
        polylines: myPolyline.toSet(),
      ),
 */
