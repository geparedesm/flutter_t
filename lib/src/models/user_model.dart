import 'dart:convert';

class UserModel {
  UserModel({
    this.identification = "",
    this.email = "",
    this.photoUrl = "",
    this.uid = "",
    this.name = "",
    this.phone = "",
  });

  String identification;
  String email;
  String photoUrl;
  String uid;
  String name;
  String phone;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      identification: json["identification"],
      email: json["email"],
      photoUrl: json["photoUrl"],
      uid: json["id"],
      name: json["name"],
      phone: json["phone"],
    );
  }

  factory UserModel.toDecodeJson(String data) {
    return UserModel.fromJson(json.decode(data));
  }

  String toEncodeJson() => json.encode({
        "identification": identification,
        "email": email,
        "photoUrl": photoUrl,
        "id": uid,
        "name": name,
        "phone": phone,
      });
  Map<String, dynamic> toJson() => {
        "identification": identification,
        "email": email,
        "fotoURL": photoUrl,
        "id": uid,
        "nombre": name,
        "phone": phone,
      };
  bool profileCompleted() {
    return email != '' && uid != '';
  }

  UserModel init() {
    final userData = UserModel();
    return userData;
  }
}
