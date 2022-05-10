import 'package:flutter/material.dart';

void changeScreen(BuildContext context,Widget widget){
  Navigator.push(context,MaterialPageRoute(builder: (context) => widget));
}

void changeScreenReplacement(BuildContext context,Widget widget){
  Navigator.pop(context);
  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => widget));
}
void changeScreenReplaceUntil(BuildContext context,Widget widget){
  Navigator.pop(context);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
    return widget;
  }), (route) => false);
}
