import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool? success;
  String? message;
  Data? data;

  Welcome({
    this.success,
    this.message,
    this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) {
    return Welcome(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  List<EventHistory>? upcommingEvents;
  List<EventHistory>? eventHistory;

  Data({
    this.upcommingEvents,
    this.eventHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      upcommingEvents: json['upcommingEvents'] != null
          ? List<EventHistory>.from((json['upcommingEvents'] as List)
              .where((x) => x != null)
              .map((x) => EventHistory.fromJson(x as Map<String, dynamic>)))
          : null,
      eventHistory: json['eventHistory'] != null
          ? List<EventHistory>.from((json['eventHistory'] as List)
              .where((x) => x != null)
              .map((x) => EventHistory.fromJson(x as Map<String, dynamic>)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'upcommingEvents': upcommingEvents?.map((x) => x.toJson()).toList(),
      'eventHistory': eventHistory?.map((x) => x.toJson()).toList(),
    };
  }
}

class EventHistory {
  String? id;
  String? thumbnailImage;
  String? introMedia;
  String? name;
  DateTime? time;
  String? description;
  List<String>? tags;
  int? price;
  String? creator;
  String? address;
  List<double>? coordinate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  EventHistory({
    this.id,
    this.thumbnailImage,
    this.introMedia,
    this.name,
    this.time,
    this.description,
    this.tags,
    this.price,
    this.creator,
    this.address,
    this.coordinate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory EventHistory.fromJson(Map<String, dynamic> json) {
    return EventHistory(
      id: json['_id'] as String?,
      thumbnailImage: json['thumbnailImage'] as String?,
      introMedia: json['introMedia'] as String?,
      name: json['name'] as String?,
      time:
          json['time'] != null ? DateTime.parse(json['time'].toString()) : null,
      description: json['description'] as String?,
      tags: json['tags'] != null
          ? List<String>.from((json['tags'] as List)
              .where((x) => x != null)
              .map((x) => x.toString()))
          : null,
      price:
          json['price'] != null ? int.tryParse(json['price'].toString()) : null,
      creator: json['creator'] as String?,
      address: json['address'] as String?,
      coordinate: json['coordinate'] != null
          ? List<double>.from((json['coordinate'] as List)
              .where((x) => x != null)
              .map((x) => double.parse(x.toString())))
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
      v: json['__v'] != null ? int.tryParse(json['__v'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'thumbnailImage': thumbnailImage,
      'introMedia': introMedia,
      'name': name,
      'time': time?.toIso8601String(),
      'description': description,
      'tags': tags,
      'price': price,
      'creator': creator,
      'address': address,
      'coordinate': coordinate,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}
