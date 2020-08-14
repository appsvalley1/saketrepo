import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/SelectCityPage.dart';
import 'package:SpotEasy/loginresponse/LoginResp.dart';

import 'package:SpotEasy/registerresponse/RegisterResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
class ForgotPasswordPage extends StatefulWidget {
  @override
  State createState() => new ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool showProgress = false;

  final emailController = TextEditingController();

  final scaffoldState = GlobalKey<ScaffoldState>();

  Future<LoginResp> recoverPassword() async {
    final response = await http.get(
        "http://api.rentcity.in/Service1.svc/ForgotPassword?EmailAddress=" +
            emailController.text);
    print(response.body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return LoginResp.fromJsonMap(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: const Color(0xff24293c)),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color(0xff24293c),
          brightness: Brightness.dark,
          title: new Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Stack(
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
                                        const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                    child: new Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(30),
                                          child: new Align(
                                            child: Icon(
                                              Icons.lock,
                                              size: 100,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                        ),
                                        new Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Forgot Password",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: new Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Your password will be sent on your registered Email Address",
                                                  style:
                                                      TextStyle(fontSize: 14))),
                                        ),
                                        new TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: emailController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Enter Email ';
                                              }
                                              return null;
                                            },
                                            decoration: new InputDecoration(
                                                labelText: "Enter The Email"),
                                            keyboardType:
                                                TextInputType.emailAddress),
                                        new Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 20, 0, 0)),
                                        new MaterialButton(
                                          minWidth: 300,
                                          height: 50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(20),
                                              side: BorderSide(
                                                  color: const Color(0xff24293c))),
                                          color: const Color(0xff24293c),
                                          textColor: Colors.white,
                                          child: new Text(
                                            "Recover Password",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          splashColor: Colors.orange,
                                          onPressed: () {
                                            // Validate returns true if the form is valid, otherwise false.
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                showProgress = true;
                                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                recoverPassword().then((value) {
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
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIos: 1,
                                                        backgroundColor:
                                                            Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);


                                                    Future.delayed(const Duration(milliseconds: 2000), () {
                                                      Navigator.of(context).pop();
                                                    });
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

                                        /* new Container(
                                child: loginPressed
                                    ? FutureBuilder<TransactionResponse>(
                                        future: registerUser(),
                                        builder: (context, snapshot) {


                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            default:

                                              if(snapshot.data!=null&&snapshot.data.TransactionStatus==1)
                                                {

                                                  Fluttertoast.showToast(
                                                      msg: snapshot.data.TransactionMesage,
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIos: 1,
                                                      backgroundColor: Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0

                                                  );
                                                  Navigator.of(context).pushReplacement(
                                                      new MaterialPageRoute(
                                                          builder: (BuildContext context) =>
                                                          new HomePage(  snapshot.data.user)));

                                                  return Center(
                                                      child: Text(

                                                          snapshot.data.user.UserId.toString()));

                                                }
                                              else
                                                {
                                                  Fluttertoast.showToast(
                                                      msg: snapshot.data.TransactionMesage,
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIos: 1,
                                                      backgroundColor: Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  return Center(
                                                      child: Text(

                                                          snapshot.data.user.UserId.toString()));
                                                }

                                          }
                                        })
                                    : null),*/
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();

    super.dispose();
  }
}
