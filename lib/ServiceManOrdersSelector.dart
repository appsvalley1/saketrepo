import 'package:SpotEasy/ServiceManCompletedOrders.dart';
import 'package:SpotEasy/ServiceOrdersPage.dart';
import 'package:SpotEasy/eventbus/RefreshMyProductsEvent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/HomePage.dart';
import 'package:SpotEasy/MyOrdersPage.dart';
import 'package:SpotEasy/MyProductsPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'ServiceManActiveOrders.dart';
import 'eventbus/RefreshServiceActiveOrders.dart';
import 'loginresponse/LoginResp.dart';

class ServiceManOrdersSelector extends StatefulWidget {
  @override
  State createState() => new ServiceManOrdersSelectorState();
}

class ServiceManOrdersSelectorState extends State<ServiceManOrdersSelector>
    with SingleTickerProviderStateMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();
  String pageName = "Home";

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String RegistrationID = "";
  String userid;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  SelectNotification(dynamic payload) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      dynamic notification;
      if (payload.containsKey('data')) {
        // Handle data message
        RxBus.post(
            RefreshServiceActiveOrders());
        notification = payload['data'];
      }

      if (payload.containsKey('notification')) {
        // Handle notification message
        RxBus.post(
            RefreshServiceActiveOrders());
        notification = payload['notification'];
      }
      showDialog(
        context: context,
        builder: (_) {
          return new FunkyOverlay(notification);
        },
      );
    });
  }
  Future _scheduleNotification(dynamic msg) async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: SelectNotification(
            msg
        ));
  }
  loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "RegistrationID";
    RegistrationID = prefs.getString(key) ?? "0";
    updateUserRegistrationID();
  }
  Future<LoginResp> updateUserRegistrationID() async {
    final response = await http.get(
        "http://api.rentcity.in/Service1.svc/UpdateUserRegistrationID?UserId=" +
            userid +
            "&RegistrationID=" +
            RegistrationID);
  }

  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
    updateUserRegistrationID();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserId();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        _scheduleNotification(message);
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color(0xff24293c),
        brightness: Brightness.dark,

        title: new Text("SPOT Service"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.firstOrder,
              size: 35,
              color: Colors.orange,
            ),
            onPressed: () {


              Route route = MaterialPageRoute(builder: (context) => ServiceOrdersPage());
              Navigator.push(context, route);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 35,
              color: Colors.orange,
            ),
            onPressed: () {
              RxBus.post(
                  RefreshServiceActiveOrders());


            },
          ),

        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: new SizedBox(
            height: 60,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: const Color(0xff24293c),
              onTap: (index) {
                switch (index) {
                  case 0:
                    setState(() {
                      pageName = "Active Orders";
                    });
                    break;
                  case 1:
                    setState(() {
                      pageName = "Past Orders";
                    });
                    break;

                }
              },
              labelPadding: const EdgeInsets.all(10),
              tabs: [
                Column(
                  children: <Widget>[
                    new Icon(Icons.dashboard),
                    new Text(
                      "Active Orders",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    new Icon(Icons.shop_two),
                    new Text(
                      "Past Orders",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),

              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
            children: [
              ServiceManActiveOrders(),
              ServiceManCompletedOrders(),

            ],
          )
          ,
        )
        ,
      )
      ,
    );
  }


}

class FunkyOverlay extends StatefulWidget {
  dynamic notification;

  FunkyOverlay(this.notification);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState(notification);
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  dynamic notification;

  FunkyOverlayState(this.notification);

  AnimationController locationAnimationController;
  Animation<double> locationAnimation;

  @override
  void initState() {
    super.initState();

    locationAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    locationAnimation = Tween<double>(begin: 200, end: 0).chain(
        CurveTween(curve: Curves.easeInOutBack)).animate(
        locationAnimationController)
      ..addListener(() {
        setState(() {});
      });
    locationAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Transform.translate(
          offset: Offset(0, locationAnimation.value),
          child: Container(
            height: 200,
            width: MediaQuery
                .of(context)
                .size
                .width - 50,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(notification["title"], style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        notification["body"], style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Align(alignment: Alignment.center,
                    child: new MaterialButton(
                      minWidth: 200,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(20),
                          side:
                          BorderSide(color: Colors.orange)),
                      color: Colors.orange,
                      textColor: Colors.white,
                      child: new Text(
                        "Close",
                        style: TextStyle(fontSize: 18),
                      ),
                      splashColor: Colors.orange,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
