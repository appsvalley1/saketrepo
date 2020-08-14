import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/HomePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  AnimationController iconAnimationController;
  Animation<double> iconAnimation;

  final scaffoldState = GlobalKey<ScaffoldState>();
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    iconAnimation = new CurvedAnimation(
        parent: iconAnimationController, curve: Curves.easeOut);
    iconAnimation.addListener(() => setState(() {}));
    iconAnimationController.forward();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  List<Widget> _buildForm(BuildContext context) {
    Form form = new Form(
        key: _formKey,
        child: Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              inputDecorationTheme: new InputDecorationTheme(
                  labelStyle: new TextStyle(color: Colors.white))),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: new Column(
              children: <Widget>[
                new FlutterLogo(
                  size: iconAnimation.value * 100,
                ),
                new TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Email';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      hintText: "Enter Name", labelText: "Enter The Name"),
                  keyboardType: TextInputType.emailAddress,
                ),
                new TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                    decoration: new InputDecoration(
                        hintText: "Enter Password",
                        labelText: "Enter The Password"),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true),
                new Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0)),
                new MaterialButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: new Text("Login Now"),
                  splashColor: Colors.amberAccent,
                  onPressed: () {
                    setState(() {
                      _saving = true;
                    });
                    new Future.delayed(new Duration(seconds: 4), () {
                      setState(() {
                        _saving = false;
                      });
                    });
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      /*  scaffoldState.currentState.showSnackBar(
                                    new SnackBar(content: new Text('Hello!')));*/

                    }
                  },
                )
              ],
            ),
          ),
        ));

    var l = new List<Widget>();
    l.add(form);

    if (_saving) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      l.add(modal);
    }

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage('assets/bg.png'),
            width: 100,
            height: 100,
            fit: BoxFit.fill,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildForm(context),
          )
        ],
      ),
    );
  }
}
