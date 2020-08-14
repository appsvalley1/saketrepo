import 'package:SpotEasy/floordb/CartModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/SelectCityPage.dart';
import 'package:SpotEasy/AddProductResponse.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rxbus/rxbus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:SpotEasy/listcategories.dart';
import 'package:random_string/random_string.dart';
import 'package:path_provider/path_provider.dart';
import 'package:SpotEasy/RentcityCategory.dart';

import 'ShippingAddressPage.dart';
import 'eventbus/UpdateMyProducts.dart';
import 'floordb/database.dart';

class ViewCart extends StatefulWidget {
  @override
  State createState() => new ViewCartState();
}

class ViewCartState extends State<ViewCart> {
  final _formKey = GlobalKey<FormState>();
  List<CartModel> listAdded;
  List<CartModel> list;
int total=0;
  Future<List<CartModel>> getAllCartModels() async {
    total=0;
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    list = await database.cartModelDao.findAllCartModel();

    setState(() {
      listAdded = list;
      for(var i = 0; i < listAdded.length; i++){
        total=total+listAdded[i].Amount;
      }
    });
    print(total);

  }

  Future<List<CartModel>> removeItemFromCart(CartModel CartModel) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await database.cartModelDao.deleteCartModel(CartModel);

    getAllCartModels();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCartModels();
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
          title: new Text("My Cart"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(

          children: <Widget>[
            new Wrap(

              children: <Widget>[
                new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[

                              Expanded(
                                child: Container(
                                  child: new Text(
                                    "Name",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: new Text(
                                    "Amount",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    "Action",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(

                            child: SizedBox(
                                height: 400.0,
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        listAdded == null ? 0 : listAdded.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                          duration: Duration(milliseconds: 800),
                                          horizontalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              child: Card(
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          child: new Text(
                                                            listAdded[index]
                                                                .ProductName
                                                                .toString(),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        flex: 2,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: new Text(
                                                            listAdded[index]
                                                                .Amount
                                                                .toString(),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        flex: 2,
                                                      ),
                                                      Expanded(
                                                        child: InkWell(
                                                          child: Container(
                                                            child: Icon(
                                                                FontAwesomeIcons
                                                                    .trash,
                                                                color: Colors.red),
                                                          ),onTap: (){


                                                          removeItemFromCart(list[index]);
                                                        },
                                                        ),
                                                        flex: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10),
                          child: Text("Total Amount :" + (total.toString()),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, bottom: 10),
                            child: new MaterialButton(
                              minWidth: 150,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: const Color(0xff24293c))),
                              color: const Color(0xff24293c),
                              textColor: Colors.white,
                              child: new Text("Add Address"),
                              splashColor: Colors.amberAccent,
                              onPressed: () {

                                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                    builder: (BuildContext context) => new ShippingAddressDetails()));


                              },
                            ),
                          ),
                        ),

                      ],
                    )



                  ],
                )
              ],
            )
          ],
        ));
  }
}
