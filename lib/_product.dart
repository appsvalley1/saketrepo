import 'package:SpotEasy/product_category.dart';

class Product {

  int AdID;
  String Description;
  int ProductAvailable;
  String ProductImage;
  String ProductName;
  int ProductRent;
  int ProductSecurity;
  int ProductStatus;
  String Specification;
  ProductCategory productCategory;

	Product.fromJsonMap(Map<String, dynamic> map): 
		AdID = map["AdID"],
		Description = map["Description"],
		ProductAvailable = map["ProductAvailable"],
		ProductImage = map["ProductImage"],
		ProductName = map["ProductName"],
		ProductRent = map["ProductRent"],
		ProductSecurity = map["ProductSecurity"],
		ProductStatus = map["ProductStatus"],
		Specification = map["Specification"],
		productCategory = ProductCategory.fromJsonMap(map["productCategory"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['AdID'] = AdID;
		data['Description'] = Description;
		data['ProductAvailable'] = ProductAvailable;
		data['ProductImage'] = ProductImage;
		data['ProductName'] = ProductName;
		data['ProductRent'] = ProductRent;
		data['ProductSecurity'] = ProductSecurity;
		data['ProductStatus'] = ProductStatus;
		data['Specification'] = Specification;
		data['productCategory'] = productCategory == null ? null : productCategory.toJson();
		return data;
	}
}
