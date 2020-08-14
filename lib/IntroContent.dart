import 'package:flutter/material.dart';

var pageList = [
  PageModel(
      imageUrl: "assets/illone.png",
      title: "Spot",
      body: "Expert services at your doorstep",
      titleGradient: gradients[0]),
  PageModel(
      imageUrl: "assets/illustration2.png",
      title: "Best Services",
      body: "Quick and  Professional Solution to your daily problems ",
      titleGradient: gradients[1]),
  PageModel(
      imageUrl: "assets/illustration3.png",
      title: "Hassle free",
      body: "Services out through Spot is a hassle free process, ‘Servicing Made Easy’ with Spot.",
      titleGradient: gradients[2]),
];

List<List<Color>> gradients = [
  [Colors.green, Color(0xFFFCCF31)],
  [Color(0xFFE2859F), Color(0xFFFCCF31)],
  [Color(0xFF5EFCE8), Color(0xFF736EFE)],
];

class PageModel {
  var imageUrl;
  var title;
  var body;
  List<Color> titleGradient = [];
  PageModel({this.imageUrl, this.title, this.body, this.titleGradient});
}