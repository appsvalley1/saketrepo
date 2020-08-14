

import 'package:SpotEasy/WalletResp.dart';

class Dashboardresponse {

  int AppUpdateMandetory;
  int AppUpdateRequired;
  int UserStatus;
  int Version;
	WalletResp userWallet;

	Dashboardresponse.fromJsonMap(Map<String, dynamic> map): 
		AppUpdateMandetory = map["AppUpdateMandetory"],
		AppUpdateRequired = map["AppUpdateRequired"],
		UserStatus = map["UserStatus"],
		Version = map["Version"],
		userWallet = WalletResp.fromJsonMap(map["userWallet"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['AppUpdateMandetory'] = AppUpdateMandetory;
		data['AppUpdateRequired'] = AppUpdateRequired;
		data['UserStatus'] = UserStatus;
		data['Version'] = Version;
		data['userWallet'] = userWallet == null ? null : userWallet.toJson();
		return data;
	}
}
