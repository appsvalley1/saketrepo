import 'dart:async';
import 'dart:convert';
import 'package:SpotEasy/RentcityCategory.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/ProductByCategories.dart';
import 'package:http/http.dart' as http;
import 'package:SpotEasy/listcategories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SpotEasy/RentcityProducts.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:SpotEasy/ProductDetailsPage.dart';

class SearchProductPage extends StatefulWidget {
  SearchProductPage({Key key}) : super(key: key);

  @override
  _SearchByProductPagetate createState() => new _SearchByProductPagetate();
}

class _SearchByProductPagetate extends State<SearchProductPage> {
  static const JsonCodec JSON = const JsonCodec();

  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQueryController =
      new TextEditingController();
  final FocusNode _focusNode = new FocusNode();
  bool showProgress = true;
  bool _isSearching = true;
  String _searchText = "";

  bool _onTap = false;
  int _onTapTextLength = 0;
  String CityID;
  String userid;

  Map<String, dynamic> productsResponse;
  RentcityProducts _rentcityProducts;
  List<ListProducts> productList;

  _SearchByProductPagetate() {
    _searchQueryController.addListener(() {
      if (_searchQueryController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
          productList = List();
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQueryController.text;
          _onTap = _onTapTextLength == _searchText.length;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    loadUserId();
  }

  loadCityID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "CityID";
    CityID = prefs.getString(key) ?? "0";
    this.setState(() {
      showProgress = true;
    });
  }

  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
    loadCityID();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color(0xff24293c),
        brightness: Brightness.dark,
        title:  new TextFormField(
          style: TextStyle(color: Colors.white,),
          controller: _searchQueryController,
          focusNode: _focusNode,
          onFieldSubmitted: (String value) {
            print("$value submitted");
            setState(() {
              _searchQueryController.text = value;
              _onTap = true;
            });
          },
          onSaved: (String value) => print("$value saved"),

          decoration: const InputDecoration(

            border: const UnderlineInputBorder(),
            filled: true,
            hintStyle:   TextStyle(fontSize: 18.0, color: Colors.white),
            hintText: 'Type to search products',
          ),
        ),
        actions: <Widget>[

        ],
      ),
      backgroundColor: Colors.white,
      body: buildBody(context),
    );
  }

  Widget getFutureWidget() {
    return new FutureBuilder(
        future: _buildSearchList(),
        initialData: List<Container>(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Container>> childItems) {
          return new Column(children: <Widget>[
            Container(

              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                    child: Text("Matching Services",
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 22)),alignment: Alignment.topLeft,)
              ),
            ),
            Container(
              color: Colors.white,
              height: 500,
              width: MediaQuery.of(context).size.width + 200,
              child: new ListView(
//            padding: new EdgeInsets.only(left: 50.0),
                children: childItems.data != null && childItems.data.isNotEmpty
                    ? ListTile.divideTiles(
                            context: context, tiles: getChildren(childItems))
                        .toList()
                    : List(),
              ),
            )
          ]);
        });
  }

  List<Container> getChildren(AsyncSnapshot<List<Container>> childItems) {
    if (_onTap && _searchText.length != _onTapTextLength) _onTap = false;
    List<Container> childrenList =
        _isSearching && !_onTap ? childItems.data : List();
    return childrenList;
  }

  Container _getListTile(ListProducts product) {
    return Container(
        child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(product),
          ), //MaterialPageRoute
        );
      },
      child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      child: Image(
                        image: new CachedNetworkImageProvider(
                            "https://firebasestorage.googleapis.com/v0/b/spoteasy-214d2.appspot.com/o/" +
                                product.ProductImage.toString() +
                                "?alt=media&token=802896b3-3d04-47e1-a6c4-86ed88e491a2"),
                        fit: BoxFit.fill,
                      ),
                      width: 80,
                      height: 70,
                    ),
                    Expanded(
                      child: Wrap(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Text(product.ProductName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                Text(product.Description,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis)
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    ));
  }

  Future<List<Container>> _buildSearchList() async {
    if (_searchText.isEmpty) {
      productList = List();
      return List();
    } else {
      productList = await _getSuggestion(_searchText) ?? List();
//        ..add(_searchText);

      List<Container> childItems = new List();
      for (var value in productList) {
        childItems.add(_getListTile(value));
      }
      return childItems;
    }
  }

  Future<List<ListProducts>> _getSuggestion(String hintText) async {
    var response = await http.get(
        Uri.encodeFull(
            "http://api.rentcity.in/Service1.svc/GetAllRentcityProductsBySearch?ProductName=" +
                hintText +
                "&UserId=" +
                userid +
                "&CityID=" +
                CityID),
        headers: {"Accept": "application/json"});

    this.setState(() {
      productsResponse = json.decode(response.body);
      _rentcityProducts = new RentcityProducts.fromJsonMap(productsResponse);
      productList = _rentcityProducts.listProducts;
      print(productList.length);
      showProgress = false;
    });

    return productList;
  }

  Widget buildBody(BuildContext context) {
    return new SafeArea(
      top: false,
      bottom: false,
      child: new SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                Container(

                  height: MediaQuery.of(context).size.height + 100,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Container(


                      ),
                      new Container(
                          width: 800,
                          alignment: Alignment.topLeft,
                          padding: new EdgeInsets.only(
//                  top: MediaQuery.of(context).size.height * .18,

                            right: 0.0,
                          ),
                          child: _isSearching && (!_onTap)
                              ? getFutureWidget()
                              : null)
                    ],
                  ),
                ),
              ],
              mainAxisSize: MainAxisSize.max,
            ),
          ],
        ),
      ),
    );
  }
}
