
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.idUser,
    required this.username,
    required this.lastname,
    required this.email,
    required this.password,
    required this.rol,
  });
  late final int idUser;
  late final String username;
  late final String lastname;
  late final String email;
  late final String password;
  late final String rol;

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      idUser : json['id_user'] ?? 0,
      username : json['username'] ?? '',
      lastname : json['lastname'] ?? '',
      email : json['email'] ?? '',
      password : json['password'] ?? '',
      rol : json['rol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_user'] = idUser;
    _data['username'] = username;
    _data['lastname'] = lastname;
    _data['email'] = email;
    _data['password'] = password;
    _data['rol'] = rol;
    return _data;
  }
}