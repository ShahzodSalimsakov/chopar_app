class Terminals {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? terminalId;
  String? name;
  String? desc;
  String? nameUz;
  String? descUz;
  Null nameEn;
  Null descEn;
  String? deliveryTime;
  String? pickupTime;
   String? latitude;
   String? longitude;
  String? openWork;
  String? closeWork;
  String? openWeekend;
  String? closeWeekend;
  String? tgGroup;
  bool? active;
  Null location;
  String? deliveryType;
  bool? paymeActive;
  bool? paymeTestMode;
  String? paymeMerchantId;
  String? paymeSecureKey;
  String? paymeSecureKeyTest;
  String? paymePrint;
  Null paymeCallbackTime;
  bool? clickActive;
  String? clickMerchantServiceId;
  String? clickMerchantUserId;
  String? clickSecretKey;
  String? clickMerchantId;
  int? cityId;

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
      required this.cityId});

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
