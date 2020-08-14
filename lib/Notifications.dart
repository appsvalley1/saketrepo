import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  @override
  State createState() => new NotificationsState();
}

class NotificationsState extends State<Notifications> {
  List data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://reqres.in/api/users?page=2"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["data"];
      /* Map userMap = jsonDecode(data.toString());
      var user = new Product.fromJson(userMap);

      print('Howdy, ${user.id}!');
      print('We sent the verification link to ${user.email}.');*/
    });

    return "Success!";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Notifications "),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box, color: Colors.orangeAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                      height: 600,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 60.0,
                            child: new Card(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: new Text(
                                        data[index]["avatar"].toString(),
                                        style: TextStyle(fontSize: 15),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
