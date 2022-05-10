import 'package:flutter/material.dart';

Material myItems(IconData iconData, String heading, Color color,context ,Widget widget){
  return Material(
    color: Colors.white,
    elevation: 14.0,
    shadowColor: Color(0x802196F3),
    borderRadius: BorderRadius.circular(24.0),
    child: TextButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget,));
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(heading, style: TextStyle(color: color,fontSize: 20)),
                  ),//text
                   Material(
                     color: color,
                     borderRadius: BorderRadius.circular(24.0),
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Icon(
                         iconData,
                         color: Colors.white,
                         size: 30.0,
                       ),
                     ),
                   ),//icon
                ],
              ),
            ],
          ),
        ),
      ),
    ),

  );
}