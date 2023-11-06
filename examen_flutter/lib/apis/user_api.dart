
import 'package:dio/dio.dart';
import 'package:examen_flutter/model/userModel.dart';
import 'package:examen_flutter/util/UrlApi.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';
@RestApi(baseUrl: UrlApi.urlApix)
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  static UserApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return UserApi(dio);
  }

  @POST("/users")
  Future<UserModel> createUser(@Body() UserModel user);

  @GET("/users/{id}")
  Future<UserModel> getUser(@Path() int id);

  @PUT("/users/{id}")
  Future<UserModel> updateUser(@Path() int id, @Body() UserModel user);

  @DELETE("/users/{id}")
  Future<void> deleteUser(@Path() int id);

  @GET("/users")
  Future<List<UserModel>> listUsers();

}