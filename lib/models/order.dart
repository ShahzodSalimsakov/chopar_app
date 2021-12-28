import 'package:chopar_app/models/product_section.dart';

class Order {
  late int id;
  late int basketId;
  late int userId;
  late int subTotal;
  late int deliveryTotal;
  late int discountTotal;
  late int taxTotal;
  late int orderTotal;
  Null shippingMethod;
  Null shippingPreference;
  late String status;
  late String type;
  String? notes;
  late String currency;
  String? billingPhone;
  String? billingEmail;
  Null shippingCompanyName;
  Null billingCompanyName;
  String? billingFirstname;
  String? billingLastname;
  String? billingAddress;
  String? billingAddressTwo;
  String? billingAddressThree;
  String? billingCity;
  Null billingCounty;
  String? billingState;
  Null billingCountry;
  Null billingZip;
  String? shippingPhone;
  String? shippingEmail;
  String? shippingFirstname;
  String? shippingLastname;
  String? shippingAddress;
  String? shippingAddressTwo;
  String? shippingAddressThree;
  String? shippingCity;
  Null shippingCounty;
  String? shippingState;
  Null shippingCountry;
  Null shippingZip;
  String? createdAt;
  String? updatedAt;
  Null contactEmail;
  String? contactPhone;
  Null vatNo;
  Null trackingNo;
  Null dispatchedAt;
  String? reference;
  Null customerReference;
  String? placedAt;
  String? conversion;
  // late List<Null> meta;
  int? terminalId;
  String? lat;
  String? lon;
  String? flat;
  String? house;
  String? entrance;
  String? doorCode;
  String? deliverySchedule;
  String? deliveryDay;
  String? deliveryTime;
  String? deliveryType;
  int? isPayed;
  String? iikoId;
  String? laterTime;
  OrderBasket? basket;
  TerminalData? terminalData;

