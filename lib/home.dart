import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';

var socket;
bool connect_state = false;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (connect_state == false)
            ? Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.red,
              )
            : Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
              ),
        title: Text("Photo Zone Remote"),
        actions: [
          IconButton(
              onPressed: () async {
                if (!connect_state) {
                  socket = await Socket.connect('192.168.0.4', 8995);
                  setState(() {
                    socket.add(utf8.encode('smart-phone'));
                    connect_state = true;
                    show_snackbar("서버에 연결되었습니다.");
                  });
                } else {
                  setState(() {
                    socket.close();
                    connect_state = false;
                    show_snackbar("서버와 연결이 해제되었습니다.");
                  });
                }
              },
              icon: (connect_state == false)
                  ? Icon(Icons.toggle_off_outlined)
                  : Icon(Icons.toggle_on_outlined)),
        ],
      ),
      body: Container(
        child: Center(
            child: Column(
          children: [
            TextButton(onPressed: () async {}, child: Text("button")),
            TextButton(
              onPressed: () {
                setState(() {});
              },
              child: Text("close"),
            )
          ],
        )),
      ),
    );
  }

  void show_snackbar(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
