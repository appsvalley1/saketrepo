import 'package:SpotEasy/loginresponse/user.dart';


class LoginResp {

  String TransactionMesage;
  int TransactionStatus;
  Object listCity;
  Object listOrders;
  Object listProducts;
  Object listcategories;
  User user;

	LoginResp.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"],
		TransactionStatus = map["TransactionStatus"],
		listCity = map["listCity"],
		listOrders = map["listOrders"],
		listProducts = map["listProducts"],
		listcategories = map["listcategories"],
		user = map["user"]!=null? User.fromJsonMap(map["user"]):null;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['listCity'] = listCity;
		data['listOrders'] = listOrders;
		data['listProducts'] = listProducts;
		data['listcategories'] = listcategories;
		data['user'] = user == null ? null : user.toJson();
		return data;
	}
}
