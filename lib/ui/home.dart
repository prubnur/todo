import 'package:flutter/material.dart';
import 'package:notodo/ui/notodo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("NoToDo"),
        backgroundColor: Colors.black54,
        centerTitle: true,
      ),
      body: new NoToDoScreen(),
    );
  }
}
