import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool success;
  String message;
  CreatorStatus data;

  Welcome({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        data: CreatorStatus.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class CreatorStatus {
  List<AllEvent> allEvents;
  List<AllJob> allJobs;

  CreatorStatus({
    required this.allEvents,
    required this.allJobs,
  });

  factory CreatorStatus.fromJson(Map<String, dynamic> json) => CreatorStatus(
        allEvents: List<AllEvent>.from(
            json["allEvents"].map((x) => AllEvent.fromJson(x))),
        allJobs:
            List<AllJob>.from(json["allJobs"].map((x) => AllJob.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "allEvents": List<dynamic>.from(allEvents.map((x) => x.toJson())),
        "allJobs": List<dynamic>.from(allJobs.map((x) => x.toJson())),
      };
}

class AllEvent {
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
  int v;

  AllEvent({
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
    required this.v,
  });

  factory AllEvent.fromJson(Map<String, dynamic> json) => AllEvent(
        id: json["_id"],
        thumbnailImage: json["thumbnailImage"],
        introMedia: json["introMedia"],
        name: json["name"],
        time: DateTime.parse(json["time"]),
        description: json["description"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        price: json["price"],
        creator: json["creator"],
        address: json["address"],
        coordinate:
            List<double>.from(json["coordinate"].map((x) => x?.toDouble())),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
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
        "__v": v,
      };
}

class AllJob {
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

  AllJob({
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

  factory AllJob.fromJson(Map<String, dynamic> json) => AllJob(
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
