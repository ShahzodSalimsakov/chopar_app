import 'package:hive/hive.dart';

part 'user.g.dart';

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

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  late int id;
  @HiveField(1)
  int? languageId;
  @HiveField(2)
  late String name;
  @HiveField(3)
  late String phone;
  @HiveField(4)
  Null verificationCode;
  @HiveField(5)
  Null phoneVerifiedAt;
  @HiveField(6)
  late String createdAt;
  @HiveField(7)
  late String updatedAt;
  @HiveField(8)
  Null mobile;
  @HiveField(9)
  late String userToken;
  @HiveField(10)
  late String? email;
  @HiveField(11)
  late String? birth;
  @HiveField(11)
  late int? gender;

  User({required this.id, this.languageId, required this.name, required this.phone, this.verificationCode, this.phoneVerifiedAt, required this.createdAt, required this.updatedAt, this.mobile, required this.userToken, this.email, this.birth, this.gender});

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
    email = json['email'];
    birth = json['birth'];
    gender = json['gender'];
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
    data['email'] = this.email;
    data['birth'] = this.birth;
    data['gender'] = this.gender;
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