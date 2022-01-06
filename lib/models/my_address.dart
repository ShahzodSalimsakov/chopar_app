class MyAddress {
  late int id;
  late String addressableType;
  late int addressableId;
  late String firstname;
  late String lastname;
  late String phone;
  late String? email;
  late String? address;
  late String? addressThree;
  late String city;
  late String state;
  late String? postalCode;
  late int countryId;
  late int shipping;
  late int billing;
  late String? deliveryInstructions;
  late String createdAt;
  late String updatedAt;
  late String? lat;
  late String? lon;
  late String? label;
  late String? flat;
  late String? house;
  late String? entrance;
  late String? doorCode;
  late String? floor;

  MyAddress(
      {required this.id,
      required this.addressableType,
      required this.addressableId,
      required this.firstname,
      required this.lastname,
      required this.phone,
      this.email,
      this.address,
      this.addressThree,
      required this.city,
      required this.state,
      this.postalCode,
      required this.countryId,
      required this.shipping,
      required this.billing,
      this.deliveryInstructions,
      required this.createdAt,
      required this.updatedAt,
      this.lat,
      this.lon,
      this.label,
      this.flat,
      this.house,
      this.entrance,
      this.doorCode,
      this.floor});

  MyAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressableType = json['addressable_type'];
    addressableId = json['addressable_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    addressThree = json['address_three'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postal_code'];
    countryId = json['country_id'];
    shipping = json['shipping'];
    billing = json['billing'];
    deliveryInstructions = json['delivery_instructions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lat = json['lat'];
    lon = json['lon'];
    label = json['label'];
    flat = json['flat'];
    house = json['house'];
    entrance = json['entrance'];
    doorCode = json['door_code'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressable_type'] = this.addressableType;
    data['addressable_id'] = this.addressableId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['address_three'] = this.addressThree;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postal_code'] = this.postalCode;
    data['country_id'] = this.countryId;
    data['shipping'] = this.shipping;
    data['billing'] = this.billing;
    data['delivery_instructions'] = this.deliveryInstructions;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['label'] = this.label;
    data['flat'] = this.flat;
    data['house'] = this.house;
    data['entrance'] = this.entrance;
    data['door_code'] = this.doorCode;
    data['floor'] = this.floor;
    return data;
  }
}
