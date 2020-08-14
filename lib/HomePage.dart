import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/ProductDetailsPage.dart';
import 'package:SpotEasy/ProductsByCategoryPage.dart';
import 'package:SpotEasy/RentcityCategory.dart';
import 'package:SpotEasy/RentcityProducts.dart';
import 'package:SpotEasy/SelectCityPage.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:SpotEasy/listcategories.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rxbus/rxbus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboardresponse/Dashboardresp.dart';
import 'eventbus/UpdateCityName.dart';
import 'eventbus/RefreshHomeEvent.dart';
import 'loginresponse/LoginResp.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController _hideButtonController;
  int _current = 0;
  String CityID;
  String RegistrationID = "";
  String CityName = "Delhi";
  String userid;
  int mainBalance = 0;
  int point = 0;
  final searchedProductController = TextEditingController();
  final scaffoldState = GlobalKey<ScaffoldState>();
  Animation<double> locationAnimation;
  AnimationController locationAnimationController;

  List<String> _photoData = const [
    "https://5.imimg.com/data5/KU/BB/MY-57539226/ac-servicing-500x500.jpg",
    "https://images.financialexpress.com/2020/06/bike-service-at-home.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT_KG9inpXgBNA8i4E1ehuv362n2yQnOK2v8g&usqp=CAU",

  ];

  bool showProgress = true;
  bool _isVisible = true;
  bool categoriesProgress = true;
  Map<String, dynamic> categoriesResponse;
  RentcityCategory _rentcityCategory;
  List<Listcategories> categoryList;

  Future<List<Listcategories>> getCategories() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://api.rentcity.in/Service1.svc/GetAllRentcityCategory"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      categoriesResponse = json.decode(response.body);
      _rentcityCategory = new RentcityCategory.fromJsonMap(categoriesResponse);
      categoryList = _rentcityCategory.listcategories;
      print(categoryList.length);
      categoriesProgress = false;
    });

    return categoryList;
  }

  @override
  bool get wantKeepAlive => true;
  Map<String, dynamic> productsResponse;
  RentcityProducts _rentcityProducts;
  List<ListProducts> productList;

  Future<List<ListProducts>> getproducts() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://api.rentcity.in/Service1.svc/GetAllRentcityProducts?UserId=" +
                userid +
                "&CityID=" +
                CityID),
        headers: {"Accept": "application/json"});
    print("http://api.rentcity.in/Service1.svc/GetAllRentcityProducts?UserId=" +
        userid +
        "&CityID=" +
        CityID);
    this.setState(() {
      productsResponse = json.decode(response.body);
      _rentcityProducts = new RentcityProducts.fromJsonMap(productsResponse);
      productList = _rentcityProducts.listProducts;
      print(productList.length);
      showProgress = false;
    });

    return productList;
  }

  Future<LoginResp> updateUserRegistrationID() async {
    final response = await http.get(
        "http://api.rentcity.in/Service1.svc/UpdateUserRegistrationID?UserId=" +
            userid +
            "&RegistrationID=" +
            RegistrationID);
  }

  @override
  void initState() {
    // TODO: implement initState

    loadUserId();
    loadCityName();
    getCategories();

    registerBus();
    locationAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    locationAnimation = Tween<double>(begin: -100, end: 0)
        .chain(CurveTween(curve: Curves.easeInOutBack))
        .animate(locationAnimationController)
      ..addListener(() {
        setState(() {});
      });
    locationAnimationController.forward();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */
          print("**** ${_isVisible} up"); //Move IO away from setState
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */
            print("**** ${_isVisible} down"); //Move IO away from setState
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  void registerBus() {
    RxBus.register<RefreshHomeEvent>().listen((event) =>
        setState(() {
          loadCityID();
        }));
    RxBus.register<UpdateCityName>().listen((event) =>
        setState(() {
          loadCityName();
        }));
  }

  loadCityID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "CityID";
    CityID = prefs.getString(key) ?? "0";
    setState(() {
      showProgress = true;
    });
    getproducts();
  }

  loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "RegistrationID";
    RegistrationID = prefs.getString(key) ?? "0";
    updateUserRegistrationID();
  }

  loadCityName() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "CityName";

    setState(() {
      CityName = prefs.getString(key) ?? "0";
    });
    print(CityName);
  }

  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
    loadToken();
    loadCityID();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String versionName = packageInfo.version;
      print("versionName" + versionName);

      String versionCode = packageInfo.buildNumber;
      print("versionCode" + versionCode);
      DashBoardApi(userid, versionCode);
    });
  }

