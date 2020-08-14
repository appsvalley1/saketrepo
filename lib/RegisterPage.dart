import 'dart:convert';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:SpotEasy/registerresponse/RegisterResponse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  State createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  String _platformImei = 'Unknown';
  bool showReferal = false;
  AnimationController buttonController;
  Animation<double> buttonAnimation;
  final _formKey = GlobalKey<FormState>();
  bool showProgress = false;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNoController = TextEditingController();
  final referalController = TextEditingController();
  final scaffoldState = GlobalKey<ScaffoldState>();
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  Country CountryCode = Country.IN;

  Future<void> verifyPhone(bool showDialog) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      if (showDialog) {
        setState(() {
          errorMessage = "";
          showProgress = false;
        });
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
      }
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
            setState(() {
              showProgress = false;
              errorMessage = exceptio.message;
            });
            Fluttertoast.showToast(
                msg: exceptio.message,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Verify OTP'),
            content: Container(
              height: 200,
              child: Column(children: [
                Text(
                  'We have send the OTP to your mobile number $phoneNo',
                  textAlign: TextAlign.center,
                ),
                Text('It will auto fill to the fields'),
                PinPut(
                  fieldsCount: 6,
                  onSubmit: (String value) {
                    this.smsOTP = value;
                  },
                  actionButtonsEnabled: false,
                ),
                Row(
                  children: <Widget>[
                    Text('If you dont recieve your code'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: InkWell(
                        child: Text(
                          'Resend',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          setState(() {
                            showProgress = true;
                            errorMessage = "";
                          });

                          phoneNo = "+" +
                              CountryCode.dialingCode +
                              mobileNoController.text;
                          verifyPhone(false);
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              new MaterialButton(
                minWidth: 150,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                    side: BorderSide(color: Colors.orange)),
                color: Colors.orange,
                textColor: Colors.white,
                child: new Text(
                  "Verify Now",
                  style: TextStyle(fontSize: 18),
                ),
                splashColor: Colors.orange,
                onPressed: () {
                  // Validate returns true if the form is valid, otherwise false.
                  _auth.currentUser().then((user) {
                    signIn();
                  });
                },
              )
            ],
          );
        });
  }

  void registernow() {
    if (_formKey.currentState.validate()) {}
    setState(() {
      showProgress = true;
      registerUser().then((value) {
        setState(() {
          showProgress = false;
        });
        // Run extra code here
        if (value.TransactionStatus == 1) {
          Fluttertoast.showToast(
              msg: value.TransactionMesage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushNamed(context, "/login");
        } else {
          Fluttertoast.showToast(
              msg: value.TransactionMesage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      registernow();
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());

        setState(() {
          errorMessage = "Invalid Verification Code, Try Again";
        });
        Fluttertoast.showToast(
            msg: "Invalid Verification Code, Try Again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
      default:
        setState(() {
          errorMessage = "Invalid Verification Code, Try Again";
        });
        Fluttertoast.showToast(
            msg: "Invalid Verification Code, Try Again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        break;
    }
  }

  Future<void> initPlatformState() async {
    String platformImei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true);
    } on PlatformException {
      platformImei = await ImeiPlugin.getId();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
  }

  Future<RegisterResponse> registerUser() async {
    final response = await http.get(
        "http://api.rentcity.in/Service1.svc/RegisterUser?EmailAddress=" +
            emailController.text +
            "&ContactNo=" +
            mobileNoController.text +
            "&Password=" +
            passwordController.text +
            "&DeviceId=" +
            _platformImei +
            "&ReferedBy=" +
            referalController.text);
    print("http://api.rentcity.in/Service1.svc/RegisterUser?EmailAddress=" +
        emailController.text +
        "&ContactNo=" +
        mobileNoController.text +
        "&Password=" +
        passwordController.text +
        "&DeviceId=" +
        _platformImei +
        "&ReferedBy=" +
        referalController.text);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return RegisterResponse.fromJsonMap(json.decode(response.body));
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

  @override
  void initState() {
    initPlatformState();
    super.initState();
    referalController.text = "";
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this, value: 0.1);
    buttonAnimation =
        CurvedAnimation(parent: buttonController, curve: Curves.bounceInOut);
    buttonController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      key: scaffoldState,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.orange),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color(0xff24293c),
        brightness: Brightness.dark,
        title: new Text(
          "Register Now",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  new Column(
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
                                      new Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Welcome",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      new Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Sign up to continue",
                                              style: TextStyle(fontSize: 14))),
                                      new TextFormField(
                                          textInputAction: TextInputAction.next,
                                          controller: emailController,
                                          validator: (value) {
                                            bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value);
                                            if (value.isEmpty||!emailValid) {
                                              return 'Enter Email ';
                                            }
                                            return null;
                                          },
                                          decoration: new InputDecoration(
                                              labelText: "Enter The Email"),
                                          keyboardType:
                                              TextInputType.emailAddress),
                                      new Row(
                                        children: <Widget>[
                                          CountryPicker(
                                            dense: false,
                                            showFlag: true,
                                            //displays flag, true by default
                                            showDialingCode: true,
                                            //displays dialing code, false by default
                                            showName: true,
                                            //displays country name, true by default
                                            showCurrency: false,
                                            //eg. 'British pound'
                                            showCurrencyISO: false,
                                            //eg. 'GBP'
                                            onChanged: (Country country) {
                                              setState(() {
                                                CountryCode = country;
                                              });
                                            },
                                            selectedCountry: CountryCode,
                                          ),
                                          new Flexible(
                                            child: new TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                maxLength: 10,
                                                controller: mobileNoController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Enter Mobile Number ';
                                                  }
                                                  return null;
                                                },
                                                decoration: new InputDecoration(
                                                    labelText:
                                                        "Enter The Mobile Number"),
                                                keyboardType:
                                                    TextInputType.phone),
                                          ),

                                        ],
                                      ),
                                      new TextFormField(
                                        textInputAction: TextInputAction.done,
                                        controller: passwordController,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter Password';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText: "Enter The Password"),
                                        keyboardType: TextInputType.text,
                                      ),
                                      Visibility(
                                        visible: !showReferal,
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 20, 0, 0),
                                            child: Align(
                                                child: Text(
                                                  "Have Referal Code",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                alignment: Alignment.topLeft),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              showReferal = true;
                                            });
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: showReferal,
                                        child: new TextFormField(
                                          textInputAction: TextInputAction.done,
                                          controller: referalController,
                                          decoration: new InputDecoration(
                                              labelText: "Enter Referal Code"),
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),
                                      new Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 40, 0, 0)),
                                      ScaleTransition(
                                        scale: buttonAnimation,
                                        child:

                                        MaterialButton(
                                          minWidth: 250,
                                          height: 50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              new BorderRadius.circular(20),
                                              side:
                                              BorderSide(color: const Color(0xff24293c))),
                                          color:const Color(0xff24293c),
                                          textColor: Colors.white,
                                          child: new Text(
                                            "Register Now",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          splashColor:const Color(0xff24293c),
                                          onPressed: () {
                                            // Validate returns true if the form is valid, otherwise false.
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                showProgress = true;
                                              });
                                              phoneNo = "+91" +
                                                  mobileNoController.text;
                                              verifyPhone(true);
                                            }

                                            // Validate returns true if the form is valid, otherwise false.
                                            /* if (_formKey.currentState
                                                  .validate())*/
                                            {
                                              /* setState(() {
                                                  showProgress = true;
                                                  registerUser().then((value) {
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
                                                      Navigator.pushNamed(
                                                          context, "/login");
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
                                                              Colors.green,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  });
                                                });*/
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
                    child: InkWell(child: Text("Forgot Password")
                    ,onTap: (){
                        Navigator.pushNamed(context, "/ForgotPasswordPage");
                      },),
                  ),
                  new Container(
                    height: 50.0,
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  Container(
                    child: InkWell(
                      child: Text("Login Now"),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
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
    mobileNoController.dispose();
    passwordController.dispose();
    buttonController.dispose();
    super.dispose();
  }
}
