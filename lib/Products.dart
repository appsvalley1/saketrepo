class Products {
  Null transactionMesage;
  int transactionStatus;
  List<ListProducts> listProducts;
  Null listcategories;
  Null user;

  Products(
      {this.transactionMesage,
      this.transactionStatus,
      this.listProducts,
      this.listcategories,
      this.user});

  Products.fromJson(Map<String, dynamic> json) {
    transactionMesage = json['TransactionMesage'];
    transactionStatus = json['TransactionStatus'];
    if (json['listProducts'] != null) {
      listProducts = new List<ListProducts>();
      json['listProducts'].forEach((v) {
        listProducts.add(new ListProducts.fromJson(v));
      });
    }
    listcategories = json['listcategories'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TransactionMesage'] = this.transactionMesage;
    data['TransactionStatus'] = this.transactionStatus;
    if (this.listProducts != null) {
      data['listProducts'] = this.listProducts.map((v) => v.toJson()).toList();
    }
    data['listcategories'] = this.listcategories;
    data['user'] = this.user;
    return data;
  }
}

class ListProducts {
  int adID;
  String description;
  int productAvailable;
  String productImage;
  String productName;
  int productRent;
  int productSecurity;
  String specification;
  ProductCategory productCategory;

  ListProducts(
      {this.adID,
      this.description,
      this.productAvailable,
      this.productImage,
      this.productName,
      this.productRent,
      this.productSecurity,
      this.specification,
      this.productCategory});

  ListProducts.fromJson(Map<String, dynamic> json) {
    adID = json['AdID'];
    description = json['Description'];
    productAvailable = json['ProductAvailable'];
    productImage = json['ProductImage'];
    productName = json['ProductName'];
    productRent = json['ProductRent'];
    productSecurity = json['ProductSecurity'];
    specification = json['Specification'];
    productCategory = json['productCategory'] != null
        ? new ProductCategory.fromJson(json['productCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AdID'] = this.adID;
    data['Description'] = this.description;
    data['ProductAvailable'] = this.productAvailable;
    data['ProductImage'] = this.productImage;
    data['ProductName'] = this.productName;
    data['ProductRent'] = this.productRent;
    data['ProductSecurity'] = this.productSecurity;
    data['Specification'] = this.specification;
    if (this.productCategory != null) {
      data['productCategory'] = this.productCategory.toJson();
    }
    return data;
  }
}

class ProductCategory {
  int categoryID;
  String categoryName;

  ProductCategory({this.categoryID, this.categoryName});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    categoryID = json['CategoryID'];
    categoryName = json['CategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryID'] = this.categoryID;
    data['CategoryName'] = this.categoryName;
    return data;
  }
}
