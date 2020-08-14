
import 'package:SpotEasy/floordb/ShippingAddress.dart';
import 'package:floor/floor.dart';

import 'CartModel.dart';

@dao
abstract class CartModelDao {
  @Query('SELECT * FROM CartModel')
  Future<List<CartModel>> findAllCartModel();

  @Query('SELECT * FROM CartModel WHERE id = :id')
  Future<CartModel> findCartModelId(int id);

  @insert
  Future<void> insertCartModel(CartModel  cartModel);


  @delete
  Future<int> deleteCartModel(CartModel person);

  @Query('DELETE FROM CartModel')
  Future<void> deleteAllCartModel();
}