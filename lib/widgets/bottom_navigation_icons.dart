import 'package:flutter/material.dart';

import 'custom_text.dart';

class BottomNavIcon extends StatelessWidget {
  final String name;
  final IconData image;
  final Function onTap;

  const BottomNavIcon({Key key, this.name, this.image, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap ?? null,
        child: Column(
          children: [
            Icon(
              image,
              size: 26,
            ),
            SizedBox(height: 2.5,),
            CustomText(text: name),
          ],
        ),
      ),
    );
  }
}
