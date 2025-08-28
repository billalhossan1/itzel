class CreatorAnalyticsStatus {
  bool? success;
  String? message;
  Data? data;

  CreatorAnalyticsStatus({this.success, this.message, this.data});

  CreatorAnalyticsStatus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? totalEvent;
  String? totalParticipants;
  String? totalEarning;

  Data({
    this.totalEvent,
    this.totalParticipants,
    this.totalEarning,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalEvent = json['totalEvent']?.toString();
    totalParticipants = json['totalParticipants']?.toString();
    totalEarning = json['totalEarning']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalEvent'] = totalEvent;
    data['totalParticipants'] = totalParticipants;
    data['totalEarning'] = totalEarning;
    return data;
  }
}
