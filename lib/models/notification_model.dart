import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool? success;
  String? message;
  Pagination? pagination;
  List<Notification>? data;

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
            : List<Notification>.from(
                json["data"]!.map((x) => Notification.fromJson(x))),
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

class Notification {
  String? id;
  String? user;
  String? description;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Notification({
    this.id,
    this.user,
    this.description,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["_id"],
        user: json["user"],
        description: json["description"],
        title: json["title"],
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
        "user": user,
        "description": description,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
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
