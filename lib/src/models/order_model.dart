class OrderModel {
  int id;
  String service;
  Address fromAddress;
  Address toAddress;
  int servicePrice;
  int distance;
  String indications;
  String approximatePriceOrder;
  String reasonRejection;
  String orderDate;
  DateTime dateDeliveredOrder;
  String qrCode;
  OrderStatus orderStatus;
  Customer customer;
  Null deliveryMan;
  String station;
  List<Details> details;
  String maximumResponseTime;
  bool validateQr;
  double ratedOrder;
  bool inProcess;
  int serviceId;
  bool isSafeOrder;
  StationObject stationObject;
  Point merchantLocation;
  int orderPrice;
  int totalOrder;
  bool isDeliveryByStore;
  bool isOrderToMerchant;

  OrderModel(
      {this.id,
      this.service,
      this.fromAddress,
      this.toAddress,
      this.servicePrice,
      this.distance,
      this.indications,
      this.approximatePriceOrder,
      this.reasonRejection,
      this.orderDate,
      this.dateDeliveredOrder,
      this.qrCode,
      this.orderStatus,
      this.customer,
      this.deliveryMan,
      this.station,
      this.details,
      this.maximumResponseTime,
      this.validateQr,
      this.ratedOrder,
      this.inProcess,
      this.serviceId,
      this.isSafeOrder,
      this.stationObject,
      this.merchantLocation,
      this.orderPrice,
      this.totalOrder,
      this.isDeliveryByStore,
      this.isOrderToMerchant});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    service = json['service'];
    fromAddress = json['from_address'] != null
        ? new Address.fromJson(json['from_address'])
        : null;
    toAddress = json['to_address'] != null
        ? new Address.fromJson(json['to_address'])
        : null;
    servicePrice = json['service_price'];
    distance = json['distance'];
    indications = json['indications'];
    approximatePriceOrder = json['approximate_price_order'];
    reasonRejection = json['reason_rejection'];
    orderDate = json['order_date'];
    dateDeliveredOrder = json['date_delivered_order'];
    qrCode = json['qr_code'];
    orderStatus = json['order_status'] != null
        ? new OrderStatus.fromJson(json['order_status'])
        : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    deliveryMan = json['delivery_man'];
    station = json['station'];
    if (json['details'] != null) {
      details = new List<Details>();
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
    maximumResponseTime = json['maximum_response_time'];
    validateQr = json['validate_qr'];
    ratedOrder = json['rated_order'];
    inProcess = json['in_process'];
    serviceId = json['service_id'];
    isSafeOrder = json['is_safe_order'];
    stationObject = json['station_object'] != null
        ? new StationObject.fromJson(json['station_object'])
        : null;
    merchantLocation = json['merchant_location'] != null
        ? new Point.fromJson(json['merchant_location'])
        : null;
    orderPrice = json['order_price'];
    totalOrder = json['total_order'];
    isDeliveryByStore = json['is_delivery_by_store'];
    isOrderToMerchant = json['is_order_to_merchant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service'] = this.service;
    if (this.fromAddress != null) {
      data['from_address'] = this.fromAddress.toJson();
    }
    if (this.toAddress != null) {
      data['to_address'] = this.toAddress.toJson();
    }
    data['service_price'] = this.servicePrice;
    data['distance'] = this.distance;
    data['indications'] = this.indications;
    data['approximate_price_order'] = this.approximatePriceOrder;
    data['reason_rejection'] = this.reasonRejection;
    data['order_date'] = this.orderDate;
    data['date_delivered_order'] = this.dateDeliveredOrder;
    data['qr_code'] = this.qrCode;
    if (this.orderStatus != null) {
      data['order_status'] = this.orderStatus.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['delivery_man'] = this.deliveryMan;
    data['station'] = this.station;
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['maximum_response_time'] = this.maximumResponseTime;
    data['validate_qr'] = this.validateQr;
    data['rated_order'] = this.ratedOrder;
    data['in_process'] = this.inProcess;
    data['service_id'] = this.serviceId;
    data['is_safe_order'] = this.isSafeOrder;
    if (this.stationObject != null) {
      data['station_object'] = this.stationObject.toJson();
    }
    if (this.merchantLocation != null) {
      data['merchant_location'] = this.merchantLocation.toJson();
    }
    data['order_price'] = this.orderPrice;
    data['total_order'] = this.totalOrder;
    data['is_delivery_by_store'] = this.isDeliveryByStore;
    data['is_order_to_merchant'] = this.isOrderToMerchant;
    return data;
  }
}

class StationObject {
  int id;
  String stationName;
  String phoneNumber;

  StationObject({this.id, this.stationName, this.phoneNumber});

  StationObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationName = json['station_name'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['station_name'] = this.stationName;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

class Details {
  String productName;
  Null picture;
  int productId;
  int quantity;

  Details({this.productName, this.picture, this.productId, this.quantity});

  Details.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    picture = json['picture'];
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['picture'] = this.picture;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    return data;
  }
}

class Customer {
  int id;
  String name;
  String phoneNumber;
  int reputation;
  bool isSafeUser;

  Customer(
      {this.id, this.name, this.phoneNumber, this.reputation, this.isSafeUser});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    reputation = json['reputation'];
    isSafeUser = json['is_safe_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['reputation'] = this.reputation;
    data['is_safe_user'] = this.isSafeUser;
    return data;
  }
}

class OrderStatus {
  int id;
  String name;
  String slugName;
  OrderStatus({this.id, this.name, this.slugName});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slugName = json['slug_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug_name'] = this.slugName;
    return data;
  }
}

class Address {
  int id;
  String alias;
  String fullAddress;
  String exteriorNumber;
  TypeAddress typeAddress;
  String insideNumber;
  String references;
  String status;
  Point point;

  Address(
      {this.id,
      this.alias,
      this.fullAddress,
      this.exteriorNumber,
      this.typeAddress,
      this.insideNumber,
      this.references,
      this.status,
      this.point});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    fullAddress = json['full_address'];
    exteriorNumber = json['exterior_number'];
    typeAddress = json['type_address'] != null
        ? new TypeAddress.fromJson(json['type_address'])
        : null;
    insideNumber = json['inside_number'];
    references = json['references'];
    status = json['status'];
    point = json['point'] != null ? new Point.fromJson(json['point']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['full_address'] = this.fullAddress;
    data['exterior_number'] = this.exteriorNumber;
    if (this.typeAddress != null) {
      data['type_address'] = this.typeAddress.toJson();
    }
    data['inside_number'] = this.insideNumber;
    data['references'] = this.references;
    data['status'] = this.status;
    if (this.point != null) {
      data['point'] = this.point.toJson();
    }
    return data;
  }
}

class TypeAddress {
  int id;
  String name;
  String slugName;

  TypeAddress({this.id, this.name, this.slugName});

  TypeAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slugName = json['slug_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug_name'] = this.slugName;
    return data;
  }
}

class Point {
  String type;
  List<double> coordinates;
  Point({this.type, this.coordinates});

  Point.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
