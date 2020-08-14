import 'dart:async';
import 'package:SpotEasy/floordb/CartModel.dart';
import 'package:SpotEasy/floordb/CartModelDao.dart';
import 'package:SpotEasy/floordb/ShippingAddressDao.dart';
import 'package:SpotEasy/floordb/ShippingAddress.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';



@Database(version: 1, entities: [ShippingAddress,CartModel])
abstract class AppDatabase extends FloorDatabase {
  ShippingAddressDao get shippingAddressDao;
  CartModelDao get cartModelDao;
}