
class User {

  int ActivationStatus;
  int CityID;
  String ContactNo;
  String EmailAddress;
  String FullName;
  String Password;
  String RegistrationID;
  Object TransactionDetails;
  String UserId;
  int userKYC;
  //UserRole 1=user, 2=serviceman
	int bankDetailsStatus;
	int UserRole;
	String ReferralCode;
	User.fromJsonMap(Map<String, dynamic> map): 

		CityID = map["CityID"],
		ContactNo = map["ContactNo"],
		EmailAddress = map["EmailAddress"],
		FullName = map["FullName"],
		Password = map["Password"],
		RegistrationID = map["RegistrationID"],
		TransactionDetails = map["TransactionDetails"],
		UserId = map["UserId"],
		userKYC = map["userKYC"],
				UserRole = map["UserRole"],

				bankDetailsStatus= map["bankDetailsStatus"],
	ReferralCode = map["ReferralCode"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['ActivationStatus'] = ActivationStatus;
		data['CityID'] = CityID;
		data['ContactNo'] = ContactNo;
		data['EmailAddress'] = EmailAddress;
		data['FullName'] = FullName;
		data['Password'] = Password;
		data['RegistrationID'] = RegistrationID;
		data['TransactionDetails'] = TransactionDetails;
		data['UserId'] = UserId;
		data['userKYC'] = userKYC;
		data['UserRole'] = UserRole;

		data['ReferralCode'] = ReferralCode;
		data['bankDetailsStatus'] = bankDetailsStatus;
		return data;
	}
}
