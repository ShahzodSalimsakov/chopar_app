class YandexGeoData {
  late String formatted;
  late String title;
  late String description;
  List<AddressItems>? addressItems;
  late Coords coordinates;

  YandexGeoData({required this.formatted, this.addressItems, required this.title, required this.description, required this.coordinates});

  YandexGeoData.fromJson(Map<String, dynamic> json) {
    formatted = json['formatted'];
    title = json['title'];
    description = json['description'];
    coordinates = new Coords.fromJson(json['coordinates']);
    if (json['addressItems'] != null) {
      addressItems = json['addressItems']
          .map<AddressItems>((m) => new AddressItems.fromJson(m))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formatted'] = this.formatted;
    data['title'] = this.title;
    data['description'] = this.description;
    data['coordinates'] = this.coordinates.toJson();
    if (this.addressItems != null) {
      data['addressItems'] = this.addressItems?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressItems {
  late String kind;
  late String name;

  AddressItems({required this.kind, required this.name});

  AddressItems.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['name'] = this.name;
    return data;
  }
}

class Coords {
  late String long;
  late String lat;

  Coords({required this.long, required this.lat});

  Coords.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long'] = this.long;
    data['lat'] = this.lat;
    return data;
  }
}
