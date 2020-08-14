import 'package:SpotEasy/eventbus/RefreshMyProductsEvent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/HomePage.dart';
import 'package:SpotEasy/MyOrdersPage.dart';
import 'package:SpotEasy/MyProductsPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import 'eventbus/RefreshMyOrders.dart';

class MainPageTwo extends StatefulWidget {
  @override
  State createState() => new MainPageState();
}

class MainPageState extends State<MainPageTwo>
    with SingleTickerProviderStateMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();
  String pageName = "Home";
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  int userKYC;
  bool showKYC = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    loadlocation();
    loaduserKYC();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        _scheduleNotification(message);
      },

    );
  }

  SelectNotification(dynamic payload) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      dynamic notification;
      if (payload.containsKey('data')) {
        // Handle data message
        RxBus.post(
            RefreshMyOrders());
        notification = payload['data'];
      }

      if (payload.containsKey('notification')) {
        // Handle notification message
        RxBus.post(
            RefreshMyOrders());
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
  _launchFB() async {
    const url = 'https://www.facebook.com/rentcity.serv.5';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchTwitter() async {
    const url = 'https://twitter.com/RentCity2';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchInsta() async {
    const url = 'https://www.instagram.com/rentcity.services/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
loadlocation() async{

  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

}

  loaduserKYC() async {

    final prefs = await SharedPreferences.getInstance();
    final key = "userKYC";
    setState(() {
      userKYC = prefs.getInt(key) ?? "0";
      print("KYC MAIN PAGE$userKYC");
      if (userKYC == 0) {
        showKYC = true;
      }
      else {
        showKYC = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      drawer: SafeArea(
        child: new Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: new Column(
                  children: <Widget>[
                    new Image(
                      image: new AssetImage('assets/splogo.png'),
                      width: 120,
                      height: 120,
                    ),
                  ],
                ),
              ),


              Divider(
                color: Colors.grey[500],
              ),

              Container(
                color: const Color(0xff24293c),
                child: ListTile(
                  title: Text("Invite & Earn",
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text("Invite and Earn free points",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/InvitePage");
                  },
                  trailing: Icon(FontAwesomeIcons.gem, color: Colors.blue),
                ),
              ),


              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                title: Text("Change Password"),
                subtitle: Text(
                    "Change every month, You will be just being extra safe"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/ChangePasswordPage");
                },
                trailing: Icon(Icons.verified_user, color: const Color(0xff24293c)),
              ),
              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                title: Text("Contact Support"),
                subtitle: Text(
                    "You can also share Order ID in case of any order issues"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/ContactSuport");
                },
                trailing: Icon(Icons.contact_mail, color:const Color(0xff24293c)),
              ),

              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                title: Text("FAQ "),
                subtitle: Text("How this app works"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/FAQPage");
                },
                trailing: Icon(Icons.question_answer, color: const Color(0xff24293c)),
              ),


              Divider(
                color: Colors.grey[500],
              ),
              ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.forward, color: const Color(0xff24293c)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return new FunkyLogout();
                    },
                  );
                },
              ),

              Divider(
                color: Colors.grey[500],
              ),
           Center(child: Text("Follow us on",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
              Container(
                width: 400,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: new IconButton(
                        // Use the FontAwesomeIcons class for the IconData
                          icon: new Icon(FontAwesomeIcons.facebook,color: Colors.blue,size:50 ,),
                          onPressed: () {_launchFB(); }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,20,0),
                      child: new IconButton(
                        // Use the FontAwesomeIcons class for the IconData
                          icon: new Icon(FontAwesomeIcons.twitter,color: Colors.blue,size:50 ,),
                          onPressed: () { _launchTwitter(); }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: new IconButton(
                        // Use the FontAwesomeIcons class for the IconData
                          icon: new Icon(FontAwesomeIcons.instagram,color: Colors.red,size:50 ,),
                          onPressed: () { _launchInsta(); }
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.dashboard, color: Colors.white),
          onPressed: () => scaffoldState.currentState.openDrawer(),
        ),
        actionsIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff24293c),
        brightness: Brightness.dark,
        title: new Text(pageName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, "/SearchByProductPage");
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, "/ViewCart");
            },
          ),

          Visibility(
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                RxBus.post(RefreshMyProductsEvent());
              },
            ),
            visible: pageName=="My Products"?true:false,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
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
                      pageName = "Home";
                    });
                    break;
                  case 1:
                    setState(() {
                      pageName = "My Subscriptions";
                    });
                    break;
                  case 2:
                  case 1:
                    setState(() {
                      pageName = "My Products";
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
                      "Home",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    new Icon(Icons.shop_two),
                    new Text(
                      "My Subscriptions",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    new Icon(Icons.notifications),
                    new Text(
                      "My AMC's",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
            children: [
              HomePage(),
              MyOrdersPage(),
              MyProductsPage(),
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


class FunkyLogout extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => FunkyLogoutState();
}

class FunkyLogoutState extends State<FunkyLogout>
    with SingleTickerProviderStateMixin {

  FunkyLogoutState();

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

  logoutUser() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
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
                  Text("Are you sure you want to logout?", style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "You need to relogin in order to use the app later",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(alignment: Alignment.center,
                          child: new MaterialButton(
                            minWidth: 140,
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(alignment: Alignment.center,
                          child: new MaterialButton(
                            minWidth: 140,
                            height: 50,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.circular(20),
                                side:
                                BorderSide(color: Colors.orange)),
                            color: Colors.orange,
                            textColor: Colors.white,
                            child: new Text(
                              "Logout ",
                              style: TextStyle(fontSize: 18),
                            ),
                            splashColor: Colors.orange,
                            onPressed: () {
                              logoutUser();
                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil('/PrivacyPage', (
                                  Route<dynamic> route) => false);
                            },
                          ),
                        ),
                      )
                    ],
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