import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/SelectCityPage.dart';
import 'package:SpotEasy/AddProductResponse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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

class ChangePasswordPage extends StatefulWidget {
  @override
  State createState() => new ChangePasswordState();
}

class ChangePasswordState extends State<ChangePasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool showProgress = false;

  final newPasswordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  AnimationController buttonController;
  Animation<double> buttonAnimation;

  String userID = "";

  final scaffoldState = GlobalKey<ScaffoldState>();

  Future<LoginResp> changePassword() async {
    String url =  "http://api.rentcity.in/Service1.svc/UpdatePassword?OldPassword=" +
        oldPasswordController.text +
        "&Password=" +
        newPasswordController.text+"&UserId="+userID;
    url = url.replaceAll(" ", "%20");
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
          backgroundColor: Colors.orange,
          brightness: Brightness.dark,
          title: new Text("Change Password"),
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
                                    Image(
                                        image: AssetImage(
                                            'assets/chnagepassword.png')),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: <Widget>[
                                          new TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: oldPasswordController,
                                            obscureText: true,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Old Password';
                                              }
                                              return null;
                                            },
                                            decoration: new InputDecoration(
                                                labelText: "Enter Old Password"),
                                            keyboardType: TextInputType.text,
                                          ),
                                          new TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: newPasswordController,
                                            obscureText: true,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'New Password';
                                              }
                                              return null;
                                            },
                                            decoration: new InputDecoration(
                                                labelText: "Enter New Password"),
                                            keyboardType: TextInputType.text,
                                          ),
                                          new TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: confirmPasswordController,
                                            obscureText: true,
                                            validator: (value) {
                                              if (value.isEmpty||confirmPasswordController.text!=newPasswordController.text) {
                                                return 'Confirm New Password';
                                              }
                                              return null;
                                            },
                                            decoration: new InputDecoration(
                                                labelText:
                                                    "Enter Confirm Password"),
                                            keyboardType: TextInputType.text,
                                          )
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
                                                color: Colors.orange)),
                                        color: Colors.orange,
                                        textColor: Colors.white,
                                        child: new Text(
                                          "Change Password",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        splashColor: Colors.orange,
                                        onPressed: () {
                                          // Validate returns true if the form is valid, otherwise false.
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              showProgress = true;
                                              changePassword().then((value) {

                                                setState(() {
                                                  showProgress = false;
                                                });
                                                // Run extra code here
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
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);

                                                }
                                                else
                                                  {
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
