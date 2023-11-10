import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:examen_flutter/model/userModel.dart';
import 'package:examen_flutter/repository/UserRepository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late final UserRepository _userRepository;
  UserBloc(this._userRepository) : super(UserInitialState()) {
    on<UserEvent>((event, emit) async {


      print("Bloc x");
      if(event is ListUserEvent){
        emit(UserLoadingState());
        try{
          print("pasox!!");
          List<UserModel> UserList  = await _userRepository.getUsers();
          emit(UserLoadedState(UserList ));
        } catch(e){
          emit(UserError(e as Error)) ;
        }
      }else if(event is DeleteUserEvent){
        try{
          await _userRepository.deleteUser(event.user!.idUser);
          emit(UserLoadingState());
          List<UserModel> UserList = await _userRepository.getUsers();
          emit(UserLoadedState(UserList));
        }catch(e){
          emit(UserError(e as Error));
        }
      }else if(event is CreateUserEvent){
        try{
          await _userRepository.createUser(event.user!);
          emit(UserLoadingState());
          List<UserModel> UserList= await _userRepository.getUsers();
          emit(UserLoadedState(UserList));
        }catch(e){
          emit(UserError(e as Error));
        }
      }else if(event is UpdateUserEvent){
        try{
          await _userRepository.updateUser(event.user!.idUser, event.user!);
          emit(UserLoadingState());
          List<UserModel> UserList= await _userRepository.getUsers();
          emit(UserLoadedState(UserList));
        }catch(e){
          emit(UserError(e as Error));
        }
      }


    });
  }
}
