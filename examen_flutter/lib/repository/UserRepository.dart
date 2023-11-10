
import 'package:dio/dio.dart';
import 'package:examen_flutter/apis/user_api.dart';
import 'package:examen_flutter/model/userModel.dart';
class UserRepository {
  UserApi? userApi;

  UserRepository() {
    Dio _dio = Dio();
    userApi = UserApi(_dio);
  }

  Future<List<UserModel>> getUsers() async {
    final data = await userApi!.listUsers();
    return data;
  }

  Future<void> deleteUser(int id) async {
    try {
      await userApi!.deleteUser(id);
      print("Usuario eliminado con éxito");
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }


  Future<UserModel> updateUser(int id, UserModel user) async {
    return await userApi!.updateUser(id, user);
  }

  Future<UserModel> createUser(UserModel user) async {
    return await userApi!.createUser(user);
  }
}
