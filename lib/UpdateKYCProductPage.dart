import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/AddProductResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_products.dart';
import 'package:SpotEasy/ProductDetailsPage.dart';

class UpdateKYCProductPage extends StatefulWidget {
  ListProducts _products;


  UpdateKYCProductPage(this._products);

  @override
  State createState() => new UpdateKYCProductPageState(_products);
}

class UpdateKYCProductPageState extends State<UpdateKYCProductPage>
    with SingleTickerProviderStateMixin {
  ListProducts _products;
  bool isFromProduct;

  UpdateKYCProductPageState(this._products);

  PageController controller = PageController();
  String userID = "";

  //TODO ADHAR DATA
  final _adharKey = GlobalKey<FormState>();

  final adharNumberController = TextEditingController();
  final adharNameController = TextEditingController();
  AnimationController adharAnimationController;
  String adharImage;
  File adharfile;

  //TODO PAN DATA
  final _panformKey = GlobalKey<FormState>();
  final pancardNumberController = TextEditingController();
  final pancarddobController = TextEditingController();
  final pancardnameController = TextEditingController();
  final productRentController = TextEditingController();
  final productSecurityController = TextEditingController();
  AnimationController panAnimationController;
  String panImage;
  File panfile;
  bool showProgress = false;

  Future<AddProductResponse> UploadPanCard() async {
    String url =
        "http://api.rentcity.in/Service1.svc/PostKYC?KYCDocumentType=1&KYCDocumentNumber=" +
            pancardNumberController.text +
            "&KYCUsersDOB=" +
            pancarddobController.text +
            "&KYCUsersName=" +
            pancardnameController.text +
            "&UserId=" +
            userID +
            "&KYCDocumentImage=" +
            panImage;
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

  Future<AddProductResponse> UploadAdharCard() async {
    String url =
        "http://api.rentcity.in/Service1.svc/PostKYC?KYCDocumentType=2&KYCDocumentNumber=" +
            adharNumberController.text +
            "&KYCUsersDOB=" +
            adharNameController.text +
            "&KYCUsersName=N/A" +
            "&UserId=" +
            userID +
            "&KYCDocumentImage=" +
            adharImage;
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


  loadUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userID = prefs.getString(key) ?? "0";

    // print('$userID'.length);
  }

  saveuserKYC(String dataKey, int dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setInt(key, value);
    print('saved $value');
  }


  @override
  void initState() {
    loadUserID();
    panAnimationController = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    );
    panAnimationController.forward();

    super.initState();
  }
  @override
  void dispose() {

    if(adharAnimationController!=null)
    {
      adharAnimationController.dispose();
      adharNameController.dispose();
      adharNumberController.dispose();

    }
    if(panAnimationController!=null)
    {
      panAnimationController.dispose();
      pancarddobController.dispose();
      pancardnameController.dispose();
      pancardNumberController.dispose();
    }


    super.dispose();
  }
  //TODO ADhar Image Upload
  Future getImageadhar(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      adharfile = image;
      print('Image Path $adharfile');
      uploadadharPic(context);
    });
  }

  Future uploadadharPic(BuildContext context) async {
    setState(() {
      showProgress = true;
    });

    adharImage = basename(randomAlphaNumeric(10) + ".jpg");
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(adharImage);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(adharfile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      showProgress = false;
      print('saved $adharImage');
      Fluttertoast.showToast(
          msg: "Image Saved Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future getImagePan(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      panfile = image;
      print('Image Path $panfile');
      uploadpanPic(context);
    });
  }

  Future uploadpanPic(BuildContext context) async {
    setState(() {
      showProgress = true;
    });

    panImage = basename(randomAlphaNumeric(10) + ".jpg");
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(panImage);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(panfile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      showProgress = false;
      print('saved $panImage');
      Fluttertoast.showToast(
          msg: "Image Saved Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: new Text("Setup KYC"),
          actions: <Widget>[],
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          brightness: Brightness.dark,
        ),
        body: PageView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.account_circle,
                                        color: Colors.orange,
                                        size: 100,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                "Identification\n Document",
                                                style: TextStyle(fontSize: 26),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "Upload One of the following document to have instant delivery and earn 100 RP(Rentcity points).",
                                        textAlign: TextAlign.center,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: InkWell(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      color:
                                                          Colors.orangeAccent,
                                                      width: 100,
                                                      height: 100,
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        color: Colors.white,
                                                        size: 60,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Upload PAN ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  controller.animateToPage(1,
                                                      duration: Duration(
                                                          milliseconds: 2000),
                                                      curve:
                                                          Curves.fastOutSlowIn);
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: InkWell(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      color:
                                                          Colors.orangeAccent,
                                                      width: 100,
                                                      height: 100,
                                                      child: Icon(
                                                        Icons.account_circle,
                                                        color: Colors.white,
                                                        size: 60,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Upload Aadhar",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  controller.animateToPage(2,
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      curve:
                                                          Curves.fastOutSlowIn);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Wrap(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Upload Pan Card",
                                        style: TextStyle(fontSize: 26),
                                      ),
                                      Form(
                                        key: _panformKey,
                                        child: Column(
                                          children: <Widget>[
                                            RotationTransition(
                                              turns: Tween(begin: 0.0, end: 1.0)
                                                  .animate(
                                                      panAnimationController),
                                              child: panfile == null
                                                  ? IconButton(
                                                      onPressed: () {
                                                        showAlertDialog(
                                                            context, false);
                                                      },
                                                      iconSize: 80.0,
                                                      icon: new Icon(
                                                        Icons.camera,
                                                        color: Colors.orange,
                                                      ))
                                                  : Image.file(
                                                      panfile,
                                                      width: 140,
                                                      height: 120,
                                                    ),
                                            ),
                                            new TextFormField(
                                              textCapitalization: TextCapitalization.characters,
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller:
                                                  pancardNumberController,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'PAN Card Number';
                                                }
                                                return null;
                                              },
                                              decoration: new InputDecoration(
                                                  labelText: "PAN Card Number"),
                                              keyboardType: TextInputType.text,
                                            ),
                                            new TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller:
                                                    pancarddobController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'DOB On PAN Card';
                                                  }
                                                  return null;
                                                },
                                                decoration: new InputDecoration(
                                                    labelText:
                                                        "DOB On PAN Card"),
                                                keyboardType:
                                                    TextInputType.text),
                                            new TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller:
                                                    pancardnameController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Name on PAN Card ';
                                                  }
                                                  return null;
                                                },
                                                decoration: new InputDecoration(
                                                    labelText:
                                                        "Name on PAN Card"),
                                                keyboardType:
                                                    TextInputType.text),
                                            new Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 20, 0, 0)),
                                            new MaterialButton(
                                              minWidth: 200,
                                              height: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20),
                                                  side: BorderSide(
                                                      color: Colors.orange)),
                                              color: Colors.orange,
                                              textColor: Colors.white,
                                              child: new Text(
                                                "Upload",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              splashColor: Colors.orange,
                                              onPressed: () {
                                                // Validate returns true if the form is valid, otherwise false.
                                                if (_panformKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    if (panfile == null) {
                                                      showAlertDialog(
                                                          context, false);
                                                    } else {
                                                      showProgress = true;
                                                      UploadPanCard()
                                                          .then((value) {
                                                        // Run extra code here
                                                        if (value
                                                                .TransactionStatus ==
                                                            1) {
                                                          Fluttertoast.showToast(
                                                              msg: value
                                                                  .TransactionMesage,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIos:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                          saveuserKYC(
                                                              "userKYC", 1);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductDetails(
                                                                      _products),
                                                            ), //MaterialPageRoute
                                                          );
                                                        }
                                                      });
                                                    }
                                                  });
                                                }
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[100],
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[300])),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                        "Note: You can initiate refund of security amount after order complete",
                                                        style: TextStyle(
                                                            fontSize: 13))),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                    Center(
                      child: showProgress
                          ? new Center(
                              child: new CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.orange)))
                          : Text(""),
                    )
                  ],
                )
              ],
            ),
            Wrap(
              children: <Widget>[
                Stack(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Upload Adhar",
                                          style: TextStyle(fontSize: 26),
                                        ),
                                        Form(
                                          key: _adharKey,
                                          child: Column(
                                            children: <Widget>[
                                              RotationTransition(
                                                turns: Tween(begin: 0.0, end: 1.0)
                                                    .animate(panAnimationController),
                                                child: adharfile == null
                                                    ? IconButton(
                                                    onPressed: () {
                                                      showAlertDialog(
                                                          context, true);
                                                    },
                                                    iconSize: 80.0,
                                                    icon: new Icon(
                                                      Icons.camera,
                                                      color: Colors.orange,
                                                    ))
                                                    : Image.file(
                                                  adharfile,
                                                  width: 140,
                                                  height: 120,
                                                ),
                                              ),
                                              Text(
                                                "Upload Adhar Image",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              new TextFormField(
                                                textInputAction: TextInputAction.next,
                                                controller: adharNumberController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'ADHAR Card Number';
                                                  }
                                                  return null;
                                                },
                                                decoration: new InputDecoration(
                                                    labelText: "ADHAR Card Number"),
                                                keyboardType: TextInputType.text,
                                              ),
                                              new TextFormField(
                                                  textInputAction:
                                                  TextInputAction.next,
                                                  controller: adharNameController,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Name on Adhar Card ';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: new InputDecoration(
                                                      labelText:
                                                      "Name on Adhar Card"),
                                                  keyboardType: TextInputType.text),
                                              new Padding(
                                                  padding: const EdgeInsets.fromLTRB(
                                                      0, 20, 0, 0)),
                                              new MaterialButton(
                                                minWidth: 200,
                                                height: 50,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    new BorderRadius.circular(20),
                                                    side: BorderSide(
                                                        color: Colors.orange)),
                                                color: Colors.orange,
                                                textColor: Colors.white,
                                                child: new Text(
                                                  "Upload",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                                splashColor: Colors.orange,
                                                onPressed: () {
                                                  // Validate returns true if the form is valid, otherwise false.
                                                  if (_adharKey.currentState
                                                      .validate()) {
                                                    setState(() {
                                                      if (adharfile == null) {
                                                        showAlertDialog(
                                                            context, true);
                                                      } else {
                                                        showProgress = true;
                                                        UploadAdharCard()
                                                            .then((value) {
                                                          // Run extra code here
                                                          if (value
                                                              .TransactionStatus ==
                                                              1) {
                                                            Fluttertoast.showToast(
                                                                msg: value
                                                                    .TransactionMesage,
                                                                toastLength:
                                                                Toast.LENGTH_LONG,
                                                                gravity: ToastGravity
                                                                    .BOTTOM,
                                                                timeInSecForIos: 1,
                                                                backgroundColor:
                                                                Colors.green,
                                                                textColor:
                                                                Colors.white,
                                                                fontSize: 16.0);

                                                            saveuserKYC("userKYC", 1);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ProductDetails(
                                                                        _products),
                                                              ), //MaterialPageRoute
                                                            );
                                                          }
                                                        });
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Align(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey[100],
                                                          border: Border.all(
                                                              color:
                                                              Colors.grey[300])),
                                                      padding:
                                                      const EdgeInsets.all(10),
                                                      child: Text(
                                                          "Note: You can initiate refund of security amount after order complete",
                                                          style: TextStyle(
                                                              fontSize: 13))),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ), Center(
                    child: showProgress
                        ? new Center(
                        child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.orange)))
                        : Text(""),
                  )
                ],

                ),

              ],
            ),
          ],
          controller: controller,
          physics: ClampingScrollPhysics(),
        ));
  }

  showAlertDialog(BuildContext context, bool isAdhar) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Galley"),
      onPressed: () {
        if (isAdhar) {
          getImageadhar(context);
        } else {
          getImagePan(context);
        }

        Navigator.pop(context);
      },
    );
    Widget launchButton = FlatButton(
      child: Text("Camera"),
      onPressed: () {
        // getCameraImage();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Upload Image"),
      content: Text("Post a clear image so the we can approve instantly"),
      actions: [
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
