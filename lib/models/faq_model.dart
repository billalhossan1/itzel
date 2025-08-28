class FAQ {
  bool? success;
  String? message;
  Pagination? pagination;
  List<Data>? data;

  FAQ({this.success, this.message, this.pagination, this.data});

  FAQ.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? limit;
  int? page;
  int? total;
  int? totalPage;

  Pagination({this.limit, this.page, this.total, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    total = json['total'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    data['total'] = total;
    data['totalPage'] = totalPage;
    return data;
  }
}

class Data {
  String? sId;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.question,
      this.answer,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['question'] = question;
    data['answer'] = answer;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
