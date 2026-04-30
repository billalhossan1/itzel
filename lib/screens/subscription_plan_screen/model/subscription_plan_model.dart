class SubscriptionPlanModel {
  bool? success;
  String? message;
  List<SubscriptionItem>? data;

  SubscriptionPlanModel({this.success, this.message, this.data});

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SubscriptionItem>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscriptionItem {
  String? sId;
  String? title;
  List<String>? description;
  int? price;
  String? duration;
  String? paymentType;
  String? status;
  String? productId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SubscriptionItem(
      {this.sId,
        this.title,
        this.description,
        this.price,
        this.duration,
        this.paymentType,
        this.status,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SubscriptionItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'].cast<String>();
    price = json['price'];
    duration = json['duration'];
    paymentType = json['paymentType'];
    status = json['status'];
    productId = json['product_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['duration'] = duration;
    data['paymentType'] = paymentType;
    data['status'] = status;
    data['product_id'] = productId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
