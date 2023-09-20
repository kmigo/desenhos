
import 'package:desenhos/src/map.dart';
import 'package:desenhos/src/quebracabeca.dart';
import 'package:desenhos/src/soccer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:   SoccerDrawn(),
    );
  }
}
