
class ProductCategory {

  int CategoryID;
  String CategoryName;
  Object Categoryimage;

	ProductCategory.fromJsonMap(Map<String, dynamic> map): 
		CategoryID = map["CategoryID"],
		CategoryName = map["CategoryName"],
		Categoryimage = map["Categoryimage"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['CategoryID'] = CategoryID;
		data['CategoryName'] = CategoryName;
		data['Categoryimage'] = Categoryimage;
		return data;
	}
}
