import 'package:SpotEasy/list_products.dart';

class RentcityProducts {

  Object TransactionMesage;
  int TransactionStatus;
  Object listCity;
  Object listOrders;
  List<ListProducts> listProducts;
  Object listcategories;
  Object user;

	RentcityProducts.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"],
		TransactionStatus = map["TransactionStatus"],
		listCity = map["listCity"],
		listOrders = map["listOrders"],
		listProducts = List<ListProducts>.from(map["listProducts"].map((it) => ListProducts.fromJsonMap(it))),
		listcategories = map["listcategories"],
		user = map["user"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['listCity'] = listCity;
		data['listOrders'] = listOrders;
		data['listProducts'] = listProducts != null ? 
			this.listProducts.map((v) => v.toJson()).toList()
			: null;
		data['listcategories'] = listcategories;
		data['user'] = user;
		return data;
	}
}
