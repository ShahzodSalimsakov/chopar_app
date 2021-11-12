class Sales {
  final id;
  final name;
  final active;
  final nameUz;
  final sort;
  final description;
  final descriptionUz;
  final cityId;
  final List<Asset>? asset;

  Sales(
      {required this.id,
      required this.name,
      required this.active,
      required this.nameUz,
      required this.sort,
      required this.description,
      required this.descriptionUz,
      required this.cityId,
      required this.asset

      });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
        id: json['id'],
        name: json['name'],
        active: json['active'],
        nameUz: json['nameUz'],
        sort: json['sort'],
        description: json['description'],
        descriptionUz: json['descriptionUz'],
        cityId: json['cityId'],
        asset: json['asset'] != null ? json['asset'].map<Asset>((m) => new Asset.fromJson(m)).toList() : null
    );
  }
}

class Asset {
  late int id;
  late int assetSourceId;
  late String location;
  late String kind;
  late String subKind;
  late String width;
  late String height;
  late String title;
  late String originalFilename;
  late int size;
  late int external;
  late String extension;
  late String filename;
  late String createdAt;
  late String updatedAt;
  late int assetId;
  late String link;

  Asset(
      {required this.id,
        required this.assetSourceId,
        required this.location,
        required this.kind,
        required this.subKind,
        required this.width,
        required this.height,
        required this.title,
        required this.originalFilename,
        required this.size,
        required this.external,
        required this.extension,
        required this.filename,
        required this.createdAt,
        required this.updatedAt,
        required this.assetId,
        required this.link});

  Asset.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetSourceId = json['asset_source_id'];
    location = json['location'];
    kind = json['kind'];
    subKind = json['sub_kind'];
    width = json['width'];
    height = json['height'];
    title = json['title'];
    originalFilename = json['original_filename'];
    size = json['size'];
    external = json['external'];
    extension = json['extension'];
    filename = json['filename'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['size'] = this.size;
    data['external'] = this.external;
    data['extension'] = this.extension;
    data['filename'] = this.filename;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['asset_id'] = this.assetId;
    data['link'] = this.link;
    return data;
  }
}
