class ProductSection {
  late int id;
  AttributeData? attributeData;
  late int iLft;
  late int iRgt;
  Null parentId;
  late String createdAt;
  late String updatedAt;
  late String sort;
  Null layoutId;
  Null draftedAt;
  Null draftParentId;
  late int active;
  late int halfMode;
  List<Items>? items;

  ProductSection(
      {required this.id,
      this.attributeData,
      required this.iLft,
      required this.iRgt,
      this.parentId,
      required this.createdAt,
      required this.updatedAt,
      required this.sort,
      this.layoutId,
      this.draftedAt,
      this.draftParentId,
      required this.active,
      required this.halfMode,
      this.items});

  ProductSection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeData = json['attribute_data'] != null
        ? new AttributeData.fromJson(json['attribute_data'])
        : null;
    iLft = json['_lft'];
    iRgt = json['_rgt'];
    parentId = json['parent_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sort = json['sort'];
    layoutId = json['layout_id'];
    draftedAt = json['drafted_at'];
    draftParentId = json['draft_parent_id'];
    active = json['active'];
    halfMode = json['half_mode'];
    if (json['items'] != null) {
      items = json['items'].map<Items>((m) => new Items.fromJson(m)).toList();
      // json['items'].forEach((v) {
      //   items?.add(new Items.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributeData != null) {
      data['attribute_data'] = this.attributeData?.toJson();
    }
    data['_lft'] = this.iLft;
    data['_rgt'] = this.iRgt;
    data['parent_id'] = this.parentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sort'] = this.sort;
    data['layout_id'] = this.layoutId;
    data['drafted_at'] = this.draftedAt;
    data['draft_parent_id'] = this.draftParentId;
    data['active'] = this.active;
    data['half_mode'] = this.halfMode;
    if (this.items != null) {
      data['items'] = this.items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttributeData {
  Name? name;
  Name? xmlId;
  Name? description;

  AttributeData({this.name, this.xmlId, this.description});

  AttributeData.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    xmlId = json['xml_id'] != null ? new Name.fromJson(json['xml_id']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name?.toJson();
    }
    if (this.xmlId != null) {
      data['xml_id'] = this.xmlId?.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description?.toJson();
    }
    return data;
  }
}

class Chopar {
  String? ru;
  String? uz;
  String? val;

  Chopar({this.ru, this.uz, this.val});

  Chopar.fromJson(Map<String, dynamic> json) {
    ru = json['ru'] != null ? json['ru'] : null;
    uz = json['uz'] != null ? json['uz'] : null;
    val = json['val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ru'] = this.ru;
    data['uz'] = this.uz;
    data['val'] = this.val;
    return data;
  }
}

class Items {
  late int id;
  AttributeData? attributeData;
  List<Map<String, dynamic>>? optionData;
  late String createdAt;
  late String updatedAt;
  Null deletedAt;
  late int productFamilyId;
  Null layoutId;
  late int groupPricing;
  Null draftedAt;
  Null draftParentId;
  late String customName;
  Null productId;
  Null customNameUz;
  late int active;
  Null modifierProdId;
  late String price;
  late String? image;
  List<Variants>? variants;
  List<Modifiers>? modifiers;

  Items(
      {required this.id,
      this.attributeData,
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
      required this.price,
      required this.image,
      this.variants,
      this.modifiers});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeData = json['attribute_data'] != null
        ? new AttributeData.fromJson(json['attribute_data'])
        : null;
    if (json['option_data'] != null) {
      optionData = new List<Map<String, dynamic>>.empty();
      // json['option_data'].forEach((v) {
      //   optionData?.add(new Map<String, dynamic>.fromJson(v));
      // });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    productFamilyId = json['product_family_id'];
    layoutId = json['layout_id'];
    groupPricing = json['group_pricing'];
    draftedAt = json['drafted_at'];
    draftParentId = json['draft_parent_id'];
    customName = json['custom_name'];
    productId = json['product_id'];
    customNameUz = json['custom_name_uz'];
    active = json['active'];
    modifierProdId = json['modifier_prod_id'];
    price = json['price'];
    image = json['image'];
    if (json['variants'] != null) {
      variants = json['variants']
          .map<Variants>((m) => new Variants.fromJson(m))
          .toList();
      // json['variants'].forEach((v) {
      //   variants?.add(new Variants.fromJson(v));
      // });
    }
    if (json['modifiers'] != null) {
      modifiers = json['modifiers']
          .map<Modifiers>((m) => new Modifiers.fromJson(m))
          .toList();
      // json['variants'].forEach((v) {
      //   variants?.add(new Variants.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributeData != null) {
      data['attribute_data'] = this.attributeData?.toJson();
    }
    // if (this.optionData != null) {
    //   data['option_data'] = this.optionData.map((v) => v.toJson()).toList();
    // }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['product_family_id'] = this.productFamilyId;
    data['layout_id'] = this.layoutId;
    data['group_pricing'] = this.groupPricing;
    data['drafted_at'] = this.draftedAt;
    data['draft_parent_id'] = this.draftParentId;
    data['custom_name'] = this.customName;
    data['product_id'] = this.productId;
    data['custom_name_uz'] = this.customNameUz;
    data['active'] = this.active;
    data['modifier_prod_id'] = this.modifierProdId;
    data['price'] = this.price;
    data['image'] = this.image;
    if (this.variants != null) {
      data['variants'] = this.variants?.map((v) => v.toJson()).toList();
    }
    if (this.modifiers != null) {
      data['modifiers'] = this.modifiers?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variants {
  late int id;
  AttributeData? attributeData;
  List<Map<String, dynamic>>? optionData;
  late String createdAt;
  late String updatedAt;
  Null deletedAt;
  late int productFamilyId;
  Null layoutId;
  late int groupPricing;
  Null draftedAt;
  Null draftParentId;
  late String customName;
  late int productId;
  late String customNameUz;
  late int active;
  int? modifierProdId;
  late String price;
  late String? image;
  List<Modifiers>? modifiers;
  List<Map<String, dynamic>>? variants;
  ModifierProduct? modifierProduct;

  Variants(
      {required this.id,
      this.attributeData,
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
      required this.productId,
      required this.customNameUz,
      required this.active,
      this.modifierProdId,
      required this.price,
      required this.image,
      this.modifiers,
      this.variants,
      this.modifierProduct});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeData = json['attribute_data'] != null
        ? new AttributeData.fromJson(json['attribute_data'])
        : null;
    if (json['option_data'] != null) {
      optionData = new List<Map<String, dynamic>>.empty();
      // json['option_data'].forEach((v) {
      //   optionData.add(new Null.fromJson(v));
      // });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    productFamilyId = json['product_family_id'];
    layoutId = json['layout_id'];
    groupPricing = json['group_pricing'];
    draftedAt = json['drafted_at'];
    draftParentId = json['draft_parent_id'];
    customName = json['custom_name'];
    productId = json['product_id'];
    customNameUz = json['custom_name_uz'];
    active = json['active'];
    modifierProdId =
        json['modifier_prod_id'] != null ? json['modifier_prod_id'] : null;
    price = json['price'];
    image = json['image'];
    if (json['modifiers'] != null) {
      modifiers = json['modifiers']
          .map<Modifiers>((m) => new Modifiers.fromJson(m))
          .toList();
      // json['modifiers'].forEach((v) {
      //   modifiers?.add(new Modifiers.fromJson(v));
      // });
    }
    if (json['variants'] != null) {
      variants = new List<Map<String, dynamic>>.empty();
      // json['variants'].forEach((v) {
      //   variants.add(new Null.fromJson(v));
      // });
    }
    modifierProduct = json['modifierProduct'] != null
        ? new ModifierProduct.fromJson(json['modifierProduct'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributeData != null) {
      data['attribute_data'] = this.attributeData?.toJson();
    }
    if (this.optionData != null) {
      // data['option_data'] = this.optionData.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['product_family_id'] = this.productFamilyId;
    data['layout_id'] = this.layoutId;
    data['group_pricing'] = this.groupPricing;
    data['drafted_at'] = this.draftedAt;
    data['draft_parent_id'] = this.draftParentId;
    data['custom_name'] = this.customName;
    data['product_id'] = this.productId;
    data['custom_name_uz'] = this.customNameUz;
    data['active'] = this.active;
    data['modifier_prod_id'] = this.modifierProdId;
    data['price'] = this.price;
    data['image'] = this.image;
    if (this.modifiers != null) {
      data['modifiers'] = this.modifiers?.map((v) => v.toJson()).toList();
    }
    if (this.variants != null) {
      // data['variants'] = this.variants?.map((v) => v.toJson()).toList();
    }
    if (this.modifierProduct != null) {
      data['modifierProduct'] = this.modifierProduct?.toJson();
    }
    return data;
  }
}

class Name {
  late String? ru;
  late Chopar? chopar;

  Name({this.ru, this.chopar});

  Name.fromJson(Map<String, dynamic> json) {
    ru = json['ru'] != null ? json['ru'] : null;
    chopar =
        json['chopar'] != null ? new Chopar.fromJson(json['chopar']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ru'] = this.ru;
    if (this.chopar != null) {
      data['chopar'] = this.chopar?.toJson();
    }
    return data;
  }
}

class Modifiers {
  late int id;
  late String createdAt;
  late String updatedAt;
  late String name;
  late String xmlId;
  late int price;
  late int weight;
  late String groupId;
  late String nameUz;
  List<Assets>? assets;

  Modifiers(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.xmlId,
      required this.price,
      required this.weight,
      required this.groupId,
      required this.nameUz,
      this.assets});

  Modifiers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    xmlId = json['xml_id'];
    price = json['price'];
    weight = json['weight'];
    groupId = json['groupId'];
    nameUz = json['name_uz'];
    if (json['assets'] != null) {
      assets =
          json['assets'].map<Assets>((m) => new Assets.fromJson(m)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['xml_id'] = this.xmlId;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['groupId'] = this.groupId;
    data['name_uz'] = this.nameUz;
    if (this.assets != null) {
      data['assets'] = this.assets?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assets {
  late int id;
  late int assetSourceId;
  late String location;
  late String kind;
  late String subKind;
  String? width;
  String? height;
  late String title;
  late String originalFilename;
  Null caption;
  late int size;
  late int external;
  late String extension;
  late String filename;
  late String createdAt;
  late String updatedAt;
  Pivot? pivot;

  Assets(
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
      this.pivot});

  Assets.fromJson(Map<String, dynamic> json) {
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
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot?.toJson();
    }
    return data;
  }
}

class Pivot {
  late int assetableId;
  late int assetId;
  late String position;
  late int primary;
  late String assetableType;
  late String createdAt;
  late String updatedAt;

  Pivot(
      {required this.assetableId,
      required this.assetId,
      required this.position,
      required this.primary,
      required this.assetableType,
      required this.createdAt,
      required this.updatedAt});

  Pivot.fromJson(Map<String, dynamic> json) {
    assetableId = json['assetable_id'];
    assetId = json['asset_id'];
    position = json['position'];
    primary = json['primary'];
    assetableType = json['assetable_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetable_id'] = this.assetableId;
    data['asset_id'] = this.assetId;
    data['position'] = this.position;
    data['primary'] = this.primary;
    data['assetable_type'] = this.assetableType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ModifierProduct {
  late int id;
  AttributeData? attributeData;
  List<Map<String, dynamic>>? optionData;
  late String createdAt;
  late String updatedAt;
  Null deletedAt;
  late int productFamilyId;
  Null layoutId;
  late int groupPricing;
  Null draftedAt;
  Null draftParentId;
  late String customName;
  Null productId;
  Null customNameUz;
  late int active;
  Null modifierProdId;
  late String price;
  late String image;
  List<Modifiers>? modifiers;

  ModifierProduct(
      {required this.id,
      this.attributeData,
      this.optionData,
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
      required this.price,
      required this.image,
      this.modifiers});

  ModifierProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeData = json['attribute_data'] != null
        ? new AttributeData.fromJson(json['attribute_data'])
        : null;
    if (json['option_data'] != null) {
      optionData = new List<Map<String, dynamic>>.empty();
      // json['option_data'].forEach((v) {
      //   optionData.add(new Null.fromJson(v));
      // });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    productFamilyId = json['product_family_id'];
    layoutId = json['layout_id'];
    groupPricing = json['group_pricing'];
    draftedAt = json['drafted_at'];
    draftParentId = json['draft_parent_id'];
    customName = json['custom_name'];
    productId = json['product_id'];
    customNameUz = json['custom_name_uz'];
    active = json['active'];
    modifierProdId = json['modifier_prod_id'];
    price = json['price'];
    image = json['image'];
    if (json['modifiers'] != null) {
      modifiers = json['modifiers']
          .map<Modifiers>((m) => new Modifiers.fromJson(m))
          .toList();
      // json['modifiers'].forEach((v) {
      //   modifiers?.add(new Modifiers.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributeData != null) {
      data['attribute_data'] = this.attributeData?.toJson();
    }
    if (this.optionData != null) {
      // data['option_data'] = this.optionData.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['product_family_id'] = this.productFamilyId;
    data['layout_id'] = this.layoutId;
    data['group_pricing'] = this.groupPricing;
    data['drafted_at'] = this.draftedAt;
    data['draft_parent_id'] = this.draftParentId;
    data['custom_name'] = this.customName;
    data['product_id'] = this.productId;
    data['custom_name_uz'] = this.customNameUz;
    data['active'] = this.active;
    data['modifier_prod_id'] = this.modifierProdId;
    data['price'] = this.price;
    data['image'] = this.image;
    if (this.modifiers != null) {
      data['modifiers'] = this.modifiers?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
