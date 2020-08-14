
class ListCity {

  int CityID;
  String CityImage;
  String CityName;

	ListCity.fromJsonMap(Map<String, dynamic> map): 
		CityID = map["CityID"],
		CityImage = map["CityImage"],
		CityName = map["CityName"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['CityID'] = CityID;
		data['CityImage'] = CityImage;
		data['CityName'] = CityName;
		return data;
	}
}
