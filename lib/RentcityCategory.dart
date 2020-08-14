import 'package:SpotEasy/listcategories.dart';

class RentcityCategory {

  Object TransactionMesage;
  int TransactionStatus;
  Object listCity;
  Object listOrders;
  Object listProducts;
  List<Listcategories> listcategories;
  Object user;

	RentcityCategory.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"],
		TransactionStatus = map["TransactionStatus"],
		listCity = map["listCity"],
		listOrders = map["listOrders"],
		listProducts = map["listProducts"],
		listcategories = List<Listcategories>.from(map["listcategories"].map((it) => Listcategories.fromJsonMap(it))),
		user = map["user"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['listCity'] = listCity;
		data['listOrders'] = listOrders;
		data['listProducts'] = listProducts;
		data['listcategories'] = listcategories != null ? 
			this.listcategories.map((v) => v.toJson()).toList()
			: null;
		data['user'] = user;
		return data;
	}
}
