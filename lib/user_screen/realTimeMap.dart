import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stalker/helpers/commons.dart';
import 'package:stalker/widgets/dialog.dart';

class LiveMapBroadcast extends StatefulWidget {
  @override
  _LiveMapBroadcastState createState() => _LiveMapBroadcastState();
}

class _LiveMapBroadcastState extends State<LiveMapBroadcast> {

  //notification
  FlutterLocalNotificationsPlugin localNotificationsPlugin;
  //end


  bool isPressed=false;
  
  CollectionReference _getBussByDriver= FirebaseFirestore.instance.collection("buss");


  final range=FirebaseFirestore.instance.collection("radar");
  GoogleMapController _controller ;
  var filterDistance;

  //double maxRadar=2000.0;
  double radar=0.0;
  double maxRadar=100;
  DocumentSnapshot getRange;

  //get the closest bus
  List<double> allDistance=[];
  Map<String,double>allDistanceMap= {'Ahmad Ibrahim Abo Naja':5648976545679878648975648.0};
  double closestBus;
//end
  documentSnapshot() async {
    getRange= await FirebaseFirestore.instance.collection("radar").doc("range").get();
    maxRadar= getRange['range'] as double;
  }

  double myLat;
  double myLong;

  @override
  void initState() {
    documentSnapshot();

    FirebaseFirestore.instance.collection("radar").snapshots().listen((event) {
      event.docChanges.forEach((element) {
        maxRadar = element.doc.data()['range'];
      });
    });

      /*
      *
      * FirebaseFirestore.instance.collection("driver").snapshots().listen((event) {
        event.docChanges.forEach((change) {
          print("I am Here .............1");
          setState(() {
//here we can define the range between user and buss so any buss after this range will be not seen
            if(Geolocator.distanceBetween(myLat, myLong,
                change.doc.data()['location'].latitude, change.doc.data()['location'].longitude) >(radar*100)){

              markers.removeWhere((element) => element.markerId.toString().contains(change.doc.id.toString()));
              print("I am Here .............remove");
              return ;
            }else{
              print("I am Here .............add");
              markers.add(
                Marker(
                  markerId: MarkerId(change.doc.id),
                  infoWindow: InfoWindow(
                    title:change.doc.data()['name'].toString(),
                    snippet:
                    (Geolocator.distanceBetween(myLat, myLong,
                        change.doc.data()['location'].latitude, change.doc.data()['location'].longitude)).round().toString() + " M",
                  ),visible: (change.doc.data()['check'])?true:false,
                  position: LatLng(change.doc.data()['location'].latitude,change.doc.data()['location'].longitude ),
                ),
              );

              return ;
            }
            //end
          });
        });
      });*/

    super.initState();

    var androidInitialize= new AndroidInitializationSettings('busguide');
    var iosInitialize=new IOSInitializationSettings();
    var initializationSettings= new InitializationSettings(android: androidInitialize,iOS: iosInitialize);
    localNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(initializationSettings);

  }


  //here the List we will get the Locations Of Busses from fire base an set it here
  List<Marker> markers = [
    Marker(markerId: MarkerId('0'),),
  ];
  //end

  //this variable for User Location and live location
  StreamSubscription _locationSubcription;
  Location _locationTracker = Location();
  Circle circle;
  //end

 //here we did normal CameraPosition
  static final CameraPosition initialLocation =
  CameraPosition(target: LatLng(31.2882978, 34.2540296), zoom: 18);
//end

  //here we get the Icon Marker
  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/userlocation.png");
    return byteData.buffer.asUint8List();
  }
  //end

  //here we updateMarkerAndCircle  Of The user
  void updateMarkerAndCircle(
      LocationData newLocationData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocationData.latitude, newLocationData.longitude);
   this.setState(() {
     markers.insert(0, Marker(
       markerId: MarkerId("user"),
       infoWindow: InfoWindow(
         title: "You'r Location",
       ),
       position: latLng,
       icon: BitmapDescriptor.fromBytes(imageData),
     ));

      circle = Circle(
         circleId: CircleId("user"),
         //radius: newLocationData.accuracy,
         radius: radar*100,
         strokeColor: Colors.blue,
         center: latLng,
         fillColor: Colors.blue.withAlpha(70),
       );


   });
  }
//end

  //here we get The Current Location  Of the User
  void getCurrentLocation() async {

    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      myLat=location.latitude;
      myLong=location.longitude;

      updateMarkerAndCircle(location, imageData);


      if (_controller != null) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.833490139799,
              target:LatLng(location.latitude, location.longitude),
              tilt: 0,
              zoom: 18
          )));
        updateMarkerAndCircle(location, imageData);
      }
      if (_locationSubcription != null) {
        _locationSubcription.cancel();
      }

      _locationSubcription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
           /* if (_controller != null) {
              _controller.animateCamera(CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 192.833490139799,
                      target:LatLng(newLocalData.latitude, newLocalData.longitude),
                      tilt: 0,
                      zoom: 18
                  )));

            }*/
          });
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED"){
        debugPrint("Permission Denied");
      }
    }
  }


