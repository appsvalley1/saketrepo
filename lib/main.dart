import 'package:SpotEasy/IntroPage.dart';
import 'package:flutter/material.dart';
import 'package:SpotEasy/AddProductPage.dart';
import 'package:SpotEasy/LoginSelector.dart';
import 'package:SpotEasy/MyProductsPage.dart';
import 'package:SpotEasy/LoginPage.dart';
import 'package:SpotEasy/MainPageTwo.dart';
import 'package:SpotEasy/HomePage.dart';
import 'package:SpotEasy/Privacy.dart';
import 'package:SpotEasy/RegisterPage.dart';
import 'package:SpotEasy/MyWalletPage.dart';
import 'package:SpotEasy/ForgotPasswordPage.dart';
import 'package:SpotEasy/ChangePassowrdPage.dart';
import 'package:SpotEasy/SearchProductPage.dart';
import 'package:SpotEasy/UpdateKYCPage.dart';
import 'package:SpotEasy/ContactSuport.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'AddBankDetailsPage.dart';
import 'ChatScreenPage.dart';
import 'FAQPage.dart';
import 'InvitePage.dart';
import 'MyChatsPage.dart';
import 'ServiceOrdersPage.dart';
import 'ViewCart.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new MaterialApp(

      debugShowCheckedModeBanner: false,
        home: new LoginSelector(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        routes: <String, WidgetBuilder>{
              '/home': (_) => new HomePage(),
          '/login': (_) => new LoginPage(),
          '/addproduct': (_) => new AddProductPage(),
          '/mainactivity': (_) => new MainPageTwo(),
          '/RegisterPage': (_) => new RegisterPage(),
          '/MyProductsPage': (_) => new MyProductsPage(),
          '/PrivacyPage': (_) => new PrivacyPage(),
          '/MainPageTwo': (_) => new MainPageTwo(),
          '/InvitePage': (_) => new InvitePage(),
          '/ForgotPasswordPage': (_) => new ForgotPasswordPage(),
          '/SearchByProductPage': (_) => new SearchProductPage(),
          '/MyWalletPage': (_) => new MyWalletPage(),
          '/UpdateKYCPage': (_) => new UpdateKYCPage(),
          '/ContactSuport': (_) => new ContactSuport(),
          '/ChangePasswordPage': (_) => new ChangePasswordPage(),
          '/IntroPage': (_) => new IntroPage(),
          '/MyChatsPage': (_) => new MyChatsPage(),
          '/AddBankDetailsPage': (_) => new AddBankDetailsPage(),
          '/LoginSelector': (_) => new LoginSelector(),
          '/FAQPage': (_) => new FAQPage(),
          '/ViewCart': (_) => new ViewCart(),
          '/ServiceOrdersPage': (_) => new ServiceOrdersPage(),









            },
        theme: new ThemeData(
          brightness: Brightness.light,
            primaryColor: Colors.orange,
            accentColor: Colors.red,
            primaryTextTheme:
                TextTheme(title: TextStyle(color: Colors.white))));
  }
}
