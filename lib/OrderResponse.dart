
class OrderResponse {

  String TransactionMesage;
  int TransactionStatus;
  Object listCity;
  Object listOrders;
  Object listProducts;
  Object listcategories;
  Object user;

	OrderResponse.fromJsonMap(Map<String, dynamic> map): 
		TransactionMesage = map["TransactionMesage"],
		TransactionStatus = map["TransactionStatus"],
		listCity = map["listCity"],
		listOrders = map["listOrders"],
		listProducts = map["listProducts"],
		listcategories = map["listcategories"],
		user = map["user"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['TransactionMesage'] = TransactionMesage;
		data['TransactionStatus'] = TransactionStatus;
		data['listCity'] = listCity;
		data['listOrders'] = listOrders;
		data['listProducts'] = listProducts;
		data['listcategories'] = listcategories;
		data['user'] = user;
		return data;
	}
}
