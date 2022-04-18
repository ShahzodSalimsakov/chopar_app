class RelatedProduct {
  RelatedProduct({
    required this.id,
    required this.attributeData,
    required this.optionData,
    required this.createdAt,
    required this.updatedAt,
     this.deletedAt,
    required this.productFamilyId,
     this.layoutId,
    required this.groupPricing,
     this.draftedAt,
     this.draftParentId,
    required this.customName,
     this.productId,
     this.customNameUz,
    required this.active,
     this.modifierProdId,
     this.boxId,
    required this.sort,
    required this.weight,
     this.additionalSales,
    required this.price,
    required this.image,
    required this.variants,
  });
  late final int id;
  late final AttributeData attributeData;
  late final List<dynamic> optionData;
  late final String createdAt;
  late final String updatedAt;
  late final Null deletedAt;
  late final int productFamilyId;
  late final Null layoutId;
  late final int groupPricing;
  late final Null draftedAt;
  late final Null draftParentId;
  late final String customName;
  late final Null productId;
  late final Null customNameUz;
  late final int active;
  late final Null modifierProdId;
  late final Null boxId;
  late final int? sort;
  late final int weight;
  late final Null additionalSales;
  late final String price;
  late final String image;
  late final List<dynamic> variants;
  
  RelatedProduct.fromJson(Map<String, dynamic> json){
    id = json['id'];
    attributeData = AttributeData.fromJson(json['attribute_data']);
    optionData = List.castFrom<dynamic, dynamic>(json['option_data']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = null;
    productFamilyId = json['product_family_id'];
    layoutId = null;
    groupPricing = json['group_pricing'];
    draftedAt = null;
    draftParentId = null;
    customName = json['custom_name'];
    productId = null;
    customNameUz = null;
    active = json['active'];
    modifierProdId = null;
    boxId = null;
    sort = json['sort'];
    weight = json['weight'];
    additionalSales = null;
    price = json['price'];
    image = json['image'];
    variants = List.castFrom<dynamic, dynamic>(json['variants']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['attribute_data'] = attributeData.toJson();
    _data['option_data'] = optionData;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    _data['product_family_id'] = productFamilyId;
    _data['layout_id'] = layoutId;
    _data['group_pricing'] = groupPricing;
    _data['drafted_at'] = draftedAt;
    _data['draft_parent_id'] = draftParentId;
    _data['custom_name'] = customName;
    _data['product_id'] = productId;
    _data['custom_name_uz'] = customNameUz;
    _data['active'] = active;
    _data['modifier_prod_id'] = modifierProdId;
    _data['box_id'] = boxId;
    _data['sort'] = sort;
    _data['weight'] = weight;
    _data['additional_sales'] = additionalSales;
    _data['price'] = price;
    _data['image'] = image;
    _data['variants'] = variants;
    return _data;
  }
}

class AttributeData {
  AttributeData({
    required this.name,
    required this.xmlId,
    required this.description,
  });
  late final Name name;
  late final XmlId xmlId;
  late final Description description;
  
  AttributeData.fromJson(Map<String, dynamic> json){
    name = Name.fromJson(json['name']);
    xmlId = XmlId.fromJson(json['xml_id']);
    description = Description.fromJson(json['description']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name.toJson();
    _data['xml_id'] = xmlId.toJson();
    _data['description'] = description.toJson();
    return _data;
  }
}

class Name {
  Name({
    required this.chopar,
  });
  late final Chopar chopar;
  
  Name.fromJson(Map<String, dynamic> json){
    chopar = Chopar.fromJson(json['chopar']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['chopar'] = chopar.toJson();
    return _data;
  }
}

class Chopar {
  Chopar({
    required this.en,
    required this.ru,
    required this.uz,
  });
  late final String? en;
  late final String? ru;
  late final String? uz;
  
  Chopar.fromJson(Map<String, dynamic> json){
    en = json['en'];
    ru = json['ru'];
    uz = json['uz'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['en'] = en;
    _data['ru'] = ru;
    _data['uz'] = uz;
    return _data;
  }
}

class XmlId {
  XmlId({
    required this.chopar,
  });
  late final Chopar chopar;
  
  XmlId.fromJson(Map<String, dynamic> json){
    chopar = Chopar.fromJson(json['chopar']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['chopar'] = chopar.toJson();
    return _data;
  }
}

class Description {
  Description({
    required this.chopar,
  });
  late final Chopar chopar;
  
  Description.fromJson(Map<String, dynamic> json){
    chopar = Chopar.fromJson(json['chopar']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['chopar'] = chopar.toJson();
    return _data;
  }
}