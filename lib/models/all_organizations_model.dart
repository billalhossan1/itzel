// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool? success;
  String? message;
  Pagination? pagination;
  List<AllOrganizations>? data;

  Welcome({
    this.success,
    this.message,
    this.pagination,
    this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        data: json["data"] == null
            ? []
            : List<AllOrganizations>.from(
                json["data"]!.map((x) => AllOrganizations.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "pagination": pagination?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AllOrganizations {
  String? id;
  String? name;
  String? image;
  String? category;
  String? locationName;
  List<int>? locationCoordinates;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<Review>? reviews;

  AllOrganizations({
    this.id,
    this.name,
    this.image,
    this.category,
    this.locationName,
    this.locationCoordinates,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.reviews,
  });

  factory AllOrganizations.fromJson(Map<String, dynamic> json) =>
      AllOrganizations(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        category: json["category"],
        locationName: json["locationName"],
        locationCoordinates: json["locationCoordinates"] == null
            ? []
            : List<int>.from(json["locationCoordinates"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "category": category,
        "locationName": locationName,
        "locationCoordinates": locationCoordinates == null
            ? []
            : List<dynamic>.from(locationCoordinates!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class Review {
  String? id;
  String? organization;
  String? description;
  int? star;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Review({
    this.id,
    this.organization,
    this.description,
    this.star,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        organization: json["organization"],
        description: json["description"],
        star: json["star"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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
        "organization": organization,
        "description": description,
        "star": star,
        "user": user?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class User {
  String? id;
  String? name;
  String? email;
  String? profile;

  User({
    this.id,
    this.name,
    this.email,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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

class Pagination {
  int? limit;
  int? page;
  int? total;
  int? totalPage;

  Pagination({
    this.limit,
    this.page,
    this.total,
    this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        limit: json["limit"],
        page: json["page"],
        total: json["total"],
        totalPage: json["totalPage"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "page": page,
        "total": total,
        "totalPage": totalPage,
      };
}
