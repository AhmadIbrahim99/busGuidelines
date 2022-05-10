import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Radar extends StatefulWidget {
  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<Radar> {

  double _radar=50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Radar"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.radar),
            Text(_radar.round().toString()+"00 M"),
            Slider(value: _radar,
              onChanged: (va){
              setState(() {
                _radar = va;
              });
            },
            min: 0,
            max: 100,
            ),
            ElevatedButton(onPressed: (){
              FirebaseFirestore.instance.collection("radar").doc("range")
                  .set({
                "range": _radar.round()+0.1,
              });

            }, child: Text("Save"),style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),),
          ],
        ),
      ),
    );
  }

}
