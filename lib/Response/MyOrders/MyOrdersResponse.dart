import 'package:SpotEasy/Response/MyOrders/list_orders.dart';

class MyOrdersResponse {

  Object TransactionMesage;
  int TransactionStatus;
  Object listCity;
  List<ListOrders> listOrders;
  Object listProducts;
  Object listcategories;
  Object user;
	int TotalAmountPaid ;

	MyOrdersResponse.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"]!=null? map["TransactionMesage"]:null,
		TransactionStatus = map["TransactionStatus"]!=null? map["TransactionStatus"]:null,
				TotalAmountPaid = map["TotalAmountPaid"]!=null? map["TotalAmountPaid"]:null,
		listCity = map["listCity"]!=null? map["listCity"]:null,
		listOrders = List<ListOrders>.from(map["listOrders"].map((it) => ListOrders.fromJsonMap(it))),
		listProducts = map["listProducts"]!=null? map["listProducts"]:null,
		listcategories = map["listcategories"]!=null? map["listcategories"]:null,
		user = map["user"]!=null? map["user"]:null;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['TotalAmountPaid'] = TotalAmountPaid;

		data['listCity'] = listCity;
		data['listOrders'] = listOrders != null ? 
			this.listOrders.map((v) => v.toJson()).toList()
			: null;
		data['listProducts'] = listProducts;
		data['listcategories'] = listcategories;
		data['user'] = user;
		return data;
	}
}
