import 'dart:async';
import 'dart:convert';

import 'package:SpotEasy/ContactSuportOrders.dart';
import 'package:SpotEasy/chatsresponse/list_chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/registerresponse/RegisterResponse.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:SpotEasy/Response/MyOrders/list_orders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SpotEasy/Response/MyOrders/MyOrdersResponse.dart';

import 'ChatScreenPage.dart';
import 'Notifications.dart';
import 'chatsresponse/ChatsResponse.dart';

class MyChatsPage extends StatefulWidget {
  @override
  State createState() => new MyChatsPageState();
}

class MyChatsPageState extends State<MyChatsPage>
    with AutomaticKeepAliveClientMixin {
  bool showProgress = true;
  bool showCustomercare = false;
  String userid;
  final db = Firestore.instance;
  Map<String, dynamic> myChatsResponse;
  ChatsResponse chats;
  List<ListChats> chatsList;



  Future<List<ListChats>> getMyChats() async {
    var response = await http.get(Uri.encodeFull(
        "http://api.rentcity.in/Service1.svc/getMyChats?Userid=" + userid));

    print("http://api.rentcity.in/Service1.svc/getMyChats?Userid=" + userid);
    myChatsResponse = json.decode(response.body);
    chats = new ChatsResponse.fromJsonMap(myChatsResponse);
    chatsList = chats.listChats;
    showProgress = false;
    if (mounted) {
     setState(() {

     });
    }

    return chatsList;
  }


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadUserId();
  }

  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
    getMyChats();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.orange,
          brightness: Brightness.dark,
          title: new Text("My Chats"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),

          ],
        ),
        body: Stack(
      children: <Widget>[
        SafeArea(
          child: (chatsList == null || chatsList.length == 0)
              ? (!showProgress)
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                            Icon(Icons.chat,size: 100,color: Colors.red,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No Chats, Yet",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),

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
                              height: MediaQuery.of(context).size.height - 150,
                              child:
                                  (chatsList == null || chatsList.length == 0)
                                      ? Text("No Orders Found")
                                      :
                                  AnimationLimiter(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: chatsList == null
                                          ? 0
                                          : chatsList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            duration: Duration(milliseconds: 800),
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child:

                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: 400.0),
                                                alignment: Alignment.centerLeft,
                                                margin: const EdgeInsets.only(
                                                    top: 0.0,
                                                    bottom: 0,
                                                    right: 5,
                                                    left: 5),
                                                child: Card(
                                                    elevation: 10,
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                        child:Row(

                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Image(
                                                                image: new CachedNetworkImageProvider("https://firebasestorage.googleapis.com/v0/b/rentcityfinal.appspot.com/o/" +
                                                                    chatsList[index].product.ProductImage.toString() +
                                                                    "?alt=media&token=ea32d5b2-d29f-452d-93c9-f7092ca88794"),
                                                                height:
                                                                70,
                                                                width:
                                                                60,
                                                              ),flex: 1,
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(15),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                 new StreamBuilder(
                                                                stream: Firestore.instance.collection(chatsList[index].CollectionID.toString()).snapshots(),
                                                                  builder: (context, snapshot) {
                                                                    if (!snapshot.hasData) {
                                                                      return new Text("Loading...");
                                                                    }
                                                                    QuerySnapshot document  = snapshot.data;
                                                                    List<DocumentSnapshot> templist;
                                                                    templist = document.documents;
                                                                    if(templist.length!=0)
                                                                      {
                                                                        return  new Text(templist[templist.length-1]["Content"].toString()==""?"Send Image":templist[templist.length-1]["Content"].toString(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold
                                                                        ));
                                                                      }
                                                                    else
                                                                      {

                                                                        return Container();
                                                                      }

                                                                  }
                                                              ),
                                                                    Text(chatsList[index].product.ProductName,overflow: TextOverflow.ellipsis,
                                                                      maxLines: 2,
                                                                      softWrap: true),
                                                                    Text(chatsList[index].SenderID.toInt()==int.parse(userid)?"Sent By You":"Sent By User"+chatsList[index].RecieverID.toString())
                                                                  ],
                                                                ),
                                                              )
                                                                ,flex: 4
                                                            ),
                                                  Icon(Icons.arrow_forward_ios,color: Colors.grey,)
                                                          ],
                                                        ),
                                                      ),onTap: (){
print(chatsList[index].CollectionID);
                                                      Navigator.of(context).push(new MaterialPageRoute(
                                                          builder: (BuildContext context) => new CHatScreenPage(chatsList[index].product,chatsList[index].CollectionID.toString())));

                                                    },
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
