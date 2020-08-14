import 'package:SpotEasy/list_products.dart';

class ListOrders {
  int InitiateRefund;
  int OrderID;
  int OrderStatus;
  String PaymentInvoiceID;
  String PinCode;
 /* ListProducts Product;*/
  String ShippingAddress;
  String StartDate;
  int Tenure;
  int UserId;
  int TotalAmountPaid ;


  int StartServiceOTPStatus;
  int EndServiceOTPStatus;

  ListOrders.fromJsonMap(Map<String, dynamic> map)
      : InitiateRefund = map["InitiateRefund"],
        OrderID = map["OrderID"],
        OrderStatus = map["OrderStatus"],
        PaymentInvoiceID = map["PaymentInvoiceID"],
        PinCode = map["PinCode"],
        StartServiceOTPStatus = map["StartServiceOTPStatus"],
        EndServiceOTPStatus = map["EndServiceOTPStatus"],
       /* Product = ListProducts.fromJsonMap(map["Product"]),*/
        TotalAmountPaid= map["TotalAmountPaid"],
        ShippingAddress = map["ShippingAddress"],
        StartDate = map["StartDate"],
        Tenure = map["Tenure"],
        UserId = map["UserId"];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InitiateRefund'] = InitiateRefund;
    data['OrderID'] = OrderID;
    data['OrderStatus'] = OrderStatus;
    data['PaymentInvoiceID'] = PaymentInvoiceID;
    data['PinCode'] = PinCode;
    data['TotalAmountPaid'] = TotalAmountPaid;

    data['StartServiceOTPStatus'] = StartServiceOTPStatus;
    data['EndServiceOTPStatus'] = EndServiceOTPStatus;
  /*  data['Product'] = Product == null ? null : Product.toJson();*/
    data['ShippingAddress'] = ShippingAddress;
    data['StartDate'] = StartDate;
    data['Tenure'] = Tenure;
    data['UserId'] = UserId;
    return data;
  }
}
