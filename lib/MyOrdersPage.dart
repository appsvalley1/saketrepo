import 'dart:async';
import 'dart:convert';

import 'package:SpotEasy/ContactSuportOrders.dart';
import 'package:SpotEasy/eventbus/RefreshMyOrders.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/registerresponse/RegisterResponse.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:SpotEasy/Response/MyOrders/list_orders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SpotEasy/Response/MyOrders/MyOrdersResponse.dart';

import 'EndServiceOTPScreen.dart';
import 'StartServiceOTP.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  State createState() => new MyOrdersPageState();
}

class MyOrdersPageState extends State<MyOrdersPage>
    with AutomaticKeepAliveClientMixin {
  bool showProgress = true;
  bool showCustomercare = false;
  String userid;

  Map<String, dynamic> myOrdersResponse;
  MyOrdersResponse orders;
  List<ListOrders> orderList;

  List<String> status = new List();

  Future<List<ListOrders>> getMyOrders() async {


    var response = await http.get(Uri.encodeFull(
        "http://api.rentcity.in/Service1.svc/GetMyOrders?UserId=" + userid));

    myOrdersResponse = json.decode(response.body);
    orders = new MyOrdersResponse.fromJsonMap(myOrdersResponse);
    print(myOrdersResponse);
    orderList = orders.listOrders;
    showProgress = false;
    if (mounted) {
      setState(() {});
    }

    return orderList;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status.add("Assigning Service Man");
    status.add("Service Start");
    status.add("Service End");
    status.add("Service Completed");
    loadUserId();
    print("loaded");
    registerBus();
  }

  void registerBus() {
    RxBus.register<RefreshMyOrders>().listen((event) =>
        setState(() {
          getMyOrders();
        }));
  }

  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
    getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: (orderList == null || orderList.length == 0)
                  ? (!showProgress)
                  ? Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/emptycart.png'),
                          width: 80,
                          color: Colors.redAccent,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("No Subscriptions Found",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Text(
                            "Looks like you haven't subscribed our services",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45)),
                      ],
                    ),
                  )
                ],
              )
                  : Container()
                  : ListView(
                shrinkWrap: true,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height - 150,
                            child:
                            (orderList == null || orderList.length == 0)
                                ? Text("No Subscription Found")
                                : AnimationLimiter(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: orderList == null
                                    ? 0
                                    : orderList.length,
                                itemBuilder: (BuildContext context,
                                    int index) {
                                  return AnimationConfiguration
                                      .staggeredList(
                                    position: index,
                                    duration: const Duration(
                                        milliseconds: 375),
                                    child: SlideAnimation(
                                      duration: Duration(
                                          milliseconds: 800),
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Container(
                                          constraints:
                                          BoxConstraints(
                                              minWidth: 400.0),
                                          alignment:
                                          Alignment.centerLeft,
                                          margin:
                                          const EdgeInsets.only(
                                              top: 0.0,
                                              bottom: 0,
                                              right: 5,
                                              left: 5),
                                          child: Card(
                                              elevation: 10,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .all(10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  mainAxisSize:
                                                  MainAxisSize
                                                      .max,
                                                  children: <
                                                      Widget>[
                                                    Container(
                                                      width: MediaQuery
                                                          .of(
                                                          context)
                                                          .size
                                                          .width,
                                                      child: Wrap(
                                                        direction: Axis
                                                            .horizontal,
                                                        children: <
                                                            Widget>[
                                                          Text(
                                                          "OrderID "+  orderList[index]
                                                                .OrderID.toString(),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            maxLines:
                                                            2,
                                                            softWrap:
                                                            true,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: 18),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      children: <
                                                          Widget>[
                                                        Row(
                                                          children: <
                                                              Widget>[],
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: <
                                                          Widget>[],
                                                    ),
                                                    Column(
                                                      children: <
                                                          Widget>[
                                                        Row(
                                                          children: <
                                                              Widget>[
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Total Amount: " +
                                                                      orderList[index]
                                                                          .TotalAmountPaid
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight
                                                                          .bold,
                                                                      fontSize: 14),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: <
                                                          Widget>[
                                                        Row(
                                                          children: <
                                                              Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                        status[orderList[index]
                                                            .OrderStatus -
                                                        1],
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: 12),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            new MaterialButton(
                                                              minWidth:
                                                              100,
                                                              height:
                                                              30,
                                                              shape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius: new BorderRadius
                                                                      .circular(
                                                                      20),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .orange)),
                                                              color:
                                                              Colors.orange,
                                                              textColor:
                                                              Colors.white,
                                                              child:
                                                              new Text(
                                                                (orderList[index]
                                                                    .OrderStatus ==
                                                                    1)
                                                                    ? "Contact support"
                                                                    : (orderList[index]
                                                                    .OrderStatus ==
                                                                    4 &&
                                                                    orderList[index].EndServiceOTPStatus==1)
                                                                    ? "Contact  support"
                                                                    : "Enter OTP",
                                                                style: TextStyle(
                                                                    fontSize: 15),
                                                              ),
                                                              splashColor:
                                                              Colors.red,
                                                              onPressed:
                                                                  () {
                                                                if (orderList[index]
                                                                    .OrderStatus ==
                                                                    1) {
                                                                  Navigator.of(
                                                                      context)
                                                                      .push(
                                                                      new MaterialPageRoute(
                                                                          builder: (
                                                                              BuildContext context) =>
                                                                          new ContactSuportOrders(
                                                                              orderList[index])));
                                                                } else {
                                                                  if (orderList[index]
                                                                      .StartServiceOTPStatus ==
                                                                      0) {
                                                                    Navigator
                                                                        .of(
                                                                        context)
                                                                        .push(
                                                                        new MaterialPageRoute(
                                                                            builder: (
                                                                                BuildContext context) =>
                                                                            new StartServiceOTPPage(
                                                                                orderList[index]
                                                                                    .OrderID
                                                                                    .toString())));
                                                                  } else {
                                                                    if (orderList[index]
                                                                        .EndServiceOTPStatus ==
                                                                        0) {
                                                                      Navigator
                                                                          .of(
                                                                          context)
                                                                          .push(
                                                                          new MaterialPageRoute(
                                                                              builder: (
                                                                                  BuildContext context) =>
                                                                              new EndServiceOTPScreen(
                                                                                  orderList[index]
                                                                                      .OrderID
                                                                                      .toString())));
                                                                    } else {
                                                                      if (orderList[index]
                                                                          .OrderStatus ==
                                                                          4 &&
                                                                          orderList[index]
                                                                              .EndServiceOTPStatus ==
                                                                              1) {
                                                                        Navigator
                                                                            .of(
                                                                            context)
                                                                            .push(
                                                                            new MaterialPageRoute(
                                                                                builder: (
                                                                                    BuildContext context) =>
                                                                                new ContactSuportOrders(
                                                                                    orderList[index])));
                                                                      }
                                                                      else {

                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
            showProgress
                ? new Center(
                child: new CircularProgressIndicator(
                    valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.orange)))
                : Container()
          ],
        ));
  }
}