  Order(
      {required this.id,
        required this.basketId,
        required this.userId,
        required this.subTotal,
        required this.deliveryTotal,
        required this.discountTotal,
        required this.taxTotal,
        required this.orderTotal,
        this.shippingMethod,
        this.shippingPreference,
        required this.status,
        required this.type,
        this.notes,
        required this.currency,
        this.billingPhone,
        this.billingEmail,
        this.shippingCompanyName,
        this.billingCompanyName,
        this.billingFirstname,
        this.billingLastname,
        this.billingAddress,
        this.billingAddressTwo,
        this.billingAddressThree,
        this.billingCity,
        this.billingCounty,
        this.billingState,
        this.billingCountry,
        this.billingZip,
        this.shippingPhone,
        this.shippingEmail,
        this.shippingFirstname,
        this.shippingLastname,
        this.shippingAddress,
        this.shippingAddressTwo,
        this.shippingAddressThree,
        this.shippingCity,
        this.shippingCounty,
        this.shippingState,
        this.shippingCountry,
        this.shippingZip,
        this.createdAt,
        this.updatedAt,
        this.contactEmail,
        this.contactPhone,
        this.vatNo,
        this.trackingNo,
        this.dispatchedAt,
        this.reference,
        this.customerReference,
        this.placedAt,
        this.conversion,
        // required this.meta,
        this.terminalId,
        this.lat,
        this.lon,
        this.flat,
        this.house,
        this.entrance,
        this.doorCode,
        this.deliverySchedule,
        this.deliveryDay,
        this.deliveryTime,
        this.deliveryType,
        this.isPayed,
        this.iikoId,
        this.laterTime,
        required this.basket,
        required this.terminalData});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basketId = json['basket_id'];
    userId = json['user_id'];
    subTotal = json['sub_total'];
    deliveryTotal = json['delivery_total'];
    discountTotal = json['discount_total'];
    taxTotal = json['tax_total'];
    orderTotal = json['order_total'];
    shippingMethod = json['shipping_method'];
    shippingPreference = json['shipping_preference'];
    status = json['status'];
    type = json['type'];
    notes = json['notes'] != null ? json['notes'] : '';
    currency = json['currency'];
    billingPhone = json['billing_phone'] != null ? json['billing_phone'] : '';
    billingEmail = json['billing_email'];
    shippingCompanyName = json['shipping_company_name'];
    billingCompanyName = json['billing_company_name'];
    billingFirstname = json['billing_firstname'] != null ? json['billing_firstname'] : '';
    billingLastname = json['billing_lastname'] != null ? json['billing_lastname'] : '';
    billingAddress = json['billing_address'] != null ? json['billing_address'] : '';
    billingAddressTwo = json['billing_address_two'] != null ? json['billing_address_two'] : '';
    billingAddressThree = json['billing_address_three'] != null ? json['billing_address_three'] : '';
    billingCity = json['billing_city'] != null ? json['billing_city'] : '';
    billingCounty = json['billing_county'];
    billingState = json['billing_state'] != null ? json['billing_state'] : '';
    billingCountry = json['billing_country'];
    billingZip = json['billing_zip'];
    shippingPhone = json['shipping_phone'] != null ? json['shipping_phone'] : '';
    shippingEmail = json['shipping_email'];
    shippingFirstname = json['shipping_firstname'] != null ? json['shipping_firstname'] : '';
    shippingLastname = json['shipping_lastname'] != null ? json['shipping_lastname'] : '';
    shippingAddress = json['shipping_address'] != null ? json['shipping_address'] : '';
    shippingAddressTwo = json['shipping_address_two'] != null ? json['shipping_address_two'] : '';
    shippingAddressThree = json['shipping_address_three'] != null ? json['shipping_address_three'] : '';
    shippingCity = json['shipping_city'] != null ? json['shipping_city'] : '';
    shippingCounty = json['shipping_county'];
    shippingState = json['shipping_state'] != null ? json['shipping_state'] : '';
    shippingCountry = json['shipping_country'];
    shippingZip = json['shipping_zip'];
    createdAt = json['created_at'] != null ? json['created_at'] : '';
    updatedAt = json['updated_at'] != null ? json['updated_at'] : '';
    contactEmail = json['contact_email'];
    contactPhone = json['contact_phone'] != null ? json['contact_phone'] : '';
    vatNo = json['vat_no'];
    trackingNo = json['tracking_no'];
    dispatchedAt = json['dispatched_at'];
    reference = json['reference'] != null ? json['reference'] : '';
    customerReference = json['customer_reference'];
    placedAt = json['placed_at'] != null ? json['placed_at'] : '';
    conversion = json['conversion'] != null ? json['conversion'] : '';
    // if (json['meta'] != null) {
    //   meta = new List<Null>.empty();
    //   json['meta'].forEach((v) {
    //     meta.add(Null);
    //   });
    // }
    terminalId = json['terminal_id'] != null ? json['terminal_id'] : 0;
    lat = json['lat'] != null ? json['lat'] : '';
    lon = json['lon'] != null ? json['lon'] : '';
    flat = json['flat'] != null ? json['flat'] : '';
    house = json['house'] != null ? json['house'] : '';
    entrance = json['entrance'] != null ? json['entrance'] : '';
    doorCode = json['door_code'] != null ? json['door_code'] : '';
    deliverySchedule = json['delivery_schedule'] != null ? json['delivery_schedule'] : '';
    deliveryDay = json['delivery_day'] != null ? json['delivery_day'] : '';
    deliveryTime = json['delivery_time'] != null ? json['delivery_time'] : '';
    deliveryType = json['delivery_type'] != null ? json['delivery_type'] : '';
    isPayed = json['is_payed'] != null ? json['is_payed'] : 0;
    iikoId = json['iiko_id'] != null ? json['iiko_id'] : '';
    laterTime = json['later_time'] != null ? json['later_time'] : '';
    basket =
    json['basket'] != null ? new OrderBasket.fromJson(json['basket']) : null;
    terminalData = json['terminalData'] != null
        ? new TerminalData.fromJson(json['terminalData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['basket_id'] = this.basketId;
    data['user_id'] = this.userId;
    data['sub_total'] = this.subTotal;
    data['delivery_total'] = this.deliveryTotal;
    data['discount_total'] = this.discountTotal;
    data['tax_total'] = this.taxTotal;
    data['order_total'] = this.orderTotal;
    data['shipping_method'] = this.shippingMethod;
    data['shipping_preference'] = this.shippingPreference;
    data['status'] = this.status;
    data['type'] = this.type;
    data['notes'] = this.notes;
    data['currency'] = this.currency;
    data['billing_phone'] = this.billingPhone;
    data['billing_email'] = this.billingEmail;
    data['shipping_company_name'] = this.shippingCompanyName;
    data['billing_company_name'] = this.billingCompanyName;
    data['billing_firstname'] = this.billingFirstname;
    data['billing_lastname'] = this.billingLastname;
    data['billing_address'] = this.billingAddress;
    data['billing_address_two'] = this.billingAddressTwo;
    data['billing_address_three'] = this.billingAddressThree;
    data['billing_city'] = this.billingCity;
    data['billing_county'] = this.billingCounty;
    data['billing_state'] = this.billingState;
    data['billing_country'] = this.billingCountry;
    data['billing_zip'] = this.billingZip;
    data['shipping_phone'] = this.shippingPhone;
    data['shipping_email'] = this.shippingEmail;
    data['shipping_firstname'] = this.shippingFirstname;
    data['shipping_lastname'] = this.shippingLastname;
    data['shipping_address'] = this.shippingAddress;
    data['shipping_address_two'] = this.shippingAddressTwo;
    data['shipping_address_three'] = this.shippingAddressThree;
    data['shipping_city'] = this.shippingCity;
    data['shipping_county'] = this.shippingCounty;
    data['shipping_state'] = this.shippingState;
    data['shipping_country'] = this.shippingCountry;
    data['shipping_zip'] = this.shippingZip;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['contact_email'] = this.contactEmail;
    data['contact_phone'] = this.contactPhone;
    data['vat_no'] = this.vatNo;
    data['tracking_no'] = this.trackingNo;
    data['dispatched_at'] = this.dispatchedAt;
    data['reference'] = this.reference;
    data['customer_reference'] = this.customerReference;
    data['placed_at'] = this.placedAt;
    data['conversion'] = this.conversion;
    // if (this.meta != null) {
    //   data['meta'] = this.meta.map((v) => v.toJson()).toList();
    // }
    data['terminal_id'] = this.terminalId;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['flat'] = this.flat;
    data['house'] = this.house;
    data['entrance'] = this.entrance;
    data['door_code'] = this.doorCode;
    data['delivery_schedule'] = this.deliverySchedule;
    data['delivery_day'] = this.deliveryDay;
    data['delivery_time'] = this.deliveryTime;
    data['delivery_type'] = this.deliveryType;
    data['is_payed'] = this.isPayed;
    data['iiko_id'] = this.iikoId;
    data['later_time'] = this.laterTime;
    if (this.basket != null) {
      data['basket'] = this.basket?.toJson();
    }
    if (this.terminalData != null) {
      data['terminalData'] = this.terminalData?.toJson();
    }
    return data;
  }
}

class OrderBasket {
  late int id;
  int? userId;
  Null mergedId;
  Null completedAt;
  late String currency;
  late String createdAt;
  late String updatedAt;
  // List<Null> meta;
  String? otp;
  List<Lines>? lines;

