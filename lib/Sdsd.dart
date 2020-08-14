import 'package:SpotEasy/list_city.dart';

class Sdsd {

  Object TransactionMesage;
  int TransactionStatus;
  List<ListCity> listCity;
  Object listOrders;
  Object listProducts;
  Object listcategories;
  Object user;

	Sdsd.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"],
		TransactionStatus = map["TransactionStatus"],
		listCity = List<ListCity>.from(map["listCity"].map((it) => ListCity.fromJsonMap(it))),
		listOrders = map["listOrders"],
		listProducts = map["listProducts"],
		listcategories = map["listcategories"],
		user = map["user"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['listCity'] = listCity != null ? 
			this.listCity.map((v) => v.toJson()).toList()
			: null;
		data['listOrders'] = listOrders;
		data['listProducts'] = listProducts;
		data['listcategories'] = listcategories;
		data['user'] = user;
		return data;
	}
}
