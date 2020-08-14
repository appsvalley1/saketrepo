import 'package:SpotEasy/Products.dart';

import 'list_chats.dart';

class ChatsResponse {
  Object TransactionMesage;
  int TransactionStatus;
  List<ListChats> listChats;
  Object listCity;
  Object listOrders;
  Object listcategories;
  Object user;

  ChatsResponse.fromJsonMap(Map<String, dynamic> map)
      : TransactionMesage = map["TransactionMesage"],
        TransactionStatus = map["TransactionStatus"],
        listChats = List<ListChats>.from(
            map["listChats"].map((it) => ListChats.fromJsonMap(it))),
        listCity = map["listCity"],
        listOrders = map["listOrders"],

        listcategories = map["listcategories"],
        user = map["user"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TransactionMesage'] = TransactionMesage;
    data['TransactionStatus'] = TransactionStatus;
    data['listChats'] = listChats != null
        ? this.listChats.map((v) => v.toJson()).toList()
        : null;
    data['listCity'] = listCity;
    data['listOrders'] = listOrders;
    data['listcategories'] = listcategories;
    data['user'] = user;
    return data;
  }
}
