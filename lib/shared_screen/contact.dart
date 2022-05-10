import 'package:flutter/material.dart';

class Contact extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Contact"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
      children: [
      ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: NetworkImage(
              "https://img.icons8.com/bubbles/100/000000/actor.png"),
          fit: BoxFit.cover,
          width: 150,
          height: 150,
        ),
      ),
    ),
    SizedBox(
    height: 24,
    ),
        Text("@2021 || #Ahmad Ibrahim"),
        SizedBox(
    height: 8,
    ),
        Text("0595722756 || 0597674243"),
    ],
    ),
      ),
    );
  }
}
