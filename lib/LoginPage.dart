import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/SelectCityPage.dart';
import 'package:SpotEasy/loginresponse/LoginResp.dart';
import 'package:SpotEasy/ServiceOrdersPage.dart';
import 'package:SpotEasy/registerresponse/RegisterResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'ServiceManOrdersSelector.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController buttonController;
  Animation<double> buttonAnimation;

  final _formKey = GlobalKey<FormState>();
  bool showProgress = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final scaffoldState = GlobalKey<ScaffoldState>();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future<LoginResp> registerUser() async {
    final response = await http.get(
        "http://api.rentcity.in/Service1.svc/AuthenticateUser?EmailAddress=" +
            emailController.text +
            "&Password=" +
            passwordController.text);
    print(response.body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return LoginResp.fromJsonMap(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  saveUserID(String dataKey, String dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setString(key, value);
    print('saved $value');
  }

  saveUserRole(String dataKey, int dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setInt(key, value);
    print('saved $value');
  }

  saveBankDetails(String dataKey, int dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setInt(key, value);
    print('saved $value');
  }

  saveuserKYC(String dataKey, int dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setInt(key, value);
    print('saved $value');
  }

  saveRegistrationID(String dataKey, String dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setString(key, value);
    print('saved $value');
  }

  saveReferralCode(String dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final value = dataValue;
    prefs.setString("ReferralCode", value);
    print('saved $value');
  }

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this, value: 0.1);
    buttonAnimation =
        CurvedAnimation(parent: buttonController, curve: Curves.bounceInOut);
    buttonController.forward();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.getToken().then((token) {
      saveRegistrationID("RegistrationID", token);
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      key: scaffoldState,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
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
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.orange)))
                          : Text(""),
                      new Form(
                          key: _formKey,
                          child: Theme(
                            data: new ThemeData(
                                brightness: Brightness.light,
                                primarySwatch: Colors.deepOrange,
                                inputDecorationTheme: new InputDecorationTheme(
                                    labelStyle:
                                        new TextStyle(color: Colors.black))),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(40, 90, 40, 0),
                              child: new Column(
                                children: <Widget>[
                                  new Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Welcome",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold))),
                                  new Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Sign in to continue",
                                          style: TextStyle(fontSize: 14))),
                                  new TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: emailController,
                                      validator: (value) {
                                        bool emailValid = RegExp(
                                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                            .hasMatch(value);
                                        if (value.isEmpty || !emailValid) {
                                          return 'Enter Email ';
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                          labelText: "Enter The Email"),
                                      keyboardType: TextInputType.emailAddress),
                                  new TextFormField(
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      controller: passwordController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Password ';
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                          labelText: "Enter The Password"),
                                      keyboardType: TextInputType.text),
                                  new Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 40, 0, 0)),
                                  ScaleTransition(
                                      scale: buttonAnimation,
                                      child: MaterialButton(
                                        minWidth: 250,
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
                                          "Login Now",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        splashColor: Colors.orange,
                                        onPressed: () {
                                          // Validate returns true if the form is valid, otherwise false.
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              showProgress = true;
                                              registerUser().then((value) {
                                                setState(() {
                                                  showProgress = false;
                                                });
                                                // Run extra code here
                                                if (value.TransactionStatus ==
                                                    1) {
                                                  saveReferralCode(
                                                      value.user.ReferralCode);
                                                  saveUserID("userid",
                                                      value.user.UserId);

                                                  saveUserRole(
                                                      "UserRole",
                                                      value.user.UserRole
                                                          );
                                                  saveuserKYC("userKYC",
                                                      value.user.userKYC);
                                                  saveBankDetails(
                                                      "bankDetailsStatus",
                                                      value.user
                                                          .bankDetailsStatus);
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

                                                  if (value.user.UserRole ==
                                                      1) {
                                                    Navigator.of(context).pushReplacement(
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new CitiesList(
                                                                    true)));
                                                  } else {
                                                    Route route = MaterialPageRoute(
                                                        builder: (context) =>
                                                            ServiceManOrdersSelector());
                                                    Navigator.pushReplacement(
                                                        context, route);
                                                  }
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: value
                                                          .TransactionMesage,
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
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
                                      )
                                      /* InkWell(
                                      child:
                                      new MaterialButton(
                                        minWidth: 300,
                                        height: 50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(20),
                                            side: BorderSide(color: Colors.orange)),
                                        color: Colors.orange,
                                        textColor: Colors.white,
                                        child: new Text(
                                          "Login Now",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        splashColor: Colors.orange,

                                      ),
                                      onTap: (){
                                        // Validate returns true if the form is valid, otherwise false.
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            showProgress = true;
                                            registerUser().then((value) {
                                              setState(() {
                                                showProgress =false;
                                              });
                                              // Run extra code here
                                              if (value.TransactionStatus == 1) {

                                                saveReferralCode(value.user.ReferralCode);
                                                saveUserID(
                                                    "userid", value.user.UserId);
                                                saveuserKYC(
                                                    "userKYC", value.user.userKYC);
                                                saveBankDetails(
                                                    "bankDetailsStatus", value.user.bankDetailsStatus);
                                                Fluttertoast.showToast(
                                                    msg: value.TransactionMesage,
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIos: 1,
                                                    backgroundColor: Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                    new MaterialPageRoute(
                                                        builder: (BuildContext
                                                        context) =>
                                                        new CitiesList(
                                                            true)));
                                              }
                                              else
                                              {
                                                Fluttertoast.showToast(
                                                    msg: value.TransactionMesage,
                                                    toastLength:
                                                    Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIos: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            });
                                          });
                                        }
                                      },
                                      splashColor: Colors.orange,
                                      focusColor: Colors.orange ,
                                    )*/
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
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Divider(color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: InkWell(
                      child: Text("Forgot Password"),
                      onTap: () {
                        Navigator.pushNamed(context, "/ForgotPasswordPage");
                      },
                    ),
                  ),
                  new Container(
                    height: 50.0,
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/RegisterPage");
                    },
                    child: Container(
                      child: Text("Register Now"),
                    ),
                  ),
                ],
              )
              //your elements here
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    buttonController.dispose();
    super.dispose();
  }
}
