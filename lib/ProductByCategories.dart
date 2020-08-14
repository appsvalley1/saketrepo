import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/ProductDetailsPage.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:http/http.dart' as http;

class ProductByCategories extends StatefulWidget {
  String CategoryID, CategoryName;

  ProductByCategories(this.CategoryID, this.CategoryName);

  @override
  State createState() => new ProductByCategoriesState(CategoryID, CategoryName);
}

class ProductByCategoriesState extends State<ProductByCategories> {
  String CategoryID, CategoryName;

  ProductByCategoriesState(this.CategoryID, this.CategoryName);

  List data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://rentcity.us-east-2.elasticbeanstalk.com/Service1.svc/GetAllRentcityProductsByCategory?CategoryID=" +
                CategoryID),
        headers: {"Accept": "application/json"});

    this.setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["listProducts"];
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
        title: new Text("Products  for " + CategoryName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box, color: Colors.orangeAccent),
            onPressed: () {},
          ),

        ],
      ),
      body: new Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
                height: 230.0,
                child: (data != null && data.isEmpty)
                    ? Center(
                        child: Text("No Product Found with  " + CategoryName))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 100.0,
                            width: 140,
                            child: new Card(
                              child: Column(
                                children: <Widget>[
                                  Hero(
                                    tag: data[index]["AdID"].toString(),
                                    child: GestureDetector(
                                      onTap: () {

                                      },
                                      child: Image(
                                          width: 100,
                                          height: 140,
                                          image: new CachedNetworkImageProvider(
                                              data[index]["ProductImage"]),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: new Text(
                                        "\u20B9" +
                                            data[index]["ProductRent"]
                                                .toString() +
                                            "/Month",
                                        style: TextStyle(fontSize: 15),
                                      )),
                                  new MaterialButton(
                                    color: Colors.orangeAccent,
                                    textColor: Colors.white,
                                    child: new Text("Rent or Share"),
                                    splashColor: Colors.amberAccent,
                                    onPressed: () {

                                      // Validate returns true if the form is valid, otherwise false.
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )),
          ),
        ],
      ),
    );
  }
}