// For Navigation Bar

  Future<Uint8List> customMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  Uint8List busMarker;

  @override
  Future<void> setState(VoidCallback fn) async {
     busMarker = await customMarker();
    super.setState(fn);
  }



  //controll
  bool notifiShow=true;

  Future _drawNotification(var number)async{


    var androidDetails= new AndroidNotificationDetails("channelId", "Bus Guide", "There is ${number} buses nearest You",importance: Importance.high);
    var iosDetails= new IOSNotificationDetails();
    var generalNotifi=
    new NotificationDetails(android: androidDetails,iOS: iosDetails);
    if(notifiShow){
      await localNotificationsPlugin.show(0, "Bus Guide", "There Is Bus Nearest You ${number} M", generalNotifi);
    }else{
      Timer(Duration(seconds: 1+3), () async {
        await localNotificationsPlugin.show(0, "Bus Guide", "There Is Bus Nearest You ${number} M", generalNotifi);
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController googleMapController){
          _controller = googleMapController;
        },
        markers: markers.toSet(),
        circles: Set.of((circle != null) ? [circle] : []),
      ),
      floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        (closestBus != null && radar !=0  && allDistanceMap.length>1)?Text("The Nearest Bus : "+((closestBus).round().toString()) +" M",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),):Text(""),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FloatingActionButton(
                child: Icon(Icons.location_searching),
                onPressed: () {
                  getCurrentLocation();
                },
              ),
            ),
            (myLat != null)? Column(
              children: [
                Text((radar*100).round().toString()+" M",style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 24),),
                Slider(value:(radar > maxRadar)? maxRadar : radar,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.red,
                  onChanged: (va){
                    setState(() {
                      radar = va;
                      if(myLat != null){
                        circle = Circle(
                          circleId: CircleId("user"),
                          //radius: newLocationData.accuracy,
                          radius: radar*100,
                          strokeColor: Colors.blue,
                          center: LatLng(myLat,myLong),
                          fillColor: Colors.blue.withAlpha(70),
                        );
                      }
                      _getBussByDriver.snapshots().listen((event) {
                        event.docChanges.forEach((change) {
                          setState(() {
//here we can define the range between user and buss so any buss after this range will be not seen
                            if(Geolocator.distanceBetween(myLat, myLong,
                                change.doc.data()['location'].latitude,
                                change.doc.data()['location'].longitude) >(radar*100) ||
                                change.doc.data()['check'] == true ){
                              markers.removeWhere((element) => element.markerId.toString().contains(change.doc.id.toString()));
                              allDistanceMap.removeWhere((key, value) => key.contains(change.doc.id.toString()));

                              closestBus = allDistanceMap.values.reduce(min);

                              return ;

                            }else{//here is the Code to get location Of buses and nearest Bus
                              allDistanceMap.addAll({
                                change.doc.id.toString() : Geolocator.distanceBetween(myLat, myLong,
                                    change.doc.data()['location'].latitude, change.doc.data()['location'].longitude),
                              });
                              print(allDistanceMap.length);
                              closestBus = allDistanceMap.values.reduce(min);//the Closest Bus here
                              markers.add(
                                Marker(
                                  draggable: false,
                                  zIndex: 2,
                                  flat: true,
                                  rotation: change.doc.data()['newLocalData'],
                                  icon: BitmapDescriptor.fromBytes(busMarker),
                                  markerId: MarkerId(change.doc.id.toString()),
                                  infoWindow: InfoWindow(
                                    anchor: Offset(0.5, 0.5),
                                    title:change.doc.data()['name'].toString(),
                                    onTap:(){
                                      showDiverDialog(context,change.doc.data()['buss_title'],change.doc.data()['buss_description'],change.doc.data()['driver_number'],change.doc.data()['name']);},
                                    snippet:"Click Here , "+
                                    (Geolocator.distanceBetween(myLat, myLong,
                                        change.doc.data()['location'].latitude, change.doc.data()['location'].longitude)).round().toString() + " M",
                                  ),/*visible: (change.doc.data()['check'])?true:false,*/
                                  position: LatLng(change.doc.data()['location'].latitude,change.doc.data()['location'].longitude ),
                                ),
                              );
                              //only one time if i use bool
                              if(closestBus<200 && notifiShow){
                                _drawNotification(closestBus.round());
                                notifiShow=!notifiShow;
                              }/*else if(closestBus<1200 && !notifiShow){
                                _drawNotification(closestBus.round());
                                return ;
                              }*/
                              return ;
                            }
                            //end
                          });
                        });
                      });
                    });
                  },

                  min: 0,
                  max: maxRadar,
                ),
              ],
            ):Text(''),

          ],
        ),
      ],
    ),
    );
  }
}


