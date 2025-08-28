import 'dart:convert';

UnreadNotification welcomeFromJson(String str) =>
    UnreadNotification.fromJson(json.decode(str));

String welcomeToJson(UnreadNotification data) => json.encode(data.toJson());

class UnreadNotification {
  bool? success;
  String? message;
  int? data;

  UnreadNotification({
    this.success,
    this.message,
    this.data,
  });

  factory UnreadNotification.fromJson(Map<String, dynamic> json) =>
      UnreadNotification(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };
}
