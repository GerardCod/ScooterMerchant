class UserModel {
  int id;
  User user;
  String picture;
  String created;
  String modified;
  String name;
  Null birthdate;
  Null pictureUrl;
  String phoneNumber;
  bool isSafeUser;
  int reputation;
  int status;

  UserModel(
      {this.id,
      this.user,
      this.picture,
      this.created,
      this.modified,
      this.name,
      this.birthdate,
      this.pictureUrl,
      this.phoneNumber,
      this.isSafeUser,
      this.reputation,
      this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    picture = json['picture'];
    created = json['created'];
    modified = json['modified'];
    name = json['name'];
    birthdate = json['birthdate'];
    pictureUrl = json['picture_url'];
    phoneNumber = json['phone_number'];
    isSafeUser = json['is_safe_user'];
    reputation = json['reputation'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['picture'] = this.picture;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['name'] = this.name;
    data['birthdate'] = this.birthdate;
    data['picture_url'] = this.pictureUrl;
    data['phone_number'] = this.phoneNumber;
    data['is_safe_user'] = this.isSafeUser;
    data['reputation'] = this.reputation;
    data['status'] = this.status;
    return data;
  }
}

class User {
  String username;
  bool isVerified;
  bool authFacebook;

  User({this.username, this.isVerified, this.authFacebook});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    isVerified = json['is_verified'];
    authFacebook = json['auth_facebook'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['is_verified'] = this.isVerified;
    data['auth_facebook'] = this.authFacebook;
    return data;
  }
}