//TODO Dashboard Api Call
  Map<String, dynamic> dashboardJson;
  Dashboardresponse dashboardresponse;

  Future<Dashboardresponse> DashBoardApi(String UserId,
      String projectCode) async {
    var response = await http.get(
        Uri.encodeFull(
            "http://api.rentcity.in/Service1.svc/GetDashboard?UserId=" +
                userid +
                "&Version=" +
                projectCode),
        headers: {"Accept": "application/json"});


    dashboardJson = json.decode(response.body);

    dashboardresponse = new Dashboardresponse.fromJsonMap(dashboardJson);
    if (dashboardresponse.AppUpdateRequired == 1) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return new FunkyOverlay("");
        },
      );
    }

    this.setState(() {
      mainBalance = dashboardresponse.userWallet.ActualAmount;
      point = dashboardresponse.userWallet.RentcityPoints;
    });

    return dashboardresponse;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: scaffoldState,

        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ListView(
              controller: _hideButtonController,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(5),
                  child: new Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: CarouselSlider(
                          height: 160.0,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          reverse: false,
                          enableInfiniteScroll: true,
                          autoPlayInterval: Duration(seconds: 4),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          pauseAutoPlayOnTouch: Duration(seconds: 10),
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index) {
                            setState(() {
                              _current = index;
                            });
                          },
                          items: _photoData.map((imgUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: 350,
                                    height: 150,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Image(
                                        image: new CachedNetworkImageProvider(
                                            imgUrl),
                                        fit: BoxFit.fill));
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      Stack(
                        children: <Widget>[
                          new Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: new Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: new Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      "Featured Categories",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                categoriesProgress
                                    ? new Center(
                                    child: new CircularProgressIndicator(
                                        valueColor:
                                        new AlwaysStoppedAnimation<
                                            Color>(Colors.orange)))
                                    :
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                          height: 90.0,
                                          child: AnimationLimiter(
                                            child: ListView.builder(
                                              scrollDirection:
                                              Axis.horizontal,
                                              itemCount: categoryList ==
                                                  null
                                                  ? 0
                                                  : categoryList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                  int index) {
                                                return AnimationConfiguration
                                                    .staggeredList(
                                                  position: index,
                                                  duration:
                                                  const Duration(
                                                      milliseconds:
                                                      375),
                                                  child: SlideAnimation(
                                                    duration: Duration(
                                                        milliseconds:
                                                        800),
                                                    horizontalOffset:
                                                    50.0,
                                                    child:
                                                    FadeInAnimation(
                                                      child: SizedBox(
                                                        height: 70.0,
                                                        width: 140,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                context)
                                                                .push(
                                                                new MaterialPageRoute(
                                                                    builder: (
                                                                        BuildContext context) =>
                                                                    new ProductByCategoryPage(
                                                                        categoryList[index],
                                                                        categoryList)));
                                                          },
                                                          child: new Card(
                                                            color: const Color(0xff24293c),
                                                            elevation: 5,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: <
                                                                  Widget>[
                                                                new Text(
                                                                  categoryList[index]
                                                                      .CategoryName
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      12,

                                                                      color: Colors
                                                                          .white),
                                                                )
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
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      new Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: new Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: new Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  "Trending products",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            showProgress
                                ? new Center(
                                child: new CircularProgressIndicator(
                                    valueColor:
                                    new AlwaysStoppedAnimation<Color>(
                                        Colors.orange)))
                                :
                            new Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                      height: 400.0,
                                      child:
                                      AnimationLimiter(
                                        child: GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          scrollDirection:
                                          Axis.vertical,
                                          itemCount: productList == null
                                              ? 0
                                              : productList.length,
                                          itemBuilder:
                                              (BuildContext context,
                                              int index) {
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 375),
                                              child: SlideAnimation(
                                                duration: Duration(
                                                    milliseconds: 800),
                                                horizontalOffset: 20.0,
                                                child: FadeInAnimation(
                                                  child:
                                                  Card(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator
                                                            .push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                ProductDetails(
                                                                    productList[index]),
                                                          ), //MaterialPageRoute
                                                        );
                                                      },
                                                      child: Column(
                                                        children: <
                                                            Widget>[
                                                          Hero(
                                                            child:
                                                            Image(
                                                              image: new CachedNetworkImageProvider(
                                                                  "https://firebasestorage.googleapis.com/v0/b/spoteasy-214d2.appspot.com/o/" +
                                                                      productList[index]
                                                                          .ProductImage
                                                                          .toString() +
                                                                      "?alt=media&token=802896b3-3d04-47e1-a6c4-86ed88e491a2"),
                                                              height:
                                                              130,
                                                              width:
                                                              250,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            tag: productList[
                                                            index]
                                                                .AdID,
                                                          ),
                                                          Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  10),
                                                              child:
                                                              new Text(
                                                                productList[index]
                                                                    .ProductName
                                                                    .toString(),
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight
                                                                        .bold),
                                                              )),
                                                        ],
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


                          ],
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    locationAnimationController.dispose();
    super.dispose();
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
    locationAnimation = Tween<double>(begin: 200, end: 0)
        .chain(CurveTween(curve: Curves.easeInOutBack))
        .animate(locationAnimationController)
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
                  Text(
                    "App Update Required",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "We have added new features & fixed bugs to make yoyr experience as smooth as possible",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: new MaterialButton(
                      minWidth: 200,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20),
                          side: BorderSide(color: Colors.orange)),
                      color: Colors.orange,
                      textColor: Colors.white,
                      child: new Text(
                        "Update Now",
                        style: TextStyle(fontSize: 18),
                      ),
                      splashColor: Colors.orange,
                      onPressed: () {
                        OpenAppstore.launch(
                            androidAppId: "com.divya.voicepush&hl=ko",
                            iOSAppId: "284882215");
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
