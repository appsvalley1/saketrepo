import 'dart:async';
import 'dart:convert';

import 'package:SpotEasy/eventbus/UpdateMyProducts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:SpotEasy/RentcityProducts.dart';

import 'package:SpotEasy/list_products.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:http/http.dart' as http;
import 'package:rxbus/rxbus.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'eventbus/RefreshMyProductsEvent.dart';
import 'loginresponse/LoginResp.dart';



class MyProductsPage extends StatefulWidget {
  @override
  State createState() => new MyProductsPageState();
}

class MyProductsPageState extends State<MyProductsPage>
    with AutomaticKeepAliveClientMixin {




  @override
  bool get wantKeepAlive => true;



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
        body:
       Text("No New Notificationa"));
  }
}

