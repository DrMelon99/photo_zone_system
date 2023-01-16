import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';

String host_ip = "192.168.0.29";
int host_port = 8995;
var socket;
bool connect_state = false;
String image_path = "";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> images_path = <String>[
    'images/init_image.jpg',
    'images/ocean_image.jpg',
    'images/couple_image.jpg',
    'images/family_image.jpg'
  ];
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
                  socket = await Socket.connect(host_ip, host_port);
                  setState(() {
                    connect_state = true;
                    socket_send_data('smart-phone');
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
        child: Column(
          children: [
            _InfoWidget(context, image_path),
            Expanded(
              child: SizedBox(),
            ),
            Card(
              color: Colors.amber[200],
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      image_button(images_path[0]),
                      image_button(images_path[1]),
                      image_button(images_path[2]),
                      image_button(images_path[3]),
                    ],
                  ),
                ),
              ),
            ),
            Container(height: MediaQuery.of(context).size.height / 30),
            Divider(height: 2, color: Colors.black26),
            Container(
              child: Text('Copyright 2023 HCI All right reserved.',
                  style: TextStyle(fontSize: 14, color: Colors.black38)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            )
          ],
        ),
      ),
    );
  }

  Widget _InfoWidget(BuildContext context, String path) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.image_search_rounded,
                      size: 18, color: Colors.black),
                  Text('  현재 이미지', style: TextStyle(fontSize: 15)),
                  Spacer(),
                  Icon(Icons.more_vert, size: 18, color: Colors.black54),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: IconButton(
                      icon: (image_path == "")
                          ? Icon(Icons.image)
                          : Image.asset(image_path),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 2, color: Colors.black26),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.history, size: 16, color: Colors.black38),
                  Text('  $path',
                      style: TextStyle(fontSize: 14, color: Colors.black38)),
                  Spacer(),
                  Icon(Icons.chevron_right, size: 16, color: Colors.black38),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            )
          ],
        ),
      ),
    );
  }

  Widget image_button(String path) {
    return Card(
      child: Container(
          width: 100,
          height: 70,
          child: IconButton(
              onPressed: () {
                setState(() {
                  image_path = path;
                  int cnt = 0;
                  images_path.forEach((img_path) {
                    if (path == img_path) {
                      socket_send_data('$cnt');
                    }
                    cnt++;
                  });
                  print(path);
                });
              },
              icon: Image.asset(path))),
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

  void socket_send_data(String data) {
    socket.add(utf8.encode(data));
  }
}
