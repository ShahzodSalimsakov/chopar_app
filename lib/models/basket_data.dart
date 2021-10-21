import 'dart:convert';

import 'package:chopar_app/models/product_section.dart';

// import 'order.dart';

class BasketData {
  late int id;
  int? userId;
  Null mergedId;
  String? completedAt;
  late String currency;
  late String createdAt;
  late String updatedAt;
  Null otp;
  Null order;
  List<Lines>? lines;
  late int total;
  late int subTotal;
  String? encodedId;

  BasketData(
      {required this.id, this.userId, this.mergedId, this.completedAt, required this.currency, required this.createdAt, required this.updatedAt, this.otp, this.order, this.lines, required this.total, required this.subTotal, this.encodedId});

  BasketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    mergedId = json['merged_id'];
    completedAt = json['completed_at'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'];
    order = json['order'];
    if (json['lines'] != null) {
      lines = json['lines'].map<Lines>((m) => new Lines.fromJson(m)).toList();
    }
    total = json['total'];
    subTotal = json['sub_total'];
    encodedId = json['encoded_id'] != null ? json['encoded_id'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['merged_id'] = this.mergedId;
    data['completed_at'] = this.completedAt;
    data['currency'] = this.currency;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['otp'] = this.otp;
    data['order'] = this.order;
    if (this.lines != null) {
      data['lines'] = this.lines?.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['sub_total'] = this.subTotal;
    if (this.encodedId != null) {
      data['encoded_id'] = this.encodedId;
    }
    return data;
  }
}

class Lines {
  late int id;
  late int basketId;
  late int productVariantId;
  late int quantity;
  late String total;
  late String createdAt;
  late String updatedAt;
  List<BasketModifiers>? modifiers;
  String? parentId;
  Variant? variant;
  List<Child>? child;

  Lines(
      {required this.id, required this.basketId, required this.productVariantId, required this.quantity, required this.total, required this.createdAt, required this.updatedAt, this.modifiers, this.parentId, this.variant, this.child});

  Lines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basketId = json['basket_id'];
    productVariantId = json['product_variant_id'];
    quantity = json['quantity'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['modifiers'] != null) {
      if (json['modifiers'] is String) {
        modifiers = jsonDecode(json['modifiers']).map<BasketModifiers>((m) => new BasketModifiers.fromJson(m)).toList();
      } else {
        modifiers = json['modifiers'].map<BasketModifiers>((m) => new BasketModifiers.fromJson(m)).toList();
      }


    }
    parentId = json['parent_id'];
    if (json['variant'] != null) {
      variant = new Variant.fromJson(json['variant']);
    }
    if (json['child'] != null) {
      child = json['child'].map<Child>((m) => new Child.fromJson(m)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['basket_id'] = this.basketId;
    data['product_variant_id'] = this.productVariantId;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.modifiers != null) {
      data['modifiers'] = this.modifiers?.map((v) => v.toJson()).toList();
    }
    data['parent_id'] = this.parentId;
    if (this.variant != null) {
      data['variant'] = this.variant?.toJson();
    }
    if (this.child != null) {
      data['child'] = this.child?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BasketModifiers {
  late int id;
  late String createdAt;
  late String updatedAt;
  late String name;
  late String xmlId;
  late int price;
  late int weight;
  late String groupId;
  late String nameUz;

  BasketModifiers(
      {required this.id, required this.createdAt, required this.updatedAt, required this.name, required this.xmlId, required this.price, required this.weight, required this.groupId, required this.nameUz});

  BasketModifiers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    xmlId = json['xml_id'];
    price = json['price'];
    weight = json['weight'];
    groupId = json['groupId'];
    nameUz = json['name_uz'];
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
    return data;
  }
}

class Variant {
  late int id;
  late int productId;
  late String sku;
  late int price;
  late int unitQty;
  late int minQty;
  late int minBatch;
  late int maxQty;
  late int stock;
  late int incoming;
  late String backorder;
  late int requiresShipping;
  late String weightValue;
  late String weightUnit;
  late String heightValue;
  late String heightUnit;
  late String widthValue;
  late String widthUnit;
  late String depthValue;
  late String depthUnit;
  late String volumeValue;
  late String volumeUnit;
  late String createdAt;
  late String updatedAt;
  int? assetId;
  late int taxId;
  late int groupPricing;
  late int qty;
  late int factorTax;
  late int unitTax;
  late int unitCost;
  late int totalTax;
  late int baseCost;
  late int totalPrice;
  late int origialPrice;
  int? unitPrice;
  Product? product;

  Variant(
      {required this.id, required this.productId, required this.sku, required this.price, required this.unitQty, required this.minQty, required this.minBatch, required this.maxQty, required this.stock, required this.incoming, required this.backorder, required this.requiresShipping, required this.weightValue, required this.weightUnit, required this.heightValue, required this.heightUnit, required this.widthValue, required this.widthUnit, required this.depthValue, required this.depthUnit, required this.volumeValue, required this.volumeUnit, required this.createdAt, required this.updatedAt, this.assetId, required this.taxId, required this.groupPricing, required this.qty, required this.factorTax, required this.unitTax, required this.unitCost, required this.totalTax, required this.baseCost, required this.totalPrice, required this.origialPrice, this.unitPrice, this.product});

  Variant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    sku = json['sku'];
    price = json['price'];
    unitQty = json['unit_qty'];
    minQty = json['min_qty'];
    minBatch = json['min_batch'];
    maxQty = json['max_qty'];
    stock = json['stock'];
    incoming = json['incoming'];
    backorder = json['backorder'];
    requiresShipping = json['requires_shipping'];
    weightValue = json['weight_value'];
    weightUnit = json['weight_unit'];
    heightValue = json['height_value'];
    heightUnit = json['height_unit'];
    widthValue = json['width_value'];
    widthUnit = json['width_unit'];
    depthValue = json['depth_value'];
    depthUnit = json['depth_unit'];
    volumeValue = json['volume_value'];
    volumeUnit = json['volume_unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    assetId = json['asset_id'];
    taxId = json['tax_id'];
    groupPricing = json['group_pricing'];
    qty = json['qty'];
    factorTax = json['factor_tax'];
    unitTax = json['unit_tax'];
    unitCost = json['unit_cost'];
    totalTax = json['total_tax'];
    baseCost = json['base_cost'];
    totalPrice = json['total_price'];
    origialPrice = json['origial_price'];
    unitPrice = json['unit_price'] != null ? json['unit_price'] : 0;
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['unit_qty'] = this.unitQty;
    data['min_qty'] = this.minQty;
    data['min_batch'] = this.minBatch;
    data['max_qty'] = this.maxQty;
    data['stock'] = this.stock;
    data['incoming'] = this.incoming;
    data['backorder'] = this.backorder;
    data['requires_shipping'] = this.requiresShipping;
    data['weight_value'] = this.weightValue;
    data['weight_unit'] = this.weightUnit;
    data['height_value'] = this.heightValue;
    data['height_unit'] = this.heightUnit;
    data['width_value'] = this.widthValue;
    data['width_unit'] = this.widthUnit;
    data['depth_value'] = this.depthValue;
    data['depth_unit'] = this.depthUnit;
    data['volume_value'] = this.volumeValue;
    data['volume_unit'] = this.volumeUnit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['asset_id'] = this.assetId;
    data['tax_id'] = this.taxId;
    data['group_pricing'] = this.groupPricing;
    data['qty'] = this.qty;
    data['factor_tax'] = this.factorTax;
    data['unit_tax'] = this.unitTax;
    data['unit_cost'] = this.unitCost;
    data['total_tax'] = this.totalTax;
    data['base_cost'] = this.baseCost;
    data['total_price'] = this.totalPrice;
    data['origial_price'] = this.origialPrice;
    data['unit_price'] = this.unitPrice;
    if (this.product != null) {
      data['product'] = this.product?.toJson();
    }
    return data;
  }
}

class Product {
  late int id;
  AttributeData? attributeData;
  late String createdAt;
  late String updatedAt;
  late int productFamilyId;
  late int groupPricing;
  String? customName;
  int? productId;
  String? customNameUz;
  late int active;
  int? modifierProdId;
  int? boxId;
  List<Assets>? assets;

  Product(
      {required this.id, this.attributeData, required this.createdAt, required this.updatedAt, required this.productFamilyId, required this.groupPricing, this.customName, this.productId, this.customNameUz, required this.active, this.modifierProdId, this.boxId, this.assets});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeData = json['attribute_data'] != null ? AttributeData.fromJson(json['attribute_data']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productFamilyId = json['product_family_id'];
    groupPricing = json['group_pricing'];
    customName = json['custom_name'] != null ? json['custom_name'] : null;
    productId = json['product_id'] != null ? json['product_id'] : null;
    customNameUz = json['custom_name_uz'] != null ? json['custom_name_uz'] : null;
    active = json['active'];
    modifierProdId = json['modifier_prod_id'] != null ? json['modifier_prod_id'] : null;
    boxId = json['box_id'] != null ? json['box_id'] : null;
    if (json['assets'] != null) {
      assets = json['assets'].map<Assets>((m) => new Assets.fromJson(m)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributeData != null) {
      data['attribute_data'] = this.attributeData?.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_family_id'] = this.productFamilyId;
    data['group_pricing'] = this.groupPricing;
    data['custom_name'] = this.customName;
    data['product_id'] = this.productId;
    data['custom_name_uz'] = this.customNameUz;
    data['active'] = this.active;
    data['modifier_prod_id'] = this.modifierProdId;
    data['box_id'] = this.boxId;
    if (this.assets != null) {
      data['assets'] = this.assets?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  late int id;
  late int basketId;
  late int productVariantId;
  late int quantity;
  late String total;
  late String createdAt;
  late String updatedAt;
  List<BasketModifiers>? modifiers;
  late String parentId;
  Variant? variant;

  Child(
      {required this.id, required this.basketId, required this.productVariantId, required this.quantity, required this.total, required this.createdAt, required this.updatedAt, this.modifiers, required this.parentId, this.variant});

  Child.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basketId = json['basket_id'];
    productVariantId = json['product_variant_id'];
    quantity = json['quantity'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['modifiers'] != null) {
      modifiers = json['modifiers'].map<BasketModifiers>((m) => new BasketModifiers.fromJson(m)).toList();
    }
    parentId = json['parent_id'];
    variant =
    json['variant'] != null ? Variant.fromJson(json['variant']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['basket_id'] = this.basketId;
    data['product_variant_id'] = this.productVariantId;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.modifiers != null) {
      data['modifiers'] = this.modifiers?.map((v) => v.toJson()).toList();
    }
    data['parent_id'] = this.parentId;
    if (this.variant != null) {
      data['variant'] = this.variant?.toJson();
    }
    return data;
  }
}
