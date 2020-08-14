import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:SpotEasy/AddProductResponse.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SpotEasy/list_products.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'loginresponse/LoginResp.dart';

class CHatScreenPage extends StatefulWidget {
  ListProducts _products;
  String chatID;
  CHatScreenPage(this._products,this.chatID);
  @override
  State createState() => new ChangePasswordState(_products,chatID);
}

class ChangePasswordState extends State<CHatScreenPage>
    with SingleTickerProviderStateMixin {
  ListProducts _products;
  String chatID;
  ChangePasswordState(this._products,this.chatID);



  bool showProgress = false;
  final db = Firestore.instance;
  final messageController = TextEditingController();
  String imageName;
  File _image;
  String userID = "";

  final scaffoldState = GlobalKey<ScaffoldState>();
  Future<LoginResp> initChat() async {
    String url =  "http://api.rentcity.in/Service1.svc/initChat?CollectionID=" +
        chatID.toString() +
        "&SenderID="+userID+"&RecieverID="+_products.user.UserId+"&DateTimed="+new DateTime.now().millisecondsSinceEpoch.toString()+"&AdID="+_products.AdID.toString();
    url = url.replaceAll(" ", "%20");
    final response = await http.get(url);
print(url);
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
    initChat();
    // print('$userID'.length);
  }

  @override
  void initState() {
    loadUserID();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.orange,
        brightness: Brightness.dark,
        title: new Text("Chat For "+_products.ProductName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),

        ],
      ),
      body: Stack(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              showProgress
                  ? new Center(
                      child: new CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.orange)))
                  : Text(""),

            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,80),
            child: Container(
                height: MediaQuery.of(context).size.height - 150,
                padding: const EdgeInsets.all(10.0),
                child:

                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(chatID.toString())
                      .orderBy("CreatedAt",descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Text('Loading...');
                      default:
                        return new ListView(
                          shrinkWrap: true,
                          reverse: true,
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return document["SenderID"] == userID
                                ? Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: <Widget>[
                                    Visibility(
                                        child: Bubble(
                                          nip: BubbleNip.rightTop,
                                          elevation: 5,
                                          margin:
                                          BubbleEdges.only(top: 20),
                                          color: Colors.blue,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                document["Content"]
                                                    .toString(),
                                                textAlign:
                                                TextAlign.right,
                                                style: prefix0.TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                        visible: int.parse(document[
                                        "MsgType"]) ==
                                            1
                                            ? true
                                            : false),
                                    Visibility(
                                        child: Image(
                                          image: new CachedNetworkImageProvider(
                                              "https://firebasestorage.googleapis.com/v0/b/rentcityfinal.appspot.com/o/" +
                                                  document["ImageURL"] +
                                                  "?alt=media&token=ea32d5b2-d29f-452d-93c9-f7092ca88794"),
                                          height: 200,
                                          width: 200,
                                        ),
                                        visible: int.parse(document[
                                        "MsgType"]) ==
                                            2
                                            ? true
                                            : false),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        readTimestamp(
                                            document["CreatedAt"]),
                                        textAlign: TextAlign.left,
                                        style: prefix0.TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12),
                                      ),
                                    )
                                  ],
                                ))
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                Visibility(
                                    child: Bubble(
                                      nip: BubbleNip.leftBottom,
                                      elevation: 5,
                                      margin: BubbleEdges.only(top: 20),
                                      color: Colors.grey[200],
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            document["Content"]
                                                .toString(),
                                            textAlign: TextAlign.right,
                                            style: prefix0.TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    visible: int.parse(
                                        document["MsgType"]) ==
                                        1
                                        ? true
                                        : false),
                                Visibility(
                                    child: Image(
                                      image: new CachedNetworkImageProvider(
                                          "https://firebasestorage.googleapis.com/v0/b/rentcityfinal.appspot.com/o/" +
                                              document["ImageURL"] +
                                              "?alt=media&token=ea32d5b2-d29f-452d-93c9-f7092ca88794"),
                                      height: 200,
                                      width: 200,
                                    ),
                                    visible: int.parse(
                                        document["MsgType"]) ==
                                        2
                                        ? true
                                        : false),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    readTimestamp(
                                        document["CreatedAt"]),
                                    textAlign: TextAlign.left,
                                    style: prefix0.TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        );
                    }
                  },
                )),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: Container(
                            child: Icon(
                          Icons.image,
                          color: Colors.orange,
                          size: 35,
                        )),
                        onTap: () {
                          showAlertDialog(context);
                        },
                      ),
                      new Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 150,
                        child: new TextFormField(
                            controller: messageController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text),
                      ),
                      InkWell(
                        onTap: () {

                          if(messageController.text=="")
                            {
                              return;
                            }
                          db.collection(chatID.toString()).add({
                            'SenderID': userID,
                            'RecieverID': _products.user.UserId,
                            'MsgType': "1",
                            'Content': messageController.text,
                            'ImageURL': "test.jpg",
                            'CreatedAt':
                                new DateTime.now().millisecondsSinceEpoch
                          });
                          messageController.text = "";
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          color: Colors.orange,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
              //your elements here
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    messageController.dispose();

    super.dispose();
  }

  Future getImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
      uploadPic(context);
    });
  }

  Future getCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      print('Image Path $_image');
      uploadPic(context);
    });
  }

  Future uploadPic(BuildContext context) async {
    setState(() {
      showProgress = true;
    });

    imageName = basename(randomAlphaNumeric(10) + ".jpg");
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      showProgress = false;
      print('saved $imageName');
      db.collection(chatID.toString()).add({
        'SenderID': userID,
        'RecieverID': _products.user.UserId,
        'MsgType': "2",
        'Content': "",
        'ImageURL': imageName,
        'CreatedAt': new DateTime.now().millisecondsSinceEpoch
      });
      messageController.text = "";
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Galley"),
      onPressed: () {
        getImage(context);
        Navigator.pop(context);
      },
    );
    Widget launchButton = FlatButton(
      child: Text("Camera"),
      onPressed: () {
        getCamera(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Upload Image"),
      content: Text("Post a clear image so the we can approve instantly"),
      actions: [
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

enum BubbleNip { no, leftTop, leftBottom, rightTop, rightBottom }

/// Class BubbleEdges is an analog of EdgeInsets, but default values are null.
class BubbleEdges {
  const BubbleEdges.fromLTRB(this.left, this.top, this.right, this.bottom);

  const BubbleEdges.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const BubbleEdges.only({
    this.left, // = null
    this.top, // = null
    this.right, // = null
    this.bottom, // = null
  });

  const BubbleEdges.symmetric({
    double vertical, // = null
    double horizontal, // = null
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  final double left;
  final double top;
  final double right;
  final double bottom;

  static get zero => BubbleEdges.all(0);

  EdgeInsets get edgeInsets =>
      EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0);

  @override
  String toString() => 'BubbleEdges($left, $top, $right, $bottom)';
}

class BubbleStyle {
  const BubbleStyle({
    this.radius,
    this.nip,
    this.nipWidth,
    this.nipHeight,
    this.nipOffset,
    this.nipRadius,
    this.stick,
    this.color,
    this.elevation,
    this.shadowColor,
    this.padding,
    this.margin,
    this.alignment,
  });

  final Radius radius;
  final BubbleNip nip;
  final double nipHeight;
  final double nipWidth;
  final double nipOffset;
  final double nipRadius;
  final bool stick;
  final Color color;
  final double elevation;
  final Color shadowColor;
  final BubbleEdges padding;
  final BubbleEdges margin;
  final Alignment alignment;
}

class BubbleClipper extends CustomClipper<Path> {
  BubbleClipper({
    this.radius,
    this.nip,
    this.nipWidth,
    this.nipHeight,
    this.nipOffset,
    this.nipRadius,
    this.stick,
    this.padding,
  })  : assert(nipWidth > 0.0),
        assert(nipHeight > 0.0),
        assert(nipRadius >= 0.0),
        assert(nipRadius <= nipWidth / 2.0 && nipRadius <= nipHeight / 2.0),
        assert(nipOffset >= 0.0),
//        assert(radius <= nipHeight + nipOffset),
        assert(padding != null),
        assert(padding.left != null),
        assert(padding.top != null),
        assert(padding.right != null),
        assert(padding.bottom != null),
        super() {
    _startOffset = _endOffset = nipWidth;

    var k = nipHeight / nipWidth;
    var a = atan(k);

    _nipCX = (nipRadius + sqrt(nipRadius * nipRadius * (1 + k * k))) / k;
    var nipStickOffset = (_nipCX - nipRadius).floorToDouble();

    _nipCX -= nipStickOffset;
    _nipCY = nipRadius;
    _nipPX = _nipCX - nipRadius * sin(a);
    _nipPY = _nipCY + nipRadius * cos(a);
    _startOffset -= nipStickOffset;
    _endOffset -= nipStickOffset;

    if (stick) _endOffset = 0.0;
  }

  final Radius radius;
  final BubbleNip nip;
  final double nipHeight;
  final double nipWidth;
  final double nipOffset;
  final double nipRadius;
  final bool stick;
  final BubbleEdges padding;

  double _startOffset; // Offsets of the bubble
  double _endOffset;
  double _nipCX; // The center of the circle
  double _nipCY;
  double _nipPX; // The point of contact of the nip with the circle
  double _nipPY;

  get edgeInsets {
    return nip == BubbleNip.leftTop || nip == BubbleNip.leftBottom
        ? EdgeInsets.only(
            left: _startOffset + padding.left,
            top: padding.top,
            right: _endOffset + padding.right,
            bottom: padding.bottom)
        : nip == BubbleNip.rightTop || nip == BubbleNip.rightBottom
            ? EdgeInsets.only(
                left: _endOffset + padding.left,
                top: padding.top,
                right: _startOffset + padding.right,
                bottom: padding.bottom)
            : EdgeInsets.only(
                left: _endOffset + padding.left,
                top: padding.top,
                right: _endOffset + padding.right,
                bottom: padding.bottom);
  }

  @override
  Path getClip(Size size) {
    var radiusX = radius.x;
    var radiusY = radius.y;
    var maxRadiusX = size.width / 2;
    var maxRadiusY = size.height / 2;

    if (radiusX > maxRadiusX) {
      radiusY *= maxRadiusX / radiusX;
      radiusX = maxRadiusX;
    }
    if (radiusY > maxRadiusY) {
      radiusX *= maxRadiusY / radiusY;
      radiusY = maxRadiusY;
    }

    var path = Path();

    switch (nip) {
      case BubbleNip.leftTop:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));

        path.moveTo(_startOffset + radiusX, nipOffset);
        path.lineTo(_startOffset + radiusX, nipOffset + nipHeight);
        path.lineTo(_startOffset, nipOffset + nipHeight);
        if (nipRadius == 0) {
          path.lineTo(0, nipOffset);
        } else {
          path.lineTo(_nipPX, nipOffset + _nipPY);
          path.arcToPoint(Offset(_nipCX, nipOffset),
              radius: Radius.circular(nipRadius));
        }
        path.close();
        break;

      case BubbleNip.leftBottom:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));

        Path path2 = Path();
        path2.moveTo(_startOffset + radiusX, size.height - nipOffset);
        path2.lineTo(
            _startOffset + radiusX, size.height - nipOffset - nipHeight);
        path2.lineTo(_startOffset, size.height - nipOffset - nipHeight);
        if (nipRadius == 0) {
          path2.lineTo(0, size.height - nipOffset);
        } else {
          path2.lineTo(_nipPX, size.height - nipOffset - _nipPY);
          path2.arcToPoint(Offset(_nipCX, size.height - nipOffset),
              radius: Radius.circular(nipRadius), clockwise: false);
        }
        path2.close();

        path.addPath(path2, Offset(0, 0));
        path.addPath(path2, Offset(0, 0)); // Magic!
        break;

      case BubbleNip.rightTop:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _startOffset, size.height, radius));

        Path path2 = Path();
        path2.moveTo(size.width - _startOffset - radiusX, nipOffset);
        path2.lineTo(
            size.width - _startOffset - radiusX, nipOffset + nipHeight);
        path2.lineTo(size.width - _startOffset, nipOffset + nipHeight);
        if (nipRadius == 0) {
          path2.lineTo(size.width, nipOffset);
        } else {
          path2.lineTo(size.width - _nipPX, nipOffset + _nipPY);
          path2.arcToPoint(Offset(size.width - _nipCX, nipOffset),
              radius: Radius.circular(nipRadius), clockwise: false);
        }
        path2.close();

        path.addPath(path2, Offset(0, 0));
        path.addPath(path2, Offset(0, 0)); // Magic!
        break;

      case BubbleNip.rightBottom:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _startOffset, size.height, radius));

        path.moveTo(
            size.width - _startOffset - radiusX, size.height - nipOffset);
        path.lineTo(size.width - _startOffset - radiusX,
            size.height - nipOffset - nipHeight);
        path.lineTo(
            size.width - _startOffset, size.height - nipOffset - nipHeight);
        if (nipRadius == 0) {
          path.lineTo(size.width, size.height - nipOffset);
        } else {
          path.lineTo(size.width - _nipPX, size.height - nipOffset - _nipPY);
          path.arcToPoint(Offset(size.width - _nipCX, size.height - nipOffset),
              radius: Radius.circular(nipRadius));
        }
        path.close();
        break;

      case BubbleNip.no:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _endOffset, size.height, radius));
        break;
    }

    return path;
  }

  @override
  bool shouldReclip(BubbleClipper oldClipper) => false;
}

