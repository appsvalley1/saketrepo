
class ListOrders {

  int AdminFee;
  String EndServiceOTP;
  int InitiateRefund;
  int OrderAssignedTo;
  int OrderID;
  int OrderStatus;
  String PaymentInvoiceID;
  String PinCode;
  Object Product;
  String ShippingAddress;
  String StartDate;
  String StartServiceOTP;
  int Tenure;
  int TotalAmountPaid;
  int UserId;
	int StartServiceOTPStatus;
	int EndServiceOTPStatus;

	String Latitude;

	String Longitude;

	ListOrders.fromJsonMap(Map<String, dynamic> map): 
		AdminFee = map["AdminFee"],
		EndServiceOTP = map["EndServiceOTP"],
		InitiateRefund = map["InitiateRefund"],
		OrderAssignedTo = map["OrderAssignedTo"],
		OrderID = map["OrderID"],
				StartServiceOTPStatus = map["StartServiceOTPStatus"],
				EndServiceOTPStatus = map["EndServiceOTPStatus"],
		OrderStatus = map["OrderStatus"],
				Latitude = map["Latitude"],
				Longitude = map["Longitude"],
		PaymentInvoiceID = map["PaymentInvoiceID"],
		PinCode = map["PinCode"],
		Product = map["Product"],
		ShippingAddress = map["ShippingAddress"],
		StartDate = map["StartDate"],
		StartServiceOTP = map["StartServiceOTP"],
		Tenure = map["Tenure"],
		TotalAmountPaid = map["TotalAmountPaid"],
		UserId = map["UserId"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['AdminFee'] = AdminFee;
		data['EndServiceOTP'] = EndServiceOTP;
		data['InitiateRefund'] = InitiateRefund;
		data['OrderAssignedTo'] = OrderAssignedTo;
		data['OrderID'] = OrderID;
		data['OrderStatus'] = OrderStatus;
		data['PaymentInvoiceID'] = PaymentInvoiceID;
		data['PinCode'] = PinCode;
		data['Latitude'] = Latitude;
		data['Longitude'] = Longitude;
		data['Product'] = Product;

		data['StartServiceOTPStatus'] = StartServiceOTPStatus;
		data['EndServiceOTPStatus'] = EndServiceOTPStatus;
		data['ShippingAddress'] = ShippingAddress;
		data['StartDate'] = StartDate;
		data['StartServiceOTP'] = StartServiceOTP;
		data['Tenure'] = Tenure;
		data['TotalAmountPaid'] = TotalAmountPaid;
		data['UserId'] = UserId;
		return data;
	}
}
