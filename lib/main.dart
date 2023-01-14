import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const PhotoZone());
}

class PhotoZone extends StatelessWidget {
  const PhotoZone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Home(),
    );
  }
}
