

import 'list_orders.dart';

class AcriveOrderResponse {

  Object TransactionMesage;
  int TransactionStatus;
  Object listChats;
  Object listCity;
  List<ListOrders> listOrders;
  Object listProducts;
  Object listcategories;
  Object orders;
  Object user;

	AcriveOrderResponse.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"],
		TransactionStatus = map["TransactionStatus"],
		listChats = map["listChats"],
		listCity = map["listCity"],
		listOrders = List<ListOrders>.from(map["listOrders"].map((it) => ListOrders.fromJsonMap(it))),
		listProducts = map["listProducts"],
		listcategories = map["listcategories"],
		orders = map["orders"],
		user = map["user"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['listChats'] = listChats;
		data['listCity'] = listCity;
		data['listOrders'] = listOrders != null ? 
			this.listOrders.map((v) => v.toJson()).toList()
			: null;
		data['listProducts'] = listProducts;
		data['listcategories'] = listcategories;
		data['orders'] = orders;
		data['user'] = user;
		return data;
	}
}
