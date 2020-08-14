import 'package:SpotEasy/eventbus/RefreshMyOrders.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/SelectCityPage.dart';
import 'package:SpotEasy/AddProductResponse.dart';
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

import 'loginresponse/LoginResp.dart';

class StartServiceOTPPage extends StatefulWidget {
  String orderID = "0";

  StartServiceOTPPage(this.orderID);

  @override
  State createState() => new StartServiceOTPState(orderID);
}

class StartServiceOTPState extends State<StartServiceOTPPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String orderID = "0";

  StartServiceOTPState(this.orderID);

  bool showProgress = false;

  final newPasswordController = TextEditingController();

  AnimationController buttonController;
  Animation<double> buttonAnimation;

  String userID = "";

  final scaffoldState = GlobalKey<ScaffoldState>();

  Future<LoginResp> verifyStartOTP() async {
    String url = "http://api.rentcity.in/Service1.svc/VerifyStartOTP?OTP=" +
        newPasswordController.text +
        "&OrderID=" +
        orderID+"&UserId=" +
        userID;
    url = url.replaceAll(" ", "%20");
    print(url);
    final response = await http.get(url);
//print(response.body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return LoginResp.fromJsonMap(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  loadUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userID = prefs.getString(key) ?? "0";

    // print('$userID'.length);
  }

  @override
  void initState() {
    loadUserID();

    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this, value: 0.1);
    buttonAnimation =
        CurvedAnimation(parent: buttonController, curve: Curves.bounceInOut);
    buttonController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color(0xff24293c),
          brightness: Brightness.dark,
          title: new Text("Enter Service OTP"),
          actions: <Widget>[],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            new Wrap(
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        showProgress
                            ? new Center(
                                child: new CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.orange)))
                            : Text(""),
                        new Form(
                            key: _formKey,
                            child: Theme(
                              data: new ThemeData(
                                  brightness: Brightness.light,
                                  primarySwatch: Colors.deepOrange,
                                  inputDecorationTheme:
                                      new InputDecorationTheme(
                                          labelStyle: new TextStyle(
                                              color: Colors.black))),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 20, 40, 0),
                                child: new Column(
                                  children: <Widget>[
                                    Text(
                                        "Enter 6 digit OTP sent to your registered mobile Number"),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: <Widget>[
                                          new TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: newPasswordController,
                                            maxLength: 6,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Enter OTP';
                                              }
                                              return null;
                                            },
                                            decoration: new InputDecoration(
                                                labelText: "Enter OTP"),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ScaleTransition(
                                      scale: buttonAnimation,
                                      child: new MaterialButton(
                                        minWidth: 300,
                                        height: 50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(20),
                                            side: BorderSide(
                                                color:
                                                    const Color(0xff24293c))),
                                        color: const Color(0xff24293c),
                                        textColor: Colors.white,
                                        child: new Text(
                                          "Verify OTP",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        splashColor: const Color(0xff24293c),
                                        onPressed: () {
                                          // Validate returns true if the form is valid, otherwise false.
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              showProgress = true;
                                              verifyStartOTP().then((value) {
                                                setState(() {
                                                  showProgress = false;
                                                });
                                                RxBus.post(
                                                    RefreshMyOrders());
                                                if (value.TransactionStatus ==
                                                    1) {

                                                  Fluttertoast.showToast(
                                                      msg: value
                                                          .TransactionMesage,
                                                      toastLength:
                                                      Toast.LENGTH_LONG,
                                                      gravity:
                                                      ToastGravity.BOTTOM,
                                                      timeInSecForIos: 1,
                                                      backgroundColor:
                                                      Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);

                                                  Navigator.of(context).pop();

                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: value
                                                          .TransactionMesage,
                                                      toastLength:
                                                      Toast.LENGTH_LONG,
                                                      gravity:
                                                      ToastGravity.BOTTOM,
                                                      timeInSecForIos: 1,
                                                      backgroundColor:
                                                      Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }
                                              });
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    newPasswordController.dispose();
    buttonController.dispose();
    super.dispose();
  }
}
