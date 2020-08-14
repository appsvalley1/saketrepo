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

import 'eventbus/UpdateMyProducts.dart';

class AddBankDetailsPage extends StatefulWidget {
  @override
  State createState() => new AddBankDetailsState();
}

class AddBankDetailsState extends State<AddBankDetailsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool showProgress = false;
  String CityID;
  final BankNameController = TextEditingController();
  final AccountHolderNameController = TextEditingController();
  final AccountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  AnimationController buttonController;
  Animation<double> buttonAnimation;


  String userID = "";

  final scaffoldState = GlobalKey<ScaffoldState>();


  Future<AddProductResponse> addBankDetails() async {
    String url =
        "http://api.rentcity.in/Service1.svc/AddBankDetails?AccountHolderName=" +
            AccountHolderNameController.text +
            "&AccountNumber=" +
            AccountNumberController.text +
            "&BankIFSC=" +
            ifscController.text +
            "&BankName=" +
            BankNameController.text +
            "&UserId=" +
            userID;
    url = url.replaceAll(" ", "%20");
    final response = await http.get(url);
//print(response.body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return AddProductResponse.fromJsonMap(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
  saveBankDetails(String dataKey, int dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setInt(key, value);
    print('saved $value');
  }

  loadUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userID = prefs.getString(key) ?? "0";

  }

  @override
  void initState() {
    loadUserID();
    buttonController = AnimationController(duration: const Duration(milliseconds: 2500), vsync: this, value: 0.1);
    buttonAnimation = CurvedAnimation(parent: buttonController, curve: Curves.bounceInOut);
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
          title: new Text("Add Bank Details"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
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
                                child:
                                new Column(
                                  children: <Widget>[

                                    new TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: AccountHolderNameController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Account Holder Name';
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                          labelText: "Enter Holder Name"),
                                      keyboardType: TextInputType.text,
                                    ),
                                    new TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: AccountNumberController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Account Number';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText:
                                            "Enter Account Number"),
                                        keyboardType: TextInputType.text),
                                    new TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: BankNameController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Bank Name';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText:
                                            "Enter Bank Name"),
                                        keyboardType: TextInputType.text),
                                    new TextFormField(
                                        textInputAction: TextInputAction.next,

                                        controller: ifscController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter IFSC';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText:
                                            "Enter IFSC"),
                                        keyboardType: TextInputType.text),


                                    new Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 0)),
                                    ScaleTransition(
                                      scale: buttonAnimation,
                                      child:
                                      new MaterialButton(
                                        minWidth: 300,
                                        height: 50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            new BorderRadius.circular(20),
                                            side:
                                            BorderSide(color: Colors.orange)),
                                        color: Colors.orange,
                                        textColor: Colors.white,
                                        child: new Text(
                                          "Add Bank Details",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        splashColor: Colors.orange,
                                        onPressed: () {
                                          // Validate returns true if the form is valid, otherwise false.
                                          if (_formKey.currentState.validate()) {
                                            setState(() {


                                              showProgress = true;
                                              addBankDetails().then((value) {
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
                                                      Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  saveBankDetails(
                                                      "bankDetailsStatus", 1);
                                                Navigator.pop(context);


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
    AccountNumberController.dispose();
    ifscController.dispose();
    AccountHolderNameController.dispose();
    BankNameController.dispose();
    buttonController.dispose();
    super.dispose();
  }

}
