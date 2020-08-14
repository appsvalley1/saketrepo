import 'package:SpotEasy/earned_points_history.dart';
import 'package:SpotEasy/main_balance_history.dart';

class WalletResp {

  int ActualAmount;
  int RentcityPoints;
  int UserId;
  int WalletId;
  List<EarnedPointsHistory> earnedPointsHistory;
  List<MainBalanceHistory> mainBalanceHistory;

	WalletResp.fromJsonMap(Map<String, dynamic> map): 
		ActualAmount = map["ActualAmount"],
		RentcityPoints = map["RentcityPoints"],
		UserId = map["UserId"],
		WalletId = map["WalletId"],

				earnedPointsHistory = map["earnedPointsHistory"]!= null
						? List<EarnedPointsHistory>.from(map["earnedPointsHistory"].map((it) => EarnedPointsHistory.fromJsonMap(it)))
						: null,

				mainBalanceHistory = map["mainBalanceHistory"]!= null
						? List<MainBalanceHistory>.from(map["mainBalanceHistory"].map((it) => MainBalanceHistory.fromJsonMap(it)))
						: null;




	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['ActualAmount'] = ActualAmount;
		data['RentcityPoints'] = RentcityPoints;
		data['UserId'] = UserId;
		data['WalletId'] = WalletId;
		data['earnedPointsHistory'] = earnedPointsHistory != null ? 
			this.earnedPointsHistory.map((v) => v.toJson()).toList()
			: null;
		data['mainBalanceHistory'] = mainBalanceHistory != null ? 
			this.mainBalanceHistory.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
