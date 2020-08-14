import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class FAQPage extends StatefulWidget {
  @override
  State createState() => new FAQPageState();
}

class FAQPageState extends State<FAQPage> with TickerProviderStateMixin {
  Animation<double> emailAnimation;
  AnimationController emailAnimationController;
  void initState() {
    // TODO: implement initState
    super.initState();
    emailAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1),);


    emailAnimation = Tween<double>(begin: 100, end: 0)
        .chain(CurveTween(curve: Interval(0.3, .7, curve: Curves.fastOutSlowIn)))
        .animate(emailAnimationController)
      ..addListener(() {
        setState(() {});
      });
    emailAnimationController.forward();



  }
  @override
  void dispose() {
    emailAnimationController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color(0xff24293c),
          brightness: Brightness.dark,
          title: new Text("Frequently Asked Questions"),
          actions: <Widget>[


          ],
        ),
        backgroundColor: Colors.white,
        body:  Transform.translate(
          child: ListView(

            children: <Widget>[
              Image(
                image: AssetImage('assets/faqbg.jpg'),
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: 260,
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child:Column(

                    children: <Widget>[  ExpandablePanel(

                      header: Text("What is Spot-Easy?",style: TextStyle(fontSize: 20),),
                      collapsed: Text("", softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,),
                      expanded: Text("Spot-Easy is the service provider for  all your service needs", softWrap: true,),
                      tapHeaderToExpand: true,
                      hasIcon: true,
                    )
                      ,


                    ],
                  )

              )
            ],
          ),
          offset:  Offset(0, emailAnimation.value),
        ),




        );


  }


}
