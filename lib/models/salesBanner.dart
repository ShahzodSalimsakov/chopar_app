class SalesBanner {
  late int id;
  late bool active;
  late String title;
  String? link;
  String? buttonTitle;
  String? description;
  late int sort;
  int? cityId;
  late String locale;
  late List<Asset> asset;

  SalesBanner(
      {required this.id,
      required this.active,
      required this.title,
      this.link,
      this.buttonTitle,
      this.description,
      required this.sort,
      this.cityId,
      required this.locale,
      required this.asset});

  SalesBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = json['active'];
    title = json['title'];
    link = json['link'];
    buttonTitle = json['button_title'];
    description = json['description'];
    sort = json['sort'];
    cityId = json['city_id'];
    locale = json['locale'];
    if (json['asset'] != null) {
      asset = <Asset>[];
      json['asset'].forEach((v) {
        asset.add(new Asset.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['active'] = this.active;
    data['title'] = this.title;
    data['link'] = this.link;
    data['button_title'] = this.buttonTitle;
    data['description'] = this.description;
    data['sort'] = this.sort;
    data['city_id'] = this.cityId;
    data['locale'] = this.locale;
    data['asset'] = this.asset.map((v) => v.toJson()).toList();
    return data;
  }
}

class Asset {
  late int id;
  late int assetSourceId;
  late String location;
  late String kind;
  late String subKind;
  String? width;
  String? height;
  late String title;
  late String originalFilename;
  String? caption;
  late int size;
  late int external;
  late String extension;
  late String filename;
  late String createdAt;
  late String updatedAt;
  late int assetableId;
  late int assetId;
  late String link;

  Asset(
      {required this.id,
      required this.assetSourceId,
      required this.location,
      required this.kind,
      required this.subKind,
      this.width,
      this.height,
      required this.title,
      required this.originalFilename,
      this.caption,
      required this.size,
      required this.external,
      required this.extension,
      required this.filename,
      required this.createdAt,
      required this.updatedAt,
      required this.assetableId,
      required this.assetId,
      required this.link});

  Asset.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetSourceId = json['asset_source_id'];
    location = json['location'];
    kind = json['kind'];
    subKind = json['sub_kind'];
    width = json['width'] != null ? json['width'] : null;
    height = json['height'] != null ? json['height'] : null;
    title = json['title'];
    originalFilename = json['original_filename'];
    caption = json['caption'];
    size = json['size'];
    external = json['external'];
    extension = json['extension'];
    filename = json['filename'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    assetableId = json['assetable_id'];
    assetId = json['asset_id'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['asset_source_id'] = this.assetSourceId;
    data['location'] = this.location;
    data['kind'] = this.kind;
    data['sub_kind'] = this.subKind;
    data['width'] = this.width;
    data['height'] = this.height;
    data['title'] = this.title;
    data['original_filename'] = this.originalFilename;
    data['caption'] = this.caption;
    data['size'] = this.size;
    data['external'] = this.external;
    data['extension'] = this.extension;
    data['filename'] = this.filename;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['assetable_id'] = this.assetableId;
    data['asset_id'] = this.assetId;
    data['link'] = this.link;
    return data;
  }
}
