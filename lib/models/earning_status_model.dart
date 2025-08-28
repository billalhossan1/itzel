import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool? success;
  String? message;
  List<EarningStatus>? data;

  Welcome({
    this.success,
    this.message,
    this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<EarningStatus>.from(
                json["data"]!.map((x) => EarningStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class EarningStatus {
  String? month;
  double? totalEarning;

  EarningStatus({this.month, this.totalEarning});

  factory EarningStatus.fromJson(Map<String, dynamic> json) {
    return EarningStatus(
      month: json['month'] as String?,
      totalEarning: (json['totalEarning'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'totalEarning': totalEarning,
    };
  }
}
