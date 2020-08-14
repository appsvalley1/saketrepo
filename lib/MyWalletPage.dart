import 'dart:async';
import 'dart:convert';

import 'package:SpotEasy/WalletResp.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'earned_points_history.dart';
import 'main_balance_history.dart';

class MyWalletPage extends StatefulWidget {
  @override
  State createState() => new AddProductState();
}

class AddProductState extends State<MyWalletPage>
    with TickerProviderStateMixin {
  String userid;
  bool showProgress = true;

  //TODO For Main balance
  Animation mainBalanceanimation;
  AnimationController mainBalanceanimationController;
  int mainBalance = 0;

  //TODO For Rentcity Points
  Animation pointsanimation;
  AnimationController pointsanimationController;
  int point = 0;
int bankDetailsStatus=0;
  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
    setState(() {
      showProgress=true;
    });
    getWalletDetails(userid);

  }

  loadbankDetailsStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "bankDetailsStatus";
    bankDetailsStatus = prefs.getInt(key) ?? 0;
  }
  Map<String, dynamic> walletJson;
  WalletResp walletResp;
  List<EarnedPointsHistory> earnedPointsHistory;
  List<MainBalanceHistory> mainBalanceHistory;
  Future<WalletResp> getWalletDetails(String UserId) async {
    var response = await http.get(
        Uri.encodeFull(
            "http://api.rentcity.in/Service1.svc/GetUserRentcityWallet?UserId="+userid),
        headers: {"Accept": "application/json"});
    print(response.body);
    walletJson = json.decode(response.body);
    this.setState(() {
      mainBalanceanimationController.reset();
      walletResp = new WalletResp.fromJsonMap(walletJson);
      earnedPointsHistory=walletResp.earnedPointsHistory;
      mainBalanceHistory=walletResp.mainBalanceHistory;
      point=walletResp.RentcityPoints;
      mainBalance=walletResp.ActualAmount;
      showProgress = false;
      mainBalanceanimation = IntTween(begin: 0, end: mainBalance).animate(
          CurvedAnimation(
              parent: mainBalanceanimationController,
              curve: Curves.easeInToLinear)) ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          print("completed");
        } else if (state == AnimationStatus.dismissed) {
          print("dismissed");
        }
      })
        ..addListener(() {

          print(" mainBalance value:${mainBalanceanimation.value}");
          print("mainBalance:${mainBalance}");

          setState(() {});
        });
      mainBalanceanimationController.forward();
    });

    pointsanimation = IntTween(begin: 0, end: point).animate(CurvedAnimation(
        parent: pointsanimationController, curve: Curves.easeInToLinear))

      ..addListener(() {

        print("points value:${pointsanimation.value}");
        print("points:${point}");

        setState(() {});
      });
    pointsanimationController.forward( from: 0);

    return walletResp;
  }

  @override
  void initState() {
    super.initState();
    mainBalanceanimationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    //TODO For Rentcity Points
    pointsanimationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    loadUserId();
    loadbankDetailsStatus();
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
          backgroundColor: Colors.orange,
          brightness: Brightness.dark,
          title: new Text("My Wallet"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),

          ],
        ),
        backgroundColor: Colors.white,
        body: Stack(
         children: <Widget>[


           ListView(
           children: <Widget>[
             Container(
               margin: EdgeInsets.symmetric(
                 vertical: 30.0,
               ),
               child: PageView(
                 controller:
                 PageController(initialPage: 0, viewportFraction: 0.89),
                 children: [Hero(
                     child: Container(
                       margin: EdgeInsets.symmetric(
                         horizontal: 10.0,
                       ),
                       child: Card(
                         color: Colors.deepPurple,
                         shape: RoundedRectangleBorder(
                           side: BorderSide(
                               color: Colors.indigo, width: 1),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         elevation: 10,
                         child: Column(
                           mainAxisSize: MainAxisSize.max,
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             Row(
                               children: <Widget>[
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                   child: Icon(
                                     FontAwesomeIcons.gem,
                                     size: 35,
                                     color: Colors.orange,
                                   ),
                                 ),
                                 walletJson!=null?  new AnimatedBuilder(
                                   animation: pointsanimation,
                                   builder: (BuildContext context, Widget child) {
                                     return new Text(
                                       pointsanimation.value.toStringAsFixed(1),
                                       style: TextStyle(
                                           fontSize: 50, color: Colors.white),
                                     );
                                   },
                                 ):Container()
                               ],
                               mainAxisSize: MainAxisSize.max,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.center,
                             ),
                             Text("RentCity Points",
                                 style:
                                 TextStyle(fontSize: 25, color: Colors.white)),
                             Align(
                               alignment: Alignment.center,
                               child: Padding(
                                 padding: const EdgeInsets.only(
                                     top: 10, left: 10, bottom: 10),
                                 child:
                                 Card(
                                   shape: RoundedRectangleBorder(
                                       borderRadius: new BorderRadius.circular(20),
                                       side: BorderSide(color: Colors.orange)),
                                   elevation: 10,
                                   child: new MaterialButton(
                                     minWidth: 100,
                                     height: 50,
                                     shape: RoundedRectangleBorder(
                                         borderRadius:
                                         new BorderRadius.circular(20),
                                         side: BorderSide(color: Colors.orange)),
                                     color: Colors.orange,
                                     textColor: Colors.white,
                                     child: new Text("Transfer to Account"),
                                     splashColor: Colors.amberAccent,
                                     onPressed: () {
                                       // Validate returns true if the form is valid, otherwise false.
                                     },
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                     ),
                     tag: "RENTCITYPOINTS"
                 ),
                   Hero(
                     child: Container(
                       margin: EdgeInsets.symmetric(
                         horizontal: 10.0,
                       ),
                       child: Card(
                           child: Column(
                             mainAxisSize: MainAxisSize.max,
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                               Row(
                                 children: <Widget>[
                                   Text("\u20B9" + " ",
                                       style: TextStyle(
                                           fontSize: 50, color: Colors.orange)),


                                   walletJson!=null? new AnimatedBuilder(
                                     animation: mainBalanceanimation,
                                     builder:
                                         (BuildContext context, Widget child) {
                                       return new Text(
                                         mainBalanceanimation.value
                                             .toStringAsFixed(1),
                                         style: TextStyle(
                                             fontSize: 50, color: Colors.white),
                                       );
                                     },
                                   ):Container()
                                 ],
                                 mainAxisSize: MainAxisSize.max,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 mainAxisAlignment: MainAxisAlignment.center,
                               ),
                               Text("Main Balance ",
                                   style: TextStyle(
                                       fontSize: 25, color: Colors.white)),
                               Align(
                                 alignment: Alignment.center,
                                 child: Padding(
                                   padding: const EdgeInsets.only(
                                       top: 10, left: 10, bottom: 10),
                                   child: Card(

                                     shape: RoundedRectangleBorder(

                                         borderRadius:
                                         new BorderRadius.circular(20),

                                         side: BorderSide(color: Colors.orange)),
                                     elevation: 10,
                                     child:
                                     new MaterialButton(
                                       minWidth: 70,
                                       height: 50,
                                       shape: RoundedRectangleBorder(
                                           borderRadius:
                                           new BorderRadius.circular(20),
                                           side: BorderSide(
                                               color: Colors.lightBlue)),
                                       color: Colors.orange,
                                       textColor: Colors.white,
                                       child: new Text("Transfer to Account"),
                                       splashColor: Colors.amberAccent,
                                       onPressed: () {
                                         if(bankDetailsStatus==0)
                                           {
                                             Navigator.pushNamed(context, "/AddBankDetailsPage");
                                           }
                                         else
                                           {

                                           }

                                       },
                                     ),
                                   ),
                                 ),
                               )
                             ],
                           ),
                           color: const Color(0xff292a3c),
                           shape: RoundedRectangleBorder(
                               side: BorderSide(
                                   color: const Color(0xff5a53cd), width: 1),
                               borderRadius: BorderRadius.circular(10)),
                           elevation: 10),
                     ),
                       tag: "MAINBALANCE"
                   ),

                 ],
               ),
               height: 200,
             ),
             DefaultTabController(
               length: 2,
               child: SizedBox(
                 height: 400.0,
                 child: Container(
                   color: const Color(0xff292a3c),
                   child: Column(
                     children: <Widget>[
                       TabBar(
                         labelColor: Colors.white,
                         labelStyle: TextStyle(fontSize: 18),
                         tabs: <Widget>[
                           Tab(
                             text: "Points History",
                           ),
                           Tab(
                             text: "Earning History",
                           ),

                         ],
                       ),
                       Expanded(
                         child: TabBarView(
                           children: <Widget>[
                             Container(
                               color: Colors.white,
                               child:
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: (earnedPointsHistory == null || earnedPointsHistory.length == 0)
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
                                             child: Text("Your wallet is empty",
                                                 style: TextStyle(
                                                     fontSize: 20,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.black)),
                                           ),
                                           Text(
                                               "Looks like you haven't earned RentCity points",
                                               style: TextStyle(
                                                   fontSize: 14,
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black45)),
                                         ],
                                       ),
                                     )
                                   ],
                                 )
                                     : ListView.builder(
                                   scrollDirection: Axis.vertical,
                                   itemCount: earnedPointsHistory == null ? 0 : earnedPointsHistory.length,
                                   itemBuilder: (BuildContext context, int index) {
                                     return Container(
                                       constraints: BoxConstraints(minWidth: 400.0),
                                       alignment: Alignment.topLeft,
                                       margin: const EdgeInsets.only(
                                           top: 0.0, bottom: 0, right: 5, left: 5),
                                       child: Card(
                                           elevation: 10,
                                           child: Padding(
                                             padding: const EdgeInsets.all(10),
                                             child: Column(
                                               children: <Widget>[
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: <Widget>[
                                                     Text(earnedPointsHistory[index].WalletTransactionsDate),Text(earnedPointsHistory[index].WalletTransactionsEarnedFrom),Text(earnedPointsHistory[index].WalletTransactionsAmount.toString())
                                                   ],
                                                 ),


                                               ],
                                             ),
                                           )),
                                     );
                                   },
                                 ),
                               ),
                             ),
                             Container(
                               color: Colors.white,
                               child:
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: (mainBalanceHistory == null || mainBalanceHistory.length == 0)
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
                                             child: Text("Your Wallet is Empty",
                                                 style: TextStyle(
                                                     fontSize: 20,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.black)),
                                           ),
                                           Text(
                                               "Looks like you haven't earned till now",
                                               style: TextStyle(
                                                   fontSize: 14,
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black45)),
                                         ],
                                       ),
                                     )
                                   ],
                                 )
                                     : ListView.builder(
                                   scrollDirection: Axis.vertical,
                                   itemCount: mainBalanceHistory == null ? 0 : mainBalanceHistory.length,
                                   itemBuilder: (BuildContext context, int index) {
                                     return Container(
                                       constraints: BoxConstraints(minWidth: 400.0),
                                       alignment: Alignment.topLeft,
                                       margin: const EdgeInsets.only(
                                           top: 0.0, bottom: 0, right: 5, left: 5),
                                       child: Card(
                                           elevation: 10,
                                           child: Padding(
                                             padding: const EdgeInsets.all(10),
                                             child: Column(
                                               children: <Widget>[
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: <Widget>[
                                                     Text(mainBalanceHistory[index].WalletTransactionsDate),Text(mainBalanceHistory[index].WalletTransactionsEarnedFrom),Text("\u20B9" +mainBalanceHistory[index].WalletTransactionsAmount.toString())
                                                   ],
                                                 ),


                                               ],
                                             ),
                                           )),
                                     );
                                   },
                                 ),
                               ),
                             ),

                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             )
           ],
         ),  showProgress
               ? new Center(

               child:
               new CircularProgressIndicator(
                   valueColor:
                   new AlwaysStoppedAnimation<Color>(Colors.orange)))
               :Container()],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
