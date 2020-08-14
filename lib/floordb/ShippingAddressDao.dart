
import 'package:SpotEasy/floordb/ShippingAddress.dart';
import 'package:floor/floor.dart';

@dao
abstract class ShippingAddressDao {
  @Query('SELECT * FROM ShippingAddress')
  Future<List<ShippingAddress>> findAllShippingAddress();

  @Query('SELECT * FROM ShippingAddress WHERE id = :id')
  Future<ShippingAddress> findShippingAddressId(int id);

  @insert
  Future<void> insertShippingAddress(ShippingAddress shippingAddress);


  @delete
  Future<int> deleteShippingAddress(List<ShippingAddress> person);
}