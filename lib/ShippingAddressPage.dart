import 'dart:convert';

import 'package:SpotEasy/OrderResponse.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'floordb/CartModel.dart';
import 'floordb/ShippingAddress.dart';
import 'floordb/database.dart';


class ShippingAddressDetails extends StatefulWidget {


  @override
  State createState() => new ShippingAddressState();
}

class ShippingAddressState extends State<ShippingAddressDetails> {


  int tenure;
  Position _currentPosition;
  bool loginProgress = false;



  Razorpay _razorpay = Razorpay();
  String userID = "";
  List<CartModel> listAdded;
  List<CartModel> list;
  int total=0;
  String productID="";
  String Latitude="0";
  String Longitude="0";
  Future<List<CartModel>> getAllCartModels() async {
    total = 0;
    final database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    list = await database.cartModelDao.findAllCartModel();

    setState(() {
      listAdded = list;
      for (var i = 0; i < listAdded.length; i++) {
        total = total + listAdded[i].Amount;
        productID=productID+listAdded[i].ProductID.toString()+",";
      }

    });
    productID=   productID.substring(0, productID.length-1);
    print(productID);
  }


  final _formKey = GlobalKey<FormState>();
  final shippingDateController = TextEditingController();
  final houseNumberController = TextEditingController();
  final societyNoController = TextEditingController();
  final pincodeController = TextEditingController();
  final fullAdressController = TextEditingController();
  String paymentInvoiceID;
  Map<String, dynamic> data;
  OrderResponse orderResponse;
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialDate:  DateTime.now(),
      firstDate:
      DateTime.now(),
      lastDate:  DateTime.now().add( Duration(days: 15)),
        context: context,
      );


    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        shippingDateController.text=selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
      });
  }

  Future<List<CartModel>> deleteofflineData() async {
    final database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();
     await database.cartModelDao.deleteAllCartModel();
  }


  Future<OrderResponse> _finalCheckout() async {
    String address = "House No: " +
        houseNumberController.text +
        " Society: " +
        societyNoController.text +
        " Full address:" +
        fullAdressController.text;
    String url = "http://api.rentcity.in/Service1.svc/" +
        "GenerateOrder?UserId=" +
        userID +


        "&StartDate=" +
        shippingDateController.text.toString() +
        "&PaymentInvoiceID=" +
        paymentInvoiceID +
        " &ShippingAddress=" +
        address.toString() +
        "&PinCode=" +
        pincodeController.text+

        "&TotalAmountPaid=" +
        total.toString()
   + "&ProductID=" +
        productID+

        "&Latitude=" +
       Latitude
        + "&Longitude=" +
       Longitude;
    url = url.replaceAll(" ", "%20");
    print(url);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      data = json.decode(response.body);
      orderResponse = new OrderResponse.fromJsonMap(data);
      print(orderResponse);
      return orderResponse;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  loadUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userID = prefs.getString(key) ?? "0";
    loadlocation();
    // print('$userID'.length);
  }

  loadlocation() async{

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null)
      {

        Latitude=position.latitude.toString();
        Longitude=position.longitude.toString();
      }

  }
  Future<OrderResponse> _finalCheckoutWithoutPay() async {
    String address = "House No: " +
        houseNumberController.text +
        " Society: " +
        societyNoController.text +
        " Full address:" +
        fullAdressController.text;
    String url = "http://api.rentcity.in/Service1.svc/" +
        "GenerateOrder?UserId=" +
        userID +


        "&StartDate=" +
        shippingDateController.text.toString() +
        "&PaymentInvoiceID=0"+
        "&ShippingAddress=" +
        address.toString() +
        "&PinCode=" +
        pincodeController.text+

        "&TotalAmountPaid=0"
        + "&ProductID=" +
        productID+

        "&Latitude=" +
        Latitude
        + "&Longitude=" +
        Longitude;
    url = url.replaceAll(" ", "%20");
    print(url);

    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      orderResponse = new OrderResponse.fromJsonMap(data);
      print(orderResponse);
      return orderResponse;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }


  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // TODO: implement initState
    super.initState();
    getAllCartModels();
    loadUserID();

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
        title: new Text("Add Delivery Details"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),

        ],
      ),
      body:

      Stack(
        children: <Widget>[



          ListView(
            children: <Widget>[


              new Form(
                  key: _formKey,
                  child: Theme(
                    data: new ThemeData(
                        brightness: Brightness.light,
                        primarySwatch: Colors.deepOrange,
                        inputDecorationTheme: new InputDecorationTheme(
                            labelStyle: new TextStyle(color: Colors.black))),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: new Column(
                        children: <Widget>[
                          new TextFormField(
                            onTap: (){
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _selectDate(context);
                            },
                            textInputAction: TextInputAction.next,
                            controller: shippingDateController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Delivery Date';
                              }
                              return null;
                            },
                            decoration: new InputDecoration(
                                labelText: "Enter Delivery Date"),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: houseNumberController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter House/Flat no. ';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: "Enter House/Flat no. "),
                              keyboardType: TextInputType.text),
                          new TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: societyNoController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Society Name ';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: "Enter Society Name"),
                              keyboardType: TextInputType.phone),
                          new TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: fullAdressController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Type your full address ';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                  labelText: "Type your full address"),
                              keyboardType: TextInputType.text),
                          new TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: pincodeController,
                              maxLength: 6,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Pin code ';
                                }
                                return null;
                              },
                              decoration:
                              new InputDecoration(labelText: "Enter Pin code"),
                              keyboardType: TextInputType.number),
                          new Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0)),
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
                                    child: new Text("Pay Now"),
                                    splashColor: Colors.amberAccent,
                                    onPressed: () {

                                      openCheckout();


                                    },
                                  ),
                                ),
                              ),
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
                                    child: new Text("Pay after Service"),
                                    splashColor: Colors.amberAccent,
                                    onPressed: () {
                                     setState(() {
                                       loginProgress=true;
                                     });
                                      _finalCheckoutWithoutPay().then((value) {
                                        // Run extra code here
                                        if (value.TransactionStatus == 1) {

                                          setState(() {
                                            loginProgress=false;
                                          });
                                          //  saveUserID("userid",value.user.UserId);
                                          Fluttertoast.showToast(
                                              msg: value.TransactionMesage,
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          deleteofflineData();
                                          Navigator.pushReplacementNamed(context, '/MainPageTwo');


                                        }
                                      });



                                    },
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    ),
                  ))
            ],
          ),
          loginProgress
              ? new Center(
              child: new CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.orange)))
              : Container()
        ],


      ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_qHIksuUroxGMWr',
      'amount':1* 100,
      'name': 'Spot Easy',
      'description': 'Payments',
      'external': {

      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      loginProgress = true;
      paymentInvoiceID = response.paymentId;
      _finalCheckout().then((value) {
        // Run extra code here
        if (value.TransactionStatus == 1) {
          setState(() {
            loginProgress=false;
          });
          //  saveUserID("userid",value.user.UserId);
          Fluttertoast.showToast(
              msg: value.TransactionMesage,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          deleteofflineData();
          Navigator.pushReplacementNamed(context, '/MainPageTwo');


        }
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: response.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }
}
