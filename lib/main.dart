import 'package:flutter/material.dart';
import './style.dart' as style;

void main() {
  runApp(MaterialApp(theme: style.theme, home: const MyApp()));
}

var a = TextStyle();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Instagram'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_box_outlined),
              iconSize: 30,
            )
          ],
          shape: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
        ),
        body: Text('안녕', style: a));
  }
}
