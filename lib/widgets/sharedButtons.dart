import 'package:flutter/material.dart';

Widget defaultFormField({
  @required TextEditingController textEditingController,
  @required TextInputType type,
  bool isPassword=false,
  onSubmitted,
  onChange,
  @required validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  fSuffix,
})=>TextFormField(
  controller: textEditingController,
  keyboardType: type,
  onFieldSubmitted: onSubmitted,
  onChanged: onChange,
  obscureText: isPassword,
  decoration: InputDecoration(
    hintText: label,
    prefixIcon: Icon(prefix),
    suffixIcon: (suffix !=null )?IconButton(onPressed: fSuffix,icon: Icon(suffix)):null,
    border: OutlineInputBorder(),
  ),
  validator: validate,
);