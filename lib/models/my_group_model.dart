// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool? success;
  String? message;
  List<MyGroup>? data;

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
            : List<MyGroup>.from(json["data"]!.map((x) => MyGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MyGroup {
  String? id;
  String? name; // Added name field
  From? from;
  dynamic to;
  String? message;
  List<dynamic>? images;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? group;

  MyGroup({
    this.id,
    this.name, // Added name field
    this.from,
    this.to,
    this.message,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.group,
  });

  factory MyGroup.fromJson(Map<String, dynamic> json) => MyGroup(
        id: json["_id"],
        name: json["name"],
        // Added name field
        from: json["from"] == null ? null : From.fromJson(json["from"]),
        to: json["to"],
        message: json["message"],
        images: json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        group: json["group"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name, // Added name field
        "from": from?.toJson(),
        "to": to,
        "message": message,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "group": group,
      };
}

class From {
  String? id;
  String? name;
  String? email;
  String? profile;

  From({
    this.id,
    this.name,
    this.email,
    this.profile,
  });

  factory From.fromJson(Map<String, dynamic> json) => From(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "profile": profile,
      };
}
