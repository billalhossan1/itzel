import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool? success;
  String? message;
  List<MyProduct>? data;

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
            : List<MyProduct>.from(
                json["data"]!.map((x) => MyProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MyProduct {
  String? id;
  String? createdBy;
  String? image;
  String? name;
  String? description;
  int? price;
  String? country;
  String? state;
  String? city;
  String? phone;
  String? whatsapp;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  MyProduct({
    this.id,
    this.createdBy,
    this.image,
    this.name,
    this.description,
    this.price,
    this.country,
    this.state,
    this.city,
    this.phone,
    this.whatsapp,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory MyProduct.fromJson(Map<String, dynamic> json) => MyProduct(
        id: json["_id"],
        createdBy: json["createdBy"],
        image: json["image"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdBy": createdBy,
        "image": image,
        "name": name,
        "description": description,
        "price": price,
        "country": country,
        "state": state,
        "city": city,
        "phone": phone,
        "whatsapp": whatsapp,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
