part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}
class UserInitialState extends UserState{}
class UserLoadingState extends UserState{}
class UserLoadedState extends UserState{
  List<UserModel> UserList;
  UserLoadedState(this.UserList);
}
class UserError extends UserState{
  Error e;
  UserError(this.e);
}