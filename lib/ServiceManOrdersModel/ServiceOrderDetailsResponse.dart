


import 'package:SpotEasy/ServiceManOrdersModel/list_products.dart';

class ServiceOrderDetailsResponse {

  Object TransactionMesage;
  int TransactionStatus;
  Object listChats;
  Object listCity;
  Object listOrders;
  List<ListProducts> listProducts;
  Object listcategories;
  Object orders;
  Object user;

	ServiceOrderDetailsResponse.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"],
		TransactionStatus = map["TransactionStatus"],
		listChats = map["listChats"],
		listCity = map["listCity"],
		listOrders = map["listOrders"],
		listProducts = List<ListProducts>.from(map["listProducts"].map((it) => ListProducts.fromJsonMap(it))),
		listcategories = map["listcategories"],
		orders = map["orders"],
		user = map["user"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['listChats'] = listChats;
		data['listCity'] = listCity;
		data['listOrders'] = listOrders;
		data['listProducts'] = listProducts != null ? 
			this.listProducts.map((v) => v.toJson()).toList()
			: null;
		data['listcategories'] = listcategories;
		data['orders'] = orders;
		data['user'] = user;
		return data;
	}
}
