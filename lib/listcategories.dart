
class Listcategories {

  int CategoryID;
  String CategoryName;

	Listcategories.fromJsonMap(Map<String, dynamic> map): 
		CategoryID = map["CategoryID"],
		CategoryName = map["CategoryName"];


	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['CategoryID'] = CategoryID;
		data['CategoryName'] = CategoryName;

		return data;
	}
}
