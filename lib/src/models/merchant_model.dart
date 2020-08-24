class MerchantModel {
  int id;
  UserData user;
  String contactPerson;
  String picture;
  String merchantName;
  String phoneNumber;
  bool isDeliveryByStore;
  bool informationIsComplete;
  String category;
  String subcategory;
  double reputation;
  String description;
  String approximatePreparationTime;
  bool isOpen;

  MerchantModel();

  MerchantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = UserData.fromJson(json['user']);
    contactPerson = json['contact_person'];
    picture = json['picture'];
    merchantName = json['merchant_name'];
    phoneNumber = json['phone_number'];
    isDeliveryByStore = json['is_delivery_by_store'];
    informationIsComplete = json['information_is_complete'];
    category = json['category'];
    subcategory = json['subcategory'];
    reputation = json['reputation'];
    description = json['description'];
    approximatePreparationTime = json['approximate_preparation_time'];
    isOpen = json['is_open'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'contact_person': contactPerson,
      'picture': picture,
      'merchant_name': merchantName,
      'phone_number': phoneNumber,
      'is_delivery_by_store': isDeliveryByStore,
      'information_is_complete': informationIsComplete,
      'category': category,
      'subcategory': subcategory,
      'reputation': reputation,
      'description': description,
      'approximate_preparation_time': approximatePreparationTime,
      'is_open': isOpen
    };
  }
}

class UserData {
  String username;
  bool isVerified;
  bool authFacebook;

  UserData();

  UserData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    isVerified = json['is_verified'];
    authFacebook = json['auth_facebook'];
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'is_verified': isVerified,
      'auth_facebook': authFacebook
    };
  }
}
