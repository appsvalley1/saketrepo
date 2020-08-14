import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

class AddProductPage extends StatefulWidget {
  @override
  State createState() => new AddProductState();
}

class AddProductState extends State<AddProductPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool showProgress = false;
  String CityID;
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final specificationController = TextEditingController();
  final productRentController = TextEditingController();
  final productSecurityController = TextEditingController();
  AnimationController buttonController;
  Animation<double> buttonAnimation;

  AnimationController iconAnimationController;
  String userID = "";
  String imageName;
  File _image;
  final scaffoldState = GlobalKey<ScaffoldState>();
  String categoryID;
  bool isAgrrementSHown=false;

  loadCityID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "CityID";
    CityID = prefs.getString(key) ?? "0";
  }

  Future<AddProductResponse> addProduct() async {
    String url =
        "http://api.rentcity.in/Service1.svc/AddRentcityProduct?ProductName=" +
            productNameController.text +
            "&Description=" +
            descriptionController.text +
            "&Specification=" +
            specificationController.text +
            "&ProductRent=" +
            productRentController.text +
            "&ProductSecurity=" +
            productSecurityController.text +
            "&productCategory=" +
            categoryID +
            "&ProductImage=" +
            imageName +
            "&UserId=" +
            userID +
            "&CityID=1";
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

  Future getImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
      uploadPic(context);
    });
  }

  Future getCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      print('Image Path $_image');
      uploadPic(context);
    });
  }

  Future uploadPic(BuildContext context) async {
    setState(() {
      showProgress = true;
    });

    imageName = basename(randomAlphaNumeric(10) + ".jpg");
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      showProgress = false;
      print('saved $imageName');
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

  Map<String, dynamic> categoriesResponse;
  RentcityCategory _rentcityCategory;
  List<Listcategories> categoryList;

  Future<List<Listcategories>> getCategories() async {
    setState(() {
      showProgress = true;
    });
    var response = await http.get(
        Uri.encodeFull(
            "http://api.rentcity.in/Service1.svc/GetAllRentcityCategory"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      categoriesResponse = json.decode(response.body);
      _rentcityCategory = new RentcityCategory.fromJsonMap(categoriesResponse);
      categoryList = _rentcityCategory.listcategories;
      print(categoryList.length);
      showProgress = false;
      //  var streetsFromJson = extractdata['listCity'];
      // data= new List<ListCity>.from(streetsFromJson);
    });

    return categoryList;
  }

  @override
  void initState() {
    loadUserID();
    loadCityID();
    getCategories();
    iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    );
    iconAnimationController.forward();

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
    if(!isAgrrementSHown){
      isAgrrementSHown=true;
      new Future.delayed(Duration.zero, () {
        showAlertDialogAgreement(context);
      });
    }

    return new Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.orange,
          brightness: Brightness.dark,
          title: new Text("Add Product"),
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
                                child:
                                new Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        RotationTransition(
                                          turns: Tween(begin: 0.0, end: 1.0)
                                              .animate(iconAnimationController),
                                          child: _image == null
                                              ? IconButton(
                                              onPressed: () {
                                                showAlertDialog(context);
                                              },
                                              iconSize: 80.0,
                                              icon: new Icon(
                                                Icons.camera,
                                                color: Colors.orange,
                                              ))
                                              : Image.file(
                                            _image,
                                            width: 140,
                                            height: 120,
                                          ),
                                        ),
                                      ],
                                    ),
                                    new TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: productNameController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Product Name';
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                          labelText: "Enter Product Name"),
                                      keyboardType: TextInputType.text,
                                    ),
                                    new TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: descriptionController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Product Description';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText:
                                            "Enter Product Description"),
                                        keyboardType: TextInputType.text),
                                    new TextFormField(
                                        textInputAction: TextInputAction.next,

                                        controller: specificationController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Product Specification ';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText:
                                            "Enter Product Specification"),
                                        keyboardType: TextInputType.text),
                                    new TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: productRentController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Product Rent Amount ';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText: "Enter Product Rent Amount"),
                                        keyboardType: TextInputType.phone),
                                    new TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: productSecurityController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Security Amount ';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                            labelText:
                                            "Enter Security Amount"),
                                        keyboardType: TextInputType.phone),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 5)),
                                    new DropdownButton(
                                      hint: Text("Select Category",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black)),
                                      isDense: true,
                                      isExpanded: true,
                                      items: categoryList?.map((item) {
                                        return new DropdownMenuItem(
                                          child: Column(
                                            children: <Widget>[
                                              new Text(item.CategoryName),
                                            ],
                                          ),
                                          value: item.CategoryID.toString(),
                                        );
                                      })?.toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          categoryID = newVal;
                                        });
                                      },
                                      value: categoryID,
                                    ) ??
                                        [],
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
                                          "Add Product",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        splashColor: Colors.orange,
                                        onPressed: () {
                                          // Validate returns true if the form is valid, otherwise false.
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              if (_image == null) {
                                                showAlertDialog(context);
                                              } else {
                                                showProgress = true;
                                                addProduct().then((value) {
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
                                                    RxBus.post(
                                                        UpdateMyProducts());
                                                    Navigator.pop(context);
                                                  }
                                                });
                                              }
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
    descriptionController.dispose();
    specificationController.dispose();
    productNameController.dispose();
    productRentController.dispose();
    productSecurityController.dispose();
    iconAnimationController.dispose();
    buttonController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Galley"),
      onPressed: () {
        getImage(context);
        Navigator.pop(context);
      },
    );
    Widget launchButton = FlatButton(
      child: Text("Camera"),
      onPressed: () {
        getCamera(context);
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

  showAlertDialogAgreement(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("I Agree"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget launchButton = FlatButton(
      child: Text("View Agreement"),
      onPressed: () {
        _launchURL();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Vender Supplier Agreement"),
      content: Text(
          "By Clicking, I agree You are accepting Vender Supplier Agreement  "),
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
  _launchURL() async {
    const url = 'http://rentcity.in/RentcityVendorAggrement.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
