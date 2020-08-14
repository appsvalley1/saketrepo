import 'package:SpotEasy/ChatScreenPage.dart';
import 'package:SpotEasy/ProductFullScreenPage.dart';
import 'package:SpotEasy/ServiceManOrdersModel/ServicemanOrders.dart';
import 'package:SpotEasy/eventbus/RefreshServiceActiveOrders.dart';
import 'package:SpotEasy/floordb/CartModel.dart';
import 'package:audioplayers/audio_cache.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/CartDetailsPage.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/UpdateKYCProductPage.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'floordb/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'loginresponse/LoginResp.dart';

class ServiceOrdersPage extends StatefulWidget {
  @override
  State createState() => new ServiceOrdersPageState();
}

class ServiceOrdersPageState extends State<ServiceOrdersPage>
    with SingleTickerProviderStateMixin {
  bool showProgress = false;
  String userID = "";

  var _firebaseRef = FirebaseDatabase().reference().child('orders');
  AnimationController buttonController;
  Animation<double> buttonAnimation;

  Future<LoginResp> registerUser(String orderid) async {
    final response = await http.get(
        "http://api.rentcity.in/Service1.svc/AssignMeToOrder?OrderID=" +
            orderid +
            "&OrderAssignedTo=" +
            userID);
    print("http://api.rentcity.in/Service1.svc/AssignMeToOrder?OrderID=" +
        orderid +
        "&OrderAssignedTo=" +
        userID);
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

  static AudioCache _player = AudioCache();
  static const _audioPath = "audios/ordersound.mp3";
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<AudioPlayer> playAudio() async {
    return _player.play(_audioPath);
  }

  void _stop() {
    if (_audioPlayer != null) {
      _audioPlayer.stop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    buttonController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 0.5);
    buttonAnimation =
        CurvedAnimation(parent: buttonController, curve: Curves.linear);
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
          title: new Text("Live Orders"),
          actions: <Widget>[],
        ),
        body: Container(
          child: StreamBuilder(
            stream: _firebaseRef.onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                Map data = snap.data.snapshot.value;

                var order = new ServiceOrder();

                data.forEach((key, value) {
                  print(value['ShippingAddress']);

                  order.ShippingAddress = value['ShippingAddress'];
                  order.OrderID = value['OrderID'].toString();
                  order.StartDate = value['StartDate'];
                  order.TotalAmountPaid = value["TotalAmountPaid"];
                });
                playAudio().then((player) {
                  _audioPlayer = player;
                  buttonController.reset();
                  buttonController.forward();
                });

                return Container(
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Service ID:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(order.OrderID,
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Date",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(order.StartDate,
                                        style: TextStyle(fontSize: 16))
                                  ],
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: MaterialButton(
                                    minWidth: 350,
                                    height: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: const Color(0xff24293c))),
                                    color: const Color(0xff24293c),
                                    textColor: Colors.white,
                                    child: new Text(
                                      "Accept",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    splashColor: Colors.orange,
                                    onPressed: () {
                                      registerUser(order.OrderID).then((value) {
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
                                          RxBus.post(
                                              RefreshServiceActiveOrders());
                                          Navigator.pop(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: value.TransactionMesage,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                showProgress
                                    ? new Center(
                                        child: new CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(Colors.orange)))
                                    : Text(""),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                  color: Colors.black,
                                  child: Column(
                                    children: [
                                      ScaleTransition(
                                          scale: buttonAnimation,
                                          child: Text("New Order Recieved",
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 30))),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                )
                              ],
                            ),
                            elevation: 10),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                );

                Text(order.ShippingAddress);
              } else
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.firstOrder,
                          size: 35,
                          color: Colors.orange,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("No Live  Orders Keep Screen on",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Text("Looks like No Live orders are there",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                      ],
                    ),
                  ),
                );
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ));
  }
}
