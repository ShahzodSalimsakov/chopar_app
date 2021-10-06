class UserData {
  late int id;
  late int userId;
  late List<String> userIdentify;
  late String userContact;
  late String userToken;
  late int verifiedAt;
  late int status;
  User? user;

  UserData({required this.id, required this.userId, required this.userIdentify, required this.userContact, required this.userToken, required this.verifiedAt, required this.status, this.user});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userIdentify = json['user_identify'].cast<String>();
    userContact = json['user_contact'];
    userToken = json['user_token'];
    verifiedAt = json['verified_at'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_identify'] = this.userIdentify;
    data['user_contact'] = this.userContact;
    data['user_token'] = this.userToken;
    data['verified_at'] = this.verifiedAt;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    return data;
  }
}

class User {
  late int id;
  Null languageId;
  late String name;
  late String phone;
  Null verificationCode;
  Null phoneVerifiedAt;
  late String createdAt;
  late String updatedAt;
  Null mobile;
  late String userToken;
  List<Roles>? roles;

  User({required this.id, this.languageId, required this.name, required this.phone, this.verificationCode, this.phoneVerifiedAt, required this.createdAt, required this.updatedAt, this.mobile, required this.userToken, required this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageId = json['language_id'];
    name = json['name'];
    phone = json['phone'];
    verificationCode = json['verification_code'];
    phoneVerifiedAt = json['phone_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mobile = json['mobile'];
    userToken = json['user_token'];
    if (json['roles'] != null) {
      roles = new List<Roles>.empty();
      json['roles'].forEach((v) { roles?.add(new Roles.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_id'] = this.languageId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['verification_code'] = this.verificationCode;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['mobile'] = this.mobile;
    data['user_token'] = this.userToken;
    if (this.roles != null) {
      data['roles'] = this.roles?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  late int id;
  late String name;
  late String guardName;
  late String createdAt;
  late String updatedAt;
  Pivot? pivot;

  Roles({required this.id, required this.name, required this.guardName, required this.createdAt, required this.updatedAt, this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot?.toJson();
    }
    return data;
  }
}

class Pivot {
  late int modelId;
  late int roleId;
  late String modelType;

  Pivot({required this.modelId, required this.roleId, required this.modelType});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    roleId = json['role_id'];
    modelType = json['model_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    data['model_type'] = this.modelType;
    return data;
  }
}