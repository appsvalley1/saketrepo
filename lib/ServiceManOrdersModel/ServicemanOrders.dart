class ServiceOrder {

   String ShippingAddress;
String OrderID;

String StartDate;
String TotalAmountPaid;

  ServiceOrder({ this.ShippingAddress,this.OrderID,this.StartDate,this.TotalAmountPaid});

  factory ServiceOrder.fromMap(Map data) {
    data = data ?? { };
    return ServiceOrder(
      ShippingAddress: data['ShippingAddress'] ?? '',

        OrderID: data['OrderID'] ?? '',
      StartDate: data['StartDate'] ?? '',

        TotalAmountPaid:data['TotalAmountPaid'] ??''
    );
  }

}