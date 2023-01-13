import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';

var socket;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AppBar")),
      body: Container(
        child: Center(
            child: Column(
          children: [
            TextButton(
                onPressed: () async {
                  socket = await Socket.connect('192.168.0.4', 8995);
                  print('connected');

                  // listen to the received data event stream
                  socket.listen((List<int> event) {
                    print(utf8.decode(event));
                  });

                  // send hello
                  socket.add(utf8.encode('hello'));
                },
                child: Text("button")),
            TextButton(
              onPressed: () async {
                // .. and close the socket
                socket.close();
              },
              child: Text("close"),
            )
          ],
        )),
      ),
    );
  }
}
