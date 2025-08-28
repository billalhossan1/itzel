import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool success;
  String message;
  JobStatus data;

  Welcome({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        data: JobStatus.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class JobStatus {
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
  int totalApplicant;
  List<AllApplicant> allApplicants;

  JobStatus({
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
    required this.totalApplicant,
    required this.allApplicants,
  });

  factory JobStatus.fromJson(Map<String, dynamic> json) => JobStatus(
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
        totalApplicant: json["totalApplicant"],
        allApplicants: List<AllApplicant>.from(
            json["allApplicants"].map((x) => AllApplicant.fromJson(x))),
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
        "totalApplicant": totalApplicant,
        "allApplicants":
            List<dynamic>.from(allApplicants.map((x) => x.toJson())),
      };
}

class AllApplicant {
  String id;
  User user;
  List<Qna> qna;
  String job;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  AllApplicant({
    required this.id,
    required this.user,
    required this.qna,
    required this.job,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AllApplicant.fromJson(Map<String, dynamic> json) => AllApplicant(
        id: json["_id"],
        user: User.fromJson(json["user"]),
        qna: List<Qna>.from(json["QNA"].map((x) => Qna.fromJson(x))),
        job: json["job"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user.toJson(),
        "QNA": List<dynamic>.from(qna.map((x) => x.toJson())),
        "job": job,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Qna {
  String question;
  String answer;
  String id;

  Qna({
    required this.question,
    required this.answer,
    required this.id,
  });

  factory Qna.fromJson(Map<String, dynamic> json) => Qna(
        question: json["question"],
        answer: json["answer"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "_id": id,
      };
}

class User {
  String id;
  String name;
  String role;
  List<String> eventWishList;
  List<String> jobWishList;
  String email;
  String profile;
  String status;
  bool verified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String contact;
  String location;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        role: json["role"],
        eventWishList: List<String>.from(json["eventWishList"].map((x) => x)),
        jobWishList: List<String>.from(json["jobWishList"].map((x) => x)),
        email: json["email"],
        profile: json["profile"],
        status: json["status"],
        verified: json["verified"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        contact: json["contact"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "role": role,
        "eventWishList": List<dynamic>.from(eventWishList.map((x) => x)),
        "jobWishList": List<dynamic>.from(jobWishList.map((x) => x)),
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
