import 'package:flutter/material.dart';
import 'package:notodo/ui/home.dart';

void main () {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NoToDo',
    home: new Home(),
  ));
}