import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/ShippingAddressPage.dart';
import 'package:SpotEasy/list_products.dart';

class CartDetails extends StatefulWidget {
  ListProducts _products;
  int tenure;

  CartDetails(this._products, this.tenure);

  @override
  State createState() => new CartDetailsState(_products, tenure);
}

class CartDetailsState extends State<CartDetails> with TickerProviderStateMixin {
  ListProducts _products;
  int totalAmount,adminCharges,totalRent;
  int tenure;
  AnimationController buttonController;
  Animation<double> buttonAnimation;
  CartDetailsState(this._products, this.tenure);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    adminCharges=(((_products.ProductRent*tenure )+ _products.ProductSecurity)*20/100).toInt();
    totalRent=(_products.ProductRent*tenure ).toInt();
    totalAmount = (_products.ProductRent*tenure )+ _products.ProductSecurity+adminCharges+200;
    buttonController = AnimationController(duration: const Duration(milliseconds: 2500), vsync: this, value: 0.1);
    buttonAnimation = CurvedAnimation(parent: buttonController, curve: Curves.bounceInOut);
    buttonController.forward();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    buttonController.dispose();
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
        title: new Text("Cart"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),

        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("Payment Details"),
                          ),
                          alignment: Alignment.bottomLeft),
                      Spacer(),
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("Tenure: "+tenure.toString()+" Months",style: TextStyle(fontWeight:FontWeight.bold),),
                          ),
                          alignment: Alignment.bottomLeft)
                    ],
                  ),

                  new Divider(color: Colors.grey[400]),
                  Row(
                    children: <Widget>[
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("Total  Rent"),
                          ),
                          alignment: Alignment.bottomLeft),
                      Spacer(),
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text(totalRent.toString()),
                          ),
                          alignment: Alignment.bottomLeft)
                    ],
                  ),
                  new Divider(color: Colors.grey[400]),

                  Row(
                    children: <Widget>[
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("Refundable Deposit"),
                          ),
                          alignment: Alignment.bottomLeft),
                      Spacer(),
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("\u20B9" +_products.ProductSecurity.toString()),
                          ),
                          alignment: Alignment.bottomLeft)
                    ],
                  ),

                  new Divider(color: Colors.grey[400]),


                  Row(
                    children: <Widget>[
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("Admin charges"),
                          ),
                          alignment: Alignment.bottomLeft),
                      Spacer(),
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("\u20B9" +adminCharges.toString()),
                          ),
                          alignment: Alignment.bottomLeft)
                    ],
                  ),


                  new Divider(color: Colors.grey[400]),

                  Row(
                    children: <Widget>[
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("Delivery and Pickup"),
                          ),
                          alignment: Alignment.bottomLeft),
                      Spacer(),
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("\u20B9" +"200"),
                          ),
                          alignment: Alignment.bottomLeft)
                    ],
                  ),
                  new Divider(color: Colors.grey[400]),
                  Row(
                    children: <Widget>[
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("You pay"),
                          ),
                          alignment: Alignment.bottomLeft),
                      Spacer(),
                      Align(
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text("\u20B9" +totalAmount.toString()),
                          ),
                          alignment: Alignment.bottomLeft)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ScaleTransition(
                      scale: buttonAnimation,
                      child: new MaterialButton(
                        minWidth: 300,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20),
                            side: BorderSide(color: Colors.orange)),
                        color: Colors.orange,
                        textColor: Colors.white,
                        child: new Text("Enter Address"),
                        splashColor: Colors.amberAccent,
                        onPressed: () {


                          Navigator.of(context).pushReplacement(new MaterialPageRoute(
                              builder: (BuildContext context) => new ShippingAddressDetails()));
                          // Validate returns true if the form is valid, otherwise false.
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
