
import 'package:SpotEasy/list_products.dart';
import 'package:SpotEasy/loginresponse/user.dart';

class ListChats {

  int CollectionID;
  User Reciever;
  int RecieverID;
  int SenderID;
	User sender;
	String DateTimed;
	ListProducts product;

	ListChats.fromJsonMap(Map<String, dynamic> map): 
		CollectionID = map["CollectionID"],
		Reciever = User.fromJsonMap(map["Reciever"]),
		RecieverID = map["RecieverID"],
		SenderID = map["SenderID"],
		sender = User.fromJsonMap(map["sender"]),
				product = ListProducts.fromJsonMap(map["product"]),
				DateTimed=map["DateTimed"];



	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['CollectionID'] = CollectionID;
		data['DateTimed'] = DateTimed;
		data['Reciever'] = Reciever == null ? null : Reciever.toJson();
		data['RecieverID'] = RecieverID;
		data['SenderID'] = SenderID;
		data['product'] = product;
		data['sender'] = sender == null ? null : sender.toJson();
		return data;
	}
}
