import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool success;
  String message;
  Pagination pagination;
  List<Datum> data;

  Welcome({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "pagination": pagination.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  List<String> requirements;
  List<String> experience;
  List<String> additionalRequirement;
  String id;
  String image;
  String companyName;
  String role;
  String description;
  String address;
  String level;
  String jobType;
  String salary;
  List<String> questions;
  String postedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Datum({
    required this.requirements,
    required this.experience,
    required this.additionalRequirement,
    required this.id,
    required this.image,
    required this.companyName,
    required this.role,
    required this.description,
    required this.address,
    required this.level,
    required this.jobType,
    required this.salary,
    required this.questions,
    required this.postedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        requirements: List<String>.from(json["requirements"].map((x) => x)),
        experience: List<String>.from(json["experience"].map((x) => x)),
        additionalRequirement:
            List<String>.from(json["additionalRequirement"].map((x) => x)),
        id: json["_id"],
        image: json["image"],
        companyName: json["companyName"],
        role: json["role"],
        description: json["description"],
        address: json["address"],
        level: json["level"],
        jobType: json["jobType"],
        salary: json["salary"],
        questions: List<String>.from(json["questions"].map((x) => x)),
        postedBy: json["postedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
        "experience": List<dynamic>.from(experience.map((x) => x)),
        "additionalRequirement":
            List<dynamic>.from(additionalRequirement.map((x) => x)),
        "_id": id,
        "image": image,
        "companyName": companyName,
        "role": role,
        "description": description,
        "address": address,
        "level": level,
        "jobType": jobType,
        "salary": salary,
        "questions": List<dynamic>.from(questions.map((x) => x)),
        "postedBy": postedBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Pagination {
  int limit;
  int page;
  int total;
  int totalPage;

  Pagination({
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPage,
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
