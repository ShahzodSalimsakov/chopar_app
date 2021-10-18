class News {
  final id;
  final name;
  final active;
  final nameUz;
  final sort;
  final description;
  final descriptionUz;
  final cityId;
  final asset;

  News(
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

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        id: json['id'],
        name: json['name'],
        active: json['active'],
        nameUz: json['nameUz'],
        sort: json['sort'],
        description: json['description'],
        descriptionUz: json['descriptionUz'],
        cityId: json['cityId'],
        asset: json['assets']);
  }
}
