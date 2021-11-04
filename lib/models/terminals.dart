import 'package:hive/hive.dart';

part 'terminals.g.dart';

@HiveType(typeId: 3)
class Terminals {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? createdAt;
  @HiveField(2)
  String? updatedAt;
  @HiveField(3)
  String? terminalId;
  @HiveField(4)
  String? name;
  @HiveField(5)
  String? desc;
  @HiveField(6)
  String? nameUz;
  @HiveField(7)
  String? descUz;
  @HiveField(8)
  Null nameEn;
  @HiveField(9)
  Null descEn;
  @HiveField(10)
  String? deliveryTime;
  @HiveField(11)
  String? pickupTime;
  @HiveField(12)
   String? latitude;
  @HiveField(13)
   String? longitude;
  @HiveField(14)
  String? openWork;
  @HiveField(15)
  String? closeWork;
  @HiveField(16)
  String? openWeekend;
  @HiveField(17)
  String? closeWeekend;
  @HiveField(18)
  String? tgGroup;
  @HiveField(19)
  bool? active;
  @HiveField(20)
  Null location;
  @HiveField(21)
  String? deliveryType;
  @HiveField(22)
  bool? paymeActive;
  @HiveField(23)
  bool? paymeTestMode;
  @HiveField(24)
  String? paymeMerchantId;
  @HiveField(25)
  String? paymeSecureKey;
  @HiveField(26)
  String? paymeSecureKeyTest;
  @HiveField(27)
  String? paymePrint;
  @HiveField(28)
  Null paymeCallbackTime;
  @HiveField(29)
  bool? clickActive;
  @HiveField(30)
  String? clickMerchantServiceId;
  @HiveField(31)
  String? clickMerchantUserId;
  @HiveField(32)
  String? clickSecretKey;
  @HiveField(33)
  String? clickMerchantId;
  @HiveField(34)
  int? cityId;
  @HiveField(35)
  bool? isWorking;

  Terminals(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.terminalId,
      required this.name,
      required this.desc,
      this.nameUz,
      this.descUz,
      this.nameEn,
      this.descEn,
      this.deliveryTime,
      this.pickupTime,
      required this.latitude,
      required this.longitude,
      required this.openWork,
      required this.closeWork,
      this.openWeekend,
      this.closeWeekend,
      required this.tgGroup,
      required this.active,
      this.location,
      required this.deliveryType,
      required this.paymeActive,
      required this.paymeTestMode,
      required this.paymeMerchantId,
      required this.paymeSecureKey,
      required this.paymeSecureKeyTest,
      required this.paymePrint,
      this.paymeCallbackTime,
      required this.clickActive,
      required this.clickMerchantServiceId,
      required this.clickMerchantUserId,
      required this.clickSecretKey,
      required this.clickMerchantId,
      required this.cityId,
      this.isWorking});

  Terminals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    terminalId = json['terminal_id'];
    name = json['name'];
    desc = json['desc'];
    nameUz = json['name_uz'];
    descUz = json['desc_uz'];
    nameEn = json['name_en'];
    descEn = json['desc_en'];
    deliveryTime = json['delivery_time'];
    pickupTime = json['pickup_time'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    openWork = json['open_work'];
    closeWork = json['close_work'];
    openWeekend = json['open_weekend'];
    closeWeekend = json['close_weekend'];
    tgGroup = json['tg_group'];
    active = json['active'];
    location = json['location'];
    deliveryType = json['delivery_type'];
    paymeActive = json['payme_active'];
    paymeTestMode = json['payme_test_mode'];
    paymeMerchantId = json['payme_merchant_id'];
    paymeSecureKey = json['payme_secure_key'];
    paymeSecureKeyTest = json['payme_secure_key_test'];
    paymePrint = json['payme_print'];
    paymeCallbackTime = json['payme_callback_time'];
    clickActive = json['click_active'];
    clickMerchantServiceId = json['click_merchant_service_id'];
    clickMerchantUserId = json['click_merchant_user_id'];
    clickSecretKey = json['click_secret_key'];
    clickMerchantId = json['click_merchant_id'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['terminal_id'] = this.terminalId;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['name_uz'] = this.nameUz;
    data['desc_uz'] = this.descUz;
    data['name_en'] = this.nameEn;
    data['desc_en'] = this.descEn;
    data['delivery_time'] = this.deliveryTime;
    data['pickup_time'] = this.pickupTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['open_work'] = this.openWork;
    data['close_work'] = this.closeWork;
    data['open_weekend'] = this.openWeekend;
    data['close_weekend'] = this.closeWeekend;
    data['tg_group'] = this.tgGroup;
    data['active'] = this.active;
    data['location'] = this.location;
    data['delivery_type'] = this.deliveryType;
    data['payme_active'] = this.paymeActive;
    data['payme_test_mode'] = this.paymeTestMode;
    data['payme_merchant_id'] = this.paymeMerchantId;
    data['payme_secure_key'] = this.paymeSecureKey;
    data['payme_secure_key_test'] = this.paymeSecureKeyTest;
    data['payme_print'] = this.paymePrint;
    data['payme_callback_time'] = this.paymeCallbackTime;
    data['click_active'] = this.clickActive;
    data['click_merchant_service_id'] = this.clickMerchantServiceId;
    data['click_merchant_user_id'] = this.clickMerchantUserId;
    data['click_secret_key'] = this.clickSecretKey;
    data['click_merchant_id'] = this.clickMerchantId;
    data['city_id'] = this.cityId;
    return data;
  }
}
