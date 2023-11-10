part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}
class ListUserEvent extends UserEvent{
  ListUserEvent(){print("Evento si");}
}
class DeleteUserEvent extends UserEvent{
  UserModel user;
  DeleteUserEvent(this.user);
}
class UpdateUserEvent extends UserEvent{
  UserModel user;
  UpdateUserEvent(this.user);
}
class CreateUserEvent extends UserEvent{
  UserModel user;
  CreateUserEvent(this.user);
}