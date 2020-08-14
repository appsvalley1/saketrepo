import 'package:SpotEasy/CityResponse.dart';
import 'package:SpotEasy/UserResponse.dart';

class TransactionResponse {
  final int TransactionStatus;
  final String TransactionMesage;
  final UserResponse user;
  final List<CityResponse> listCity;


  TransactionResponse(
      {this.TransactionStatus, this.TransactionMesage, this.user,this.listCity});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      TransactionStatus: json['TransactionStatus'],
      TransactionMesage: json['TransactionMesage'],
      user: UserResponse.fromJson(json["user"]),
   //   listCity: CityResponse.parseCityResponse(json["listCity"]),


    );
  }
}
