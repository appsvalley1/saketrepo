
class MainBalanceHistory {

  int WalletId;
  int WalletTransactionsAmount;
  String WalletTransactionsDate;
  String WalletTransactionsEarnedFrom;
  Object WalletTransactionsId;
  int WalletTransactionsTypeId;

	MainBalanceHistory.fromJsonMap(Map<String, dynamic> map): 
		WalletId = map["WalletId"],
		WalletTransactionsAmount = map["WalletTransactionsAmount"],
		WalletTransactionsDate = map["WalletTransactionsDate"],
		WalletTransactionsEarnedFrom = map["WalletTransactionsEarnedFrom"],
		WalletTransactionsId = map["WalletTransactionsId"],
		WalletTransactionsTypeId = map["WalletTransactionsTypeId"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['WalletId'] = WalletId;
		data['WalletTransactionsAmount'] = WalletTransactionsAmount;
		data['WalletTransactionsDate'] = WalletTransactionsDate;
		data['WalletTransactionsEarnedFrom'] = WalletTransactionsEarnedFrom;
		data['WalletTransactionsId'] = WalletTransactionsId;
		data['WalletTransactionsTypeId'] = WalletTransactionsTypeId;
		return data;
	}
}