  OrderBasket(
      {required this.id,
        this.userId,
        this.mergedId,
        this.completedAt,
        required this.currency,
        required this.createdAt,
        required this.updatedAt,
        this.otp,
        this.lines});

  OrderBasket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'] != null ? json['user_id'] : 0;
    mergedId = json['merged_id'];
    completedAt = json['completed_at'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'] != null ? json['otp'] : '';
    if (json['lines'] != null) {
      lines = json['lines'].map<Lines>((m) => new Lines.fromJson(m)).toList();
    }
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
    if (this.lines != null) {
      data['lines'] = this.lines?.map((v) => v.toJson()).toList();
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
  dynamic modifiers;
  Null parentId;
  Variant? variant;
  List<Child>? child;

  Lines(
      {required this.id,
        required this.basketId,
        required this.productVariantId,
        required this.quantity,
        required this.total,
        required this.createdAt,
        required this.updatedAt,
        this.modifiers,
        this.parentId,
        this.variant,
        this.child});

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
        modifiers = List<Modifiers>.empty();
      } else {
        modifiers = json['modifiers'].map<Modifiers>((m) => new Modifiers.fromJson(m)).toList();
      }
    } else {
      modifiers = List<Modifiers>.empty();
    }
    parentId = json['parent_id'];
    variant =
    json['variant'] != null ? new Variant.fromJson(json['variant']) : null;
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
      data['modifiers'] = this.modifiers.map((v) => v.toJson()).toList();
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

  Modifiers(
      {required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.name,
        required this.xmlId,
        required this.price,
        required this.weight,
        required this.groupId,
        required this.nameUz});

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
  late String price;
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
  Null assetId;
  late int taxId;
  late int groupPricing;
  Null draftedAt;
  Null draftParentId;
  Product? product;

