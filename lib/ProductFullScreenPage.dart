import 'package:SpotEasy/ChatScreenPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/CartDetailsPage.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/UpdateKYCProductPage.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProductFullScreenPage extends StatefulWidget {
  String productUrl;

  ProductFullScreenPage(this.productUrl);

  @override
  State createState() => new ProductFullScreenPagetate(productUrl);
}

class ProductFullScreenPagetate extends State<ProductFullScreenPage> {
  String productUrl;

  ProductFullScreenPagetate(this.productUrl);


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
        title: new Text("Product Image"),
        actions: <Widget>[


        ],
      ),
      body: Container(

    decoration: BoxDecoration(
      color: Colors.black,
    image: DecorationImage(
        image:  new CachedNetworkImageProvider(
            "https://firebasestorage.googleapis.com/v0/b/rentcityfinal.appspot.com/o/" +
                productUrl +
                "?alt=media&token=ea32d5b2-d29f-452d-93c9-f7092ca88794"),
    fit: BoxFit.fitWidth
    ) ,
    ),
    )
    );
  }
}
