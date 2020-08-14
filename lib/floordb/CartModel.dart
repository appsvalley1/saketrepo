import 'package:floor/floor.dart';

@Entity(primaryKeys: ['ProductID'])
class CartModel {

  final int ProductID;

  final String ProductName;
  final int Amount;

  CartModel(this.ProductID,this.ProductName,this.Amount);
}