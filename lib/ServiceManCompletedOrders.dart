import 'dart:async';
import 'dart:convert';

import 'package:SpotEasy/ContactSuportOrders.dart';
import 'package:SpotEasy/ServiceManOrderdetailsPage.dart';

import 'package:flutter/material.dart';
import 'package:SpotEasy/registerresponse/RegisterResponse.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:rxbus/rxbus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SpotEasy/Response/MyOrders/MyOrdersResponse.dart';

import 'ServiceManOrdersModel/AcriveOrderResponse.dart';
import 'ServiceManOrdersModel/list_orders.dart';
import 'StartServiceOTP.dart';
import 'eventbus/RefreshServiceActiveOrders.dart';

class ServiceManCompletedOrders extends StatefulWidget {
  @override
  State createState() => new ServiceManCompletedOrdersState();
}

class ServiceManCompletedOrdersState extends State<ServiceManCompletedOrders>
    with AutomaticKeepAliveClientMixin {
  bool showProgress = true;
  bool showCustomercare = false;
  String userid;

  Map<String, dynamic> myOrdersResponse;
  AcriveOrderResponse orders;
  List<ListOrders> orderList;

  List<String> status = new List();

  Future<List<ListOrders>> getMyOrders() async {
    var response = await http.get(Uri.encodeFull(
        "http://api.rentcity.in/Service1.svc/GetCompletedAssignedOrdersBy?OrderAssignedTo=" +
            userid));
    print(
        "http://api.rentcity.in/Service1.svc/GetCompletedAssignedOrdersBy?OrderAssignedTo=" +
            userid);

    myOrdersResponse = json.decode(response.body);
    orders = new AcriveOrderResponse.fromJsonMap(myOrdersResponse);
    print(response.request);
    orderList = orders.listOrders;
    showProgress = false;
    if (mounted) {
      setState(() {});
    }

    return orderList;
  }


  void registerBus() {
    RxBus.register<RefreshServiceActiveOrders>().listen((event) => setState(() {
         getMyOrders();
        }));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    status.add("Assigning Service Man");
    status.add("Service Man Assigned");
    status.add("Subscription Completed");
    loadUserId();
    print("loaded");
    registerBus();
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
                  ? Container(
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
                              child: Text("No Past Orders",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                            Text("You have not competed any service yet",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45)),
                          ],
                        ),
                      ),
                    )
                  : Container()
              : ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height - 150,
                              child:
                                  (orderList == null || orderList.length == 0)
                                      ? Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.firstOrder,
                                                  size: 35,
                                                  color: Colors.orange,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("No New Orders",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                ),
                                                Text(
                                                    "You have not competed your first service order",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black45)),
                                              ],
                                            ),
                                          ),
                                        )
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
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              5,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                200,
                                                                            child:
                                                                                Wrap(
                                                                              direction: Axis.horizontal,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "OrderID: " + orderList[index].OrderID.toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
                                                                                  softWrap: true,
                                                                                  style: TextStyle( fontSize: 15),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              5,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                400,
                                                                            child:
                                                                                Wrap(
                                                                              direction: Axis.horizontal,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Service Date: " + orderList[index].StartDate,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
                                                                                  softWrap: true,
                                                                                  style: TextStyle( fontSize: 15),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              5,
                                                                              0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                400,
                                                                            child:
                                                                                Wrap(
                                                                              direction: Axis.horizontal,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Service Address: " + orderList[index].ShippingAddress.toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
                                                                                  softWrap: true,
                                                                                  style: TextStyle( fontSize: 15),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child:
                                                                      MaterialButton(
                                                                    minWidth:
                                                                        350,
                                                                    height: 50,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            new BorderRadius.circular(
                                                                                20),
                                                                        side: BorderSide(
                                                                            color:
                                                                                const Color(0xff24293c))),
                                                                    color: const Color(
                                                                        0xff24293c),
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    child:
                                                                        new Text(
                                                                      "View Service Details",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    splashColor:
                                                                        Colors
                                                                            .orange,
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              new MaterialPageRoute(builder: (BuildContext context) => new ServiceManOrderdetailsPage(orderList[index])));
                                                                    },
                                                                  ),
                                                                )
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
