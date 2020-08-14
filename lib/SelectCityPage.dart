import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/MainPageTwo.dart';
import 'package:SpotEasy/Sdsd.dart';
import 'package:SpotEasy/HomePage.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/eventbus/RefreshHomeEvent.dart';
import 'package:SpotEasy/eventbus/UpdateCityName.dart';
import 'package:SpotEasy/list_city.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import 'package:rxbus/rxbus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CitiesList extends StatefulWidget {
  bool isRegistration;
  CitiesList(this.isRegistration);
  @override
  State createState() => new CitiesListState(isRegistration);
}

class CitiesListState extends State<CitiesList> {

  bool isRegistration;
  Map<String, dynamic> data;
  Sdsd sdsd;
  List<ListCity> citiesList=new List();
  bool showProgress = true;
  CitiesListState(this.isRegistration);


  Future<List<ListCity>> loadcities() async {
    var response = await http.get(
        Uri.encodeFull("http://api.rentcity.in/Service1.svc/GetCity"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      data = json.decode(response.body);
      sdsd = new Sdsd.fromJsonMap(data);
      citiesList = sdsd.listCity;
      print(citiesList.length);
      showProgress = false;
      //  var streetsFromJson = extractdata['listCity'];
      // data= new List<ListCity>.from(streetsFromJson);
    });

    return citiesList;
  }
  saveCityID(String dataKey,String dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setString(key, value);
    print('saved $value');
  }
  saveCityName(String dataKey,String dataValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = dataKey;
    final value = dataValue;
    prefs.setString(key, value);
    print('saved $value');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadcities();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Select City"),
        actions: <Widget>[],
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),

        brightness: Brightness.dark,
        backgroundColor: const Color(0xff24293c),
      ),
      body: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showProgress
              ? new Center(
                  child: new CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.orange)))
              : Expanded(
                  child:AnimationLimiter(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      scrollDirection: Axis.vertical,
                      itemCount: data == null ? 0 : citiesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            duration: Duration(milliseconds: 800),
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child:

                              new Container(
                                margin: const EdgeInsets.only(
                                    top: 5.0, bottom: 5, right: 5, left: 5),
                                child: SizedBox(
                                    height: 170.0,
                                    width: 160,
                                    child:  Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      elevation: 10,
                                      child: InkWell(
                                        onTap: () {
                                          saveCityID("CityID",citiesList[index].CityID.toString());
                                          saveCityName("CityName", citiesList[index].CityName);
                                          if(isRegistration)
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MainPageTwo()));
                                          }
                                          else
                                          {
                                            RxBus.post(RefreshHomeEvent());
                                            RxBus.post(UpdateCityName());
                                            Navigator.pop(context);
                                          }

                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Image(
                                                width: 160,
                                                height: 140,
                                                image: new CachedNetworkImageProvider(
                                                    citiesList[index].CityImage),
                                                fit: BoxFit.cover),
                                            Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: new Text(
                                                  citiesList[index].CityName.toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )),

        ],
      ),
    );
  }
}
