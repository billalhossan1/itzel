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
        data!.add(SubscriptionItem.fromJson(v));
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
  String? name;
  int? allowedJobPost;
  int? allowedEventPost;
  List<String>? features;
  num? price;
  String? type;
  String? platform;
  String? productId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? duration;

  SubscriptionItem(
      {this.sId,
      this.name,
      this.allowedJobPost,
      this.allowedEventPost,
      this.features,
      this.price,
      this.type,
      this.platform,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.duration,
      this.iV});

  SubscriptionItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    allowedJobPost = json['allowedJobPost'];
    allowedEventPost = json['allowedEventPost'];
    features = json['features'] != null ? json['features'].cast<String>() : [];
    price = json['price'];
    type = json['type'];
    platform = json['platform'];
    productId = json['productId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['allowedJobPost'] = allowedJobPost;
    data['allowedEventPost'] = allowedEventPost;
    data['features'] = features;
    data['price'] = price;
    data['type'] = type;
    data['platform'] = platform;
    data['productId'] = productId;
    data['createdAt'] = createdAt;
    data['duration'] = duration;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
