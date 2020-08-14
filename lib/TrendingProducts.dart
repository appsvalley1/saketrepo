import 'package:flutter/material.dart';
import 'package:SpotEasy/Notifications.dart';

class Details extends StatefulWidget {
  String url, first_name;

  Details(this.url, this.first_name);

  @override
  State createState() => new DetailsState(url, first_name);
}

class DetailsState extends State<Details> {
  String url, first_name;
  double _sliderValue = 5.0;

  DetailsState(this.url, this.first_name);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Single Door Fridge (170 Litre) "),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box, color: Colors.orangeAccent),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.orangeAccent),
            onPressed: () {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => new Notifications()));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
