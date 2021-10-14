class Sales {
  final id;
  final name;
  final active;
  final nameUz;
  final sort;
  final description;
  final descriptionUz;
  final cityId;
  final asset;

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
        asset: json['assets']);
  }
}
