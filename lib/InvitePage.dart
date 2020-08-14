import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/MainPageTwo.dart';
import 'package:SpotEasy/Sdsd.dart';
import 'package:SpotEasy/HomePage.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/eventbus/RefreshHomeEvent.dart';
import 'package:SpotEasy/eventbus/UpdateCityName.dart';
import 'package:SpotEasy/list_city.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'package:rxbus/rxbus.dart';
import 'package:share/share.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';

class InvitePage extends StatefulWidget {
  @override
  State createState() => new InvitePageState();
}

class InvitePageState extends State<InvitePage> {
  String referalCode="";
  loadreferalCode() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "ReferralCode";
    setState(() {
      referalCode = prefs.getString(key) ?? "0";
    });


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadreferalCode();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color(0xff24293c),
          brightness: Brightness.dark,
          title: new Text("Invite & Earn"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),

          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              color: Colors.deepPurple,
              height: 200,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(child: Image.asset('assets/inviteimage.png',width: 200,)),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.deepPurple,
              height: 300,
              child:
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      child: Text(
                        "Refer your friend and earn Spot-Easy points",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Your Invite Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      child: DottedBorder(
                        color: Colors.purpleAccent,
                        strokeWidth: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            referalCode,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new MaterialButton(
                    minWidth: 170,

                    height: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        new BorderRadius.circular(20),
                        side: BorderSide(
                            color: Colors.lightBlue)),
                    color: const Color(0xff24293c),
                    textColor: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.share, color: Colors.white,),
                      ),Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Invite  now",style: TextStyle(fontSize: 17),),
                      )],
                    ),
                    splashColor: const Color(0xff24293c),
                    onPressed: () {
                      Share.share('Guess what?You can earn upto 100 RentCity Points on signup with rentCity.Just use my referal code $referalCode Download Now: https://play.google.com/store/apps/details?id=com.app.rentcity', subject: 'Refer and Earn');
                    },
                  )


                ],
              ),

            )
          ],
        ));
  }
}
