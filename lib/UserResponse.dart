class UserResponse {
  final int CityID;
  final String ContactNo;
  final String UserId;
  final int userKYC;

  UserResponse({this.CityID, this.ContactNo, this.UserId, this.userKYC});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      CityID: json['CityID'],
      ContactNo: json['ContactNo'],
      UserId: json['UserId'],
      userKYC: json['userKYC'],
    );
  }
}
