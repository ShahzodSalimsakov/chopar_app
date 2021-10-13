class City {
  late int id;
  late String xmlId;
  late String name;
  late String nameUz;
  late String mapZoom;
  late String lat;
  late String lon;
  late bool active;
  late int sort;
  late String phone;

  City(
      {required this.id,
        required this.xmlId,
        required this.name,
        required this.nameUz,
        required this.mapZoom,
        required this.lat,
        required this.lon,
        required this.active,
        required this.sort,
        required this.phone});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    xmlId = json['xml_id'];
    name = json['name'];
    nameUz = json['name_uz'];
    mapZoom = json['map_zoom'];
    lat = json['lat'];
    lon = json['lon'];
    active = json['active'];
    sort = json['sort'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['xml_id'] = this.xmlId;
    data['name'] = this.name;
    data['name_uz'] = this.nameUz;
    data['map_zoom'] = this.mapZoom;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['active'] = this.active;
    data['sort'] = this.sort;
    data['phone'] = this.phone;
    return data;
  }
}
