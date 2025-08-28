import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool success;
  String message;
  EventStatus data;

  Welcome({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        data: EventStatus.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class EventStatus {
  String id;
  String thumbnailImage;
  String introMedia;
  String name;
  DateTime time;
  String description;
  List<String> tags;
  int price;
  String creator;
  String address;
  List<double> coordinate;
  DateTime createdAt;
  DateTime updatedAt;
  double totalEarning;
  int ticketSold;

  EventStatus({
    required this.id,
    required this.thumbnailImage,
    required this.introMedia,
    required this.name,
    required this.time,
    required this.description,
    required this.tags,
    required this.price,
    required this.creator,
    required this.address,
    required this.coordinate,
    required this.createdAt,
    required this.updatedAt,
    required this.totalEarning,
    required this.ticketSold,
  });

  factory EventStatus.fromJson(Map<String, dynamic> json) => EventStatus(
        id: json["_id"] ?? '',
        thumbnailImage: json["thumbnailImage"] ?? '',
        introMedia: json["introMedia"] ?? '',
        name: json["name"] ?? '',
        time: DateTime.parse(json["time"] ?? DateTime.now().toIso8601String()),
        description: json["description"] ?? '',
        tags: List<String>.from(json["tags"]?.map((x) => x) ?? []),
        price: json["price"] ?? 0,
        creator: json["creator"] ?? '',
        address: json["address"] ?? '',
        coordinate: List<double>.from(
            json["coordinate"]?.map((x) => x.toDouble()) ?? []),
        createdAt: DateTime.parse(
            json["createdAt"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updatedAt"] ?? DateTime.now().toIso8601String()),
        totalEarning: (json["totalEarning"] ?? 0).toDouble(),
        ticketSold: json["ticketSold"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "thumbnailImage": thumbnailImage,
        "introMedia": introMedia,
        "name": name,
        "time": time.toIso8601String(),
        "description": description,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "price": price,
        "creator": creator,
        "address": address,
        "coordinate": List<dynamic>.from(coordinate.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "totalEarning": totalEarning,
        "ticketSold": ticketSold,
      };
}
