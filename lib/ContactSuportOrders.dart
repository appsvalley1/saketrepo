import 'package:SpotEasy/Response/MyOrders/list_orders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/Notifications.dart';
import 'package:SpotEasy/ShippingAddressPage.dart';
import 'package:SpotEasy/list_products.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ContactSuportOrders extends StatefulWidget {
  ListOrders orders;
  ContactSuportOrders(this.orders);
  @override
  State createState() => new ContactSuportOrdersState(orders);
}

class ContactSuportOrdersState extends State<ContactSuportOrders>  with TickerProviderStateMixin{
  Animation<double> emailAnimation;
  AnimationController emailAnimationController;
  ListOrders orders;
  ContactSuportOrdersState(this.orders);
  Animation<double> whatsAppAnimation;
  AnimationController whatsAppAnimationController;
  List<String> status = new List();
  String userid;

  loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "userid";
    userid = prefs.getString(key) ?? "0";
  setState(() {

  });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserId();
    status.add("Pending For Approval");
    status.add("Approved");
    status.add("Order Delivered");
    status.add("Order Completed");
    status.add("Order Completed(Deposit Refunded)");

    emailAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1),);


    emailAnimation = Tween<double>(begin: 100, end: 0)
        .chain(CurveTween(curve: Interval(0.3, .7, curve: Curves.fastOutSlowIn)))
        .animate(emailAnimationController)
      ..addListener(() {
        setState(() {});
      });
    emailAnimationController.forward();



    whatsAppAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1),);


    whatsAppAnimation = Tween<double>(begin: 100, end: 0)
        .chain(CurveTween(curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)))
        .animate(whatsAppAnimationController)
      ..addListener(() {
        setState(() {});
      });
    whatsAppAnimationController.forward();
  }
  void openEmail() async {
    final Email email = Email(
body: "Support Ticket For "+orders.OrderID.toString()+"of status "+status[orders.OrderStatus-1]+" User ID"+userid,
      subject: 'Order Related Query ',
      recipients: ['services@rentcity.in'],
      isHTML: false,
    );

   await FlutterEmailSender.send(email);
  }
  @override
  void dispose() {
    emailAnimationController.dispose();
    whatsAppAnimationController.dispose();
    super.dispose();
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
        backgroundColor:const Color(0xff24293c),
        brightness: Brightness.dark,
        title: new Text("SPOT Support"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),

        ],
      ),
      body: ListView(
        children: <Widget>[
          Image(
            image: AssetImage('assets/contactbg.png'),
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: 260,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Transform.translate(
                  child: Card(
                    child: InkWell(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff11acfc),
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(40.0),
                                      topRight: const Radius.circular(40.0),
                                      bottomLeft: const Radius.circular(40.0),
                                      bottomRight: const Radius.circular(40.0)),
                                ),
                                height: 60,
                                width: 60,
                                child:  Icon(Icons.mail, color: Colors.lightBlueAccent,size: 30,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Email Us",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                      ),onTap: (){

                      openEmail();
                    },
                    ),
                  ),
                  offset:  Offset(0, emailAnimation.value),
                ),
                Transform.translate(
                  child:

                  Card(
                    child: InkWell(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff22d378),
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(40.0),
                                      topRight: const Radius.circular(40.0),
                                      bottomLeft: const Radius.circular(40.0),
                                      bottomRight: const Radius.circular(40.0)),
                                ),
                                height: 60,
                                width: 60,
                                child:  Icon(Icons.whatshot, color: Colors.greenAccent,size: 30,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Whatsapp Us ",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                      ),
                      onTap: (){
                        FlutterOpenWhatsapp.sendSingleMessage("+91 9828222427", "Support Ticket For "+orders.OrderID.toString()+" of status "+status[orders.OrderStatus-1]+" User ID"+userid);

                      },
                    ),
                  ),
                  offset:  Offset(0, whatsAppAnimation.value),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}