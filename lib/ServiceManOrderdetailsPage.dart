import 'package:SpotEasy/ChatScreenPage.dart';
import 'package:SpotEasy/ProductFullScreenPage.dart';
import 'package:SpotEasy/floordb/CartModel.dart';
import 'package:SpotEasy/loginresponse/LoginResp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/CartDetailsPage.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/UpdateKYCProductPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ServiceManOrdersModel/ServiceOrderDetailsResponse.dart';
import 'ServiceManOrdersModel/list_orders.dart';
import 'ServiceManOrdersModel/list_products.dart';
import 'floordb/database.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ServiceManOrderdetailsPage extends StatefulWidget {
  ListOrders _orderDetail;

  ServiceManOrderdetailsPage(this._orderDetail);

  @override
  State createState() => new DetailsState(_orderDetail);
}

class DetailsState extends State<ServiceManOrderdetailsPage> {
  ListOrders _orders;

  String userID = "";

  DetailsState(this._orders);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<String, dynamic> serviceProducts;
  ServiceOrderDetailsResponse serviceOrderDetailsResponse;

  List<ListProducts> productList;
  bool showProgress = true;

  GoogleMapController mapController;
  LatLng _center;



  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    setState(() {
      markers.clear();
      final MarkerId markerId = MarkerId(_orders.OrderID.toString());
      final marker = Marker(
        markerId: MarkerId(_orders.OrderID.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: _orders.ShippingAddress,
          snippet: _orders.ShippingAddress,
        ),
      );
      markers[markerId] = marker;
    });
  }


  Future<List<ListProducts>> getMyOrders() async {
    var response = await http.get(Uri.encodeFull(
        "http://api.rentcity.in/Service1.svc/GetProductsByOrderIDForService?OrderID=" +
            _orders.OrderID.toString()));
    print(
        "http://api.rentcity.in/Service1.svc/GetProductsByOrderIDForService?OrderID=" +
            _orders.OrderID.toString());

    serviceProducts = json.decode(response.body);
    serviceOrderDetailsResponse =
        new ServiceOrderDetailsResponse.fromJsonMap(serviceProducts);
    print(response.request);
    productList = serviceOrderDetailsResponse.listProducts;
    showProgress = false;
    if (mounted) {
      setState(() {});
    }

    return productList;
  }

  Future<LoginResp> generateOTP(String Type) async {
    var response = await http.get(Uri.encodeFull(
        "http://api.rentcity.in/Service1.svc/GenerateOTP?OrderID=" +
            _orders.OrderID.toString() +
            "&type=" +
            Type));
    print("http://api.rentcity.in/Service1.svc/GenerateOTP?OrderID=" +
        _orders.OrderID.toString() +
        "&type=" +
        Type);

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

    getMyOrders();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserID();
    _center =  LatLng(num.tryParse(_orders.Latitude).toDouble(),num.tryParse(_orders.Longitude).toDouble());
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
        title: new Text("Service Details"),
        actions: <Widget>[

        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 400.0),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(
                    top: 0.0, bottom: 0, right: 5, left: 5),
                child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Container(
                                      width: 200,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          Text(
                                            "OrderID: " +
                                                _orders.OrderID.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            softWrap: true,
                                            style: TextStyle(

                                                fontSize: 15),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Container(
                                      width: 400,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          Text(
                                            "Service Date: " +
                                                _orders.StartDate,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            softWrap: true,
                                            style: TextStyle(

                                                fontSize: 15),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    child: Container(
                                      width: 400,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: <Widget>[
                                          Text(
                                            "Service Address: " +
                                                _orders.ShippingAddress
                                                    .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            softWrap: true,
                                            style: TextStyle(

                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
              Visibility(
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(

                        height: 250,
                        child: GoogleMap(
                          markers:  Set<Marker>.of(markers.values),
                          initialCameraPosition: CameraPosition(
                            target: _center,

                            zoom: 18.0,
                          ),
                          onMapCreated: _onMapCreated,
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))


                        )),
                    elevation: 10,

                  ),
                ),
                visible:(_orders.StartServiceOTPStatus==1&&_orders.EndServiceOTPStatus==1)?false:true ,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                          height: 200.0,
                          child: AnimationLimiter(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  productList == null ? 0 : productList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    duration: Duration(milliseconds: 800),
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: Card(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: new Text(
                                                        productList[index]
                                                            .ProductName
                                                            .toString(),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  flex: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                    )
                  ],
                ),
              ),

              Visibility(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                        child: new MaterialButton(
                          minWidth: 350,
                          height: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20),
                              side: BorderSide(color: const Color(0xff24293c))),
                          color: const Color(0xff24293c),
                          textColor: Colors.white,
                          child: new Text(_orders.OrderStatus == 2
                              ? " Start Service  (Request OTP)"
                              : "Complete Service  (Request OTP)"),
                          splashColor: Colors.amberAccent,
                          onPressed: () {
                            print(_orders.OrderStatus);

                            if (_orders.OrderStatus == 2) {
                              generateOTP("1").then((value) {
                                // Run extra code here
                                Fluttertoast.showToast(
                                    msg:
                                        "OTP Sent , Please verify to start service",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              });
                            } else {
                              generateOTP("2").then((value) {
                                // Run extra code here
                                Fluttertoast.showToast(
                                    msg:
                                    "OTP Sent , Please verify to end service",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                visible:(_orders.StartServiceOTPStatus==1&&_orders.EndServiceOTPStatus==1)?false:true ,
              )
            ],
          )
        ],
      ),
    );
  }
}
