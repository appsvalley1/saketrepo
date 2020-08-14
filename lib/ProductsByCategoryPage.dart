import 'dart:async';
import 'dart:convert';
import 'package:SpotEasy/RentcityCategory.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/ProductByCategories.dart';
import 'package:http/http.dart' as http;
import 'package:SpotEasy/listcategories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SpotEasy/RentcityProducts.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:SpotEasy/ProductDetailsPage.dart';

class ProductByCategoryPage extends StatefulWidget {
  @override
  State createState() =>
      new ProductByCategoryPageState(this.categoryModel, this.categoryList);
  Listcategories categoryModel;
  List<Listcategories> categoryList;

  ProductByCategoryPage(this.categoryModel, this.categoryList);
}

class ProductByCategoryPageState extends State<ProductByCategoryPage> {
  Listcategories categoryModel;

  ProductByCategoryPageState(this.categoryModel, this.categoryList);

  bool showProgress = true;

  List<Listcategories> categoryList;
  String CityID;
  String userid;

  Map<String, dynamic> productsResponse;
  RentcityProducts _rentcityProducts;
  List<ListProducts> productList;

  Future<List<ListProducts>> getproducts() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://api.rentcity.in/Service1.svc/GetAllRentcityProductsByCategory?CategoryID=" +
                categoryModel.CategoryID.toString() +
                "&UserId=" +
                userid +
                "&CityID=" +
                CityID),
        headers: {"Accept": "application/json"});
    print(
        "http://api.rentcity.in/Service1.svc/GetAllRentcityProductsByCategory?CategoryID=" +
            categoryModel.CategoryID.toString() +
            "&UserId=" +
            userid +
            "&CityID=" +
            CityID);
    this.setState(() {
      productsResponse = json.decode(response.body);
      _rentcityProducts = new RentcityProducts.fromJsonMap(productsResponse);
      productList = _rentcityProducts.listProducts;
      print(productList.length);
      showProgress = false;
      //  var streetsFromJson = extractdata['listCity'];
      // data= new List<ListCity>.from(streetsFromJson);
    });

    return productList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserId();
  }

  loadCityID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "CityID";
    CityID = prefs.getString(key) ?? "0";
    this.setState(() {
      showProgress = true;
    });
    getproducts();
  }

  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
    loadCityID();
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
        backgroundColor: Colors.orange,
        brightness: Brightness.dark,
        title: new Text(categoryModel.CategoryName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),

        ],
      ),
      body: ListView(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.all(20),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: new Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: new Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            "Featured Categories",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                                height: 90.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryList == null
                                      ? 0
                                      : categoryList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 70.0,
                                      width: 140,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            categoryModel = categoryList[index];
                                          });
                                          getproducts();
                                        },
                                        child: new Card(
                                          elevation: 5,
                                          child: Column(
                                            children: <Widget>[

                                              new Text(
                                                categoryList[index]
                                                    .CategoryName
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: productList == null || productList.length == 0
                      ? Container(
                    padding: const EdgeInsets.all(100),
                          height: 500,
                          child: Column(
                            children: <Widget>[
                              Text("Sorry No Product Available",style: TextStyle(
                                fontSize: 14,fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),
                        )
                      : new Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: new Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: new Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Text(
                                    "Products related to " +
                                        categoryModel.CategoryName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              new Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                        height: 170.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: productList == null
                                              ? 0
                                              : productList.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  top: 0.0,
                                                  bottom: 0,
                                                  right: 5,
                                                  left: 0),
                                              child: SizedBox(
                                                height: 150.0,
                                                width: 190,
                                                child: Card(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetails(
                                                                  productList[
                                                                      index]),
                                                        ), //MaterialPageRoute
                                                      );
                                                    },
                                                    child: Column(
                                                      children: <Widget>[
                                                        Hero(
                                                          child: Image(
                                                            image: new CachedNetworkImageProvider(
                                                                "https://firebasestorage.googleapis.com/v0/b/rentcityfinal.appspot.com/o/" +
                                                                    productList[
                                                                            index]
                                                                        .ProductImage
                                                                        .toString() +
                                                                    "?alt=media&token=ea32d5b2-d29f-452d-93c9-f7092ca88794"),
                                                            height: 120,
                                                            width: 180,
                                                          ),
                                                          tag: productList[index]
                                                              .AdID,
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: new Text(
                                                              productList[index]
                                                                  .ProductName
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
