import 'package:SpotEasy/ChatScreenPage.dart';
import 'package:SpotEasy/ProductFullScreenPage.dart';
import 'package:SpotEasy/floordb/CartModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/CartDetailsPage.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/UpdateKYCProductPage.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'floordb/database.dart';

class ProductDetails extends StatefulWidget {
  ListProducts _products;

  ProductDetails(this._products);

  @override
  State createState() => new DetailsState(_products);
}

class DetailsState extends State<ProductDetails> {
  ListProducts _products;
  int tenure = 1;
  int totalAmount;

  String CityID;
  String userID = "";

  DetailsState(this._products);

  loadCityID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "CityID";
    CityID = prefs.getString(key) ?? "0";
  }

  loadUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userID = prefs.getString(key) ?? "0";

    // print('$userID'.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadUserID();
    totalAmount = _products.ProductRent + _products.ProductSecurity;
  }
  saveCartModel(CartModel cartModel) async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    await database.cartModelDao.insertCartModel(cartModel);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color(0xff24293c),
        brightness: Brightness.dark,
        title: new Text(_products.productCategory.CategoryName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, "/ViewCart");
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 210.0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Hero(
                  tag: _products.AdID,
                  child: GestureDetector(
                    child: Image(
                      width: 250,
                      height: 150,
                      image: new CachedNetworkImageProvider(
                          "https://firebasestorage.googleapis.com/v0/b/spoteasy-214d2.appspot.com/o/" +
                              _products.ProductImage.toString() +
                              "?alt=media&token=802896b3-3d04-47e1-a6c4-86ed88e491a2"),
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(_products.ProductName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Text("DESCRIPTION:",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(_products.Description,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 10, bottom: 10),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300])),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                "Technicians wear masks, carry sanitizers and follow WHO hygiene guidelines.",
                                style: TextStyle(fontSize: 15))),
                      ),
                    ),
                    new Divider(
                      color: Colors.grey[400],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, bottom: 10),
                        child: Text("Total Amount :" + (totalAmount.toString()),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, bottom: 10),
                              child: new MaterialButton(
                                minWidth: 300,
                                height: 50,
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: const Color(0xff24293c))),
                                color: const Color(0xff24293c),
                                textColor: Colors.white,
                                child: new Text("Add To cart"),
                                splashColor: Colors.amberAccent,
                                onPressed: () {
                                  
                                  saveCartModel(CartModel(_products.AdID,_products.ProductName,_products.ProductRent));
                                  Navigator.pushNamed(context, "/ViewCart");
                                 /* Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new CartDetails(
                                                  _products, tenure)));*/


                                  // Validate returns true if the form is valid, otherwise false.
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
