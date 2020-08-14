import 'package:floor/floor.dart';

@entity
class ShippingAddress {
  @primaryKey
  final int id;

  final String HouseNumber;
  final String SocietyName;
  final String FullAddress;
  final String PinCode;
  final String AddressTag;
  ShippingAddress(this.id, this.HouseNumber,this.SocietyName,this.FullAddress,this.PinCode,this.AddressTag);
}