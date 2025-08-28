import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool success;
  String message;
  Data data;

  Welcome({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String name;
  String role;
  List<EventWishList> eventWishList;
  List<JobWishList> jobWishList;
  String email;
  String profile;
  String status;
  bool verified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String contact;
  String location;

  Data({
    required this.id,
    required this.name,
    required this.role,
    required this.eventWishList,
    required this.jobWishList,
    required this.email,
    required this.profile,
    required this.status,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.contact,
    required this.location,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"] ?? '',
        name: json["name"] ?? '',
        role: json["role"] ?? '',
        eventWishList: json["eventWishList"] != null
            ? List<EventWishList>.from(
                json["eventWishList"].map((x) => EventWishList.fromJson(x)))
            : [],
        jobWishList: json["jobWishList"] != null
            ? List<JobWishList>.from(
                json["jobWishList"].map((x) => JobWishList.fromJson(x)))
            : [],
        email: json["email"] ?? '',
        profile: json["profile"] ?? '',
        status: json["status"] ?? '',
        verified: json["verified"] ?? false,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : DateTime.now(),
        v: json["__v"] ?? 0,
        contact: json["contact"] ?? '',
        location: json["location"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "role": role,
        "eventWishList":
            List<dynamic>.from(eventWishList.map((x) => x.toJson())),
        "jobWishList": List<dynamic>.from(jobWishList.map((x) => x.toJson())),
        "email": email,
        "profile": profile,
        "status": status,
        "verified": verified,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "contact": contact,
        "location": location,
      };
}

class EventWishList {
  String id;
  String thumbnailImage;
  String introMedia;
  String name;
  DateTime time;
  String description;
  List<String> tags;
  int price;
  String? category;
  String creator;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? address;
  LocationData? location;
  List<double>? coordinate;

  EventWishList({
    required this.id,
    required this.thumbnailImage,
    required this.introMedia,
    required this.name,
    required this.time,
    required this.description,
    required this.tags,
    required this.price,
    this.category,
    required this.creator,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.address,
    this.location,
    this.coordinate,
  });

  factory EventWishList.fromJson(Map<String, dynamic> json) => EventWishList(
        id: json["_id"],
        thumbnailImage: json["thumbnailImage"],
        introMedia: json["introMedia"],
        name: json["name"],
        time: DateTime.parse(json["time"]),
        description: json["description"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        price: json["price"],
        category: json["category"],
        creator: json["creator"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        address: json["address"],
        location: json["location"] is Map
            ? LocationData.fromJson(json["location"])
            : null,
        coordinate: json["coordinate"] != null
            ? List<double>.from(json["coordinate"].map((x) => x.toDouble()))
            : null,
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
        "category": category,
        "creator": creator,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "address": address,
        "location": location?.toJson(),
        "coordinate": coordinate != null
            ? List<dynamic>.from(coordinate!.map((x) => x))
            : null,
      };
}

class LocationData {
  String name;
  List<double> coordinate;

  LocationData({
    required this.name,
    required this.coordinate,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        name: json["name"],
        coordinate:
            List<double>.from(json["coordinate"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "coordinate": List<dynamic>.from(coordinate.map((x) => x)),
      };
}

class JobWishList {
  String id;
  String image;
  String companyName;
  String role;
  String description;
  String address;
  String level;
  String jobType;
  String salary;
  List<String> requirements;
  List<String> experience;
  List<String> additionalRequirement;
  List<String> questions;
  String postedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  JobWishList({
    required this.id,
    required this.image,
    required this.companyName,
    required this.role,
    required this.description,
    required this.address,
    required this.level,
    required this.jobType,
    required this.salary,
    required this.requirements,
    required this.experience,
    required this.additionalRequirement,
    required this.questions,
    required this.postedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory JobWishList.fromJson(Map<String, dynamic> json) => JobWishList(
        id: json["_id"],
        image: json["image"],
        companyName: json["companyName"],
        role: json["role"],
        description: json["description"],
        address: json["address"],
        level: json["level"],
        jobType: json["jobType"],
        salary: json["salary"],
        requirements: List<String>.from(json["requirements"].map((x) => x)),
        experience: List<String>.from(json["experience"].map((x) => x)),
        additionalRequirement:
            List<String>.from(json["additionalRequirement"].map((x) => x)),
        questions: List<String>.from(json["questions"].map((x) => x)),
        postedBy: json["postedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "companyName": companyName,
        "role": role,
        "description": description,
        "address": address,
        "level": level,
        "jobType": jobType,
        "salary": salary,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
        "experience": List<dynamic>.from(experience.map((x) => x)),
        "additionalRequirement":
            List<dynamic>.from(additionalRequirement.map((x) => x)),
        "questions": List<dynamic>.from(questions.map((x) => x)),
        "postedBy": postedBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