class Bubble extends StatelessWidget {
  Bubble({
    this.child,
    Radius radius,
    BubbleNip nip,
    double nipWidth,
    double nipHeight,
    double nipOffset,
    double nipRadius,
    bool stick,
    Color color,
    double elevation,
    Color shadowColor,
    BubbleEdges padding,
    BubbleEdges margin,
    Alignment alignment,
    BubbleStyle style,
  })  : color = color ?? style?.color ?? Colors.white,
        elevation = elevation ?? style?.elevation ?? 1.0,
        shadowColor = shadowColor ?? style?.shadowColor ?? Colors.black,
        margin = BubbleEdges.only(
          left: margin?.left ?? style?.margin?.left ?? 0.0,
          top: margin?.top ?? style?.margin?.top ?? 0.0,
          right: margin?.right ?? style?.margin?.right ?? 0.0,
          bottom: margin?.bottom ?? style?.margin?.bottom ?? 0.0,
        ),
        alignment = alignment ?? style?.alignment ?? null,
        bubbleClipper = BubbleClipper(
          radius: radius ?? style?.radius ?? Radius.circular(6.0),
          nip: nip ?? style?.nip ?? BubbleNip.no,
          nipWidth: nipWidth ?? style?.nipWidth ?? 8.0,
          nipHeight: nipHeight ?? style?.nipHeight ?? 10.0,
          nipOffset: nipOffset ?? style?.nipOffset ?? 0.0,
          nipRadius: nipRadius ?? style?.nipRadius ?? 1.0,
          stick: stick ?? style?.stick ?? false,
          padding: BubbleEdges.only(
            left: padding?.left ?? style?.padding?.left ?? 8.0,
            top: padding?.top ?? style?.padding?.top ?? 6.0,
            right: padding?.right ?? style?.padding?.right ?? 8.0,
            bottom: padding?.bottom ?? style?.padding?.bottom ?? 6.0,
          ),
        );

  final Widget child;
  final Color color;
  final double elevation;
  final Color shadowColor;
  final BubbleEdges margin;
  final Alignment alignment;
  final BubbleClipper bubbleClipper;

  Widget build(context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: alignment,
              margin: margin?.edgeInsets,
              child: PhysicalShape(
                clipBehavior: Clip.antiAlias,
                clipper: bubbleClipper,
                child:
                    Container(padding: bubbleClipper.edgeInsets, child: child),
                color: color,
                elevation: elevation,
                shadowColor: shadowColor,
              ))
        ]);
  }
}

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('hh:mm dd-MMM-yyyy');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}