  Variant(
      {required this.id,
        required this.productId,
        required this.sku,
        required this.price,
        required this.unitQty,
        required this.minQty,
        required this.minBatch,
        required this.maxQty,
        required this.stock,
        required this.incoming,
        required this.backorder,
        required this.requiresShipping,
        required this.weightValue,
        required this.weightUnit,
        required this.heightValue,
        required this.heightUnit,
        required this.widthValue,
        required this.widthUnit,
        required this.depthValue,
        required this.depthUnit,
        required this.volumeValue,
        required this.volumeUnit,
        required this.createdAt,
        required this.updatedAt,
        this.assetId,
        required this.taxId,
        required this.groupPricing,
        this.draftedAt,
        this.draftParentId,
        this.product});

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
    draftedAt = json['drafted_at'];
    draftParentId = json['draft_parent_id'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
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
    data['drafted_at'] = this.draftedAt;
    data['draft_parent_id'] = this.draftParentId;
    if (this.product != null) {
      data['product'] = this.product?.toJson();
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
  late String? width;
  late String? height;
  late String title;
  late String originalFilename;
  Null caption;
  late int size;
  late int external;
  late String extension;
  late String filename;
  late String createdAt;
  late String updatedAt;

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
        required this.updatedAt});

  Assets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assetSourceId = json['asset_source_id'];
    location = json['location'];
    kind = json['kind'];
    subKind = json['sub_kind'];
    width = json['width'];
    height = json['height'];
    title = json['title'];
    originalFilename = json['original_filename'];
    caption = json['caption'];
    size = json['size'];
    external = json['external'];
    extension = json['extension'];
    filename = json['filename'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}

class Product {
  late int id;
  AttributeData? attributeData;
  late String createdAt;
  late String updatedAt;
  Null deletedAt;
  late int productFamilyId;
  Null layoutId;
  late int groupPricing;
  Null draftedAt;
  Null draftParentId;
  String? customName;
  int? productId;
  String? customNameUz;
  late int active;
  int? modifierProdId;
  int? boxId;
  List<Assets>? assets;

  Product(
      {required this.id,
        this.attributeData,
        required this.createdAt,
        required this.updatedAt,
        this.deletedAt,
        required this.productFamilyId,
        this.layoutId,
        required this.groupPricing,
        this.draftedAt,
        this.draftParentId,
        this.customName,
        this.productId,
        this.customNameUz,
        required this.active,
        this.modifierProdId,
        this.boxId,
        this.assets});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeData = json['attribute_data'] != null
        ? new AttributeData.fromJson(json['attribute_data'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    productFamilyId = json['product_family_id'];
    layoutId = json['layout_id'];
    groupPricing = json['group_pricing'];
    draftedAt = json['drafted_at'];
    draftParentId = json['draft_parent_id'];
    customName = json['custom_name'] != null ? json['custom_name'] : '';
    productId = json['product_id'] != null ? json['product_id'] : 0;
    customNameUz = json['custom_name_uz'] != null ? json['custom_name_uz'] : '';
    active = json['active'];
    modifierProdId = json['modifier_prod_id'] != null ? json['modifier_prod_id'] : 0;
    boxId = json['box_id'] != null ? json['box_id'] : 0;
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
    data['deleted_at'] = this.deletedAt;
    data['product_family_id'] = this.productFamilyId;
    data['layout_id'] = this.layoutId;
    data['group_pricing'] = this.groupPricing;
    data['drafted_at'] = this.draftedAt;
    data['draft_parent_id'] = this.draftParentId;
    if (this.customName != null) {
      data['custom_name'] = this.customName;
    }
    if (this.productId != null) {
      data['product_id'] = this.productId;
    }
    if (this.customNameUz != null) {
      data['custom_name_uz'] = this.customNameUz;
    }
    data['active'] = this.active;
    if (this.modifierProdId != null) {
      data['modifier_prod_id'] = this.modifierProdId;
    }
    if (this.boxId != null) {
      data['box_id'] = this.boxId;
    }
    if (this.assets != null) {
      data['assets'] = this.assets!.map((v) => v.toJson()).toList();
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
  String? modifiers;
  late String parentId;
  Variant? variant;

  Child(
      {required this.id,
        required this.basketId,
        required this.productVariantId,
        required this.quantity,
        required this.total,
        required this.createdAt,
        required this.updatedAt,
        this.modifiers,
        required this.parentId,
        this.variant});

  Child.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basketId = json['basket_id'];
    productVariantId = json['product_variant_id'];
    quantity = json['quantity'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    modifiers = json['modifiers'] != null ? json['modifiers'] : '';
    parentId = json['parent_id'];
    variant =
    json['variant'] != null ? new Variant.fromJson(json['variant']) : null;
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
    data['modifiers'] = this.modifiers;
    data['parent_id'] = this.parentId;
    if (this.variant != null) {
      data['variant'] = this.variant?.toJson();
    }
    return data;
  }
}

class TerminalData {
  late String name;
  String? nameUz;

  TerminalData({required this.name, this.nameUz});

  TerminalData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameUz = json['name_uz'] != null ? json['name_uz'] : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_uz'] = this.nameUz;
    return data;
  }
}
