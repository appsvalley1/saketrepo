class CityResponse {
  Null transactionMesage;
  int transactionStatus;
  List<ListCity> listCity;
  Null listOrders;
  Null listProducts;
  Null listcategories;
  Null user;

  CityResponse(
      {this.transactionMesage,
      this.transactionStatus,
      this.listCity,
      this.listOrders,
      this.listProducts,
      this.listcategories,
      this.user});

  CityResponse.fromJson(Map<String, dynamic> json) {
    transactionMesage = json['TransactionMesage'];
    transactionStatus = json['TransactionStatus'];
    if (json['listCity'] != null) {
      listCity = new List<ListCity>();
      json['listCity'].forEach((v) {
        listCity.add(new ListCity.fromJson(v));
      });
    }
    listOrders = json['listOrders'];
    listProducts = json['listProducts'];
    listcategories = json['listcategories'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TransactionMesage'] = this.transactionMesage;
    data['TransactionStatus'] = this.transactionStatus;
    if (this.listCity != null) {
      data['listCity'] = this.listCity.map((v) => v.toJson()).toList();
    }
    data['listOrders'] = this.listOrders;
    data['listProducts'] = this.listProducts;
    data['listcategories'] = this.listcategories;
    data['user'] = this.user;
    return data;
  }
}

class ListCity {
  String cityID;
  String cityImage;
  String cityName;

  ListCity({this.cityID, this.cityImage, this.cityName});

  ListCity.fromJson(Map<String, String> json) {
    cityID = json['CityID'];
    cityImage = json['CityImage'];
    cityName = json['CityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CityID'] = this.cityID;
    data['CityImage'] = this.cityImage;
    data['CityName'] = this.cityName;
    return data;
  }
}
