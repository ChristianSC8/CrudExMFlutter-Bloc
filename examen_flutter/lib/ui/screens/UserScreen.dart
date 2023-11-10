import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:examen_flutter/bloc/user/user_bloc.dart';
import 'package:examen_flutter/model/userModel.dart';
import 'package:examen_flutter/repository/UserRepository.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(UserRepository()),
      child: UserListContent(),
    );
  }
}

class UserListContent extends StatefulWidget {
  @override
  _UserListContentState createState() => _UserListContentState();
}

class _UserListContentState extends State<UserListContent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rolController = TextEditingController();
  UserModel? editingUser;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(ListUserEvent());
  }

  Future<void> createUser() async {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String lastname = lastnameController.text;
    final String password = passwordController.text;
    final String rol = rolController.text;

    if (username.isEmpty || email.isEmpty || lastname.isEmpty || password.isEmpty || rol.isEmpty) {
      showErrorMessage('Por favor, complete todos los campos');
      return;
    }

    final newUser = UserModel(
      idUser: 0,
      username: username,
      email: email,
      lastname: lastname,
      password: password,
      rol: rol,
    );

    context.read<UserBloc>().add(CreateUserEvent(newUser));
    clearTextFields();
  }

  Future<void> showDeleteConfirmationDialog(UserModel user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('Eliminar Usuario'),
          content: Text('¿Seguro que deseas eliminar a ${user.username}?'),
          actionsPadding: EdgeInsets.only(bottom: 8.0),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Eliminar',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                deleteUser(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditDialog(UserModel user) async {
    usernameController.text = user.username;
    emailController.text = user.email;
    lastnameController.text = user.lastname;
    passwordController.text = user.password;
    rolController.text = user.rol;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: lastnameController,
                      decoration: InputDecoration(labelText: 'Apellido'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: rolController,
                      decoration: InputDecoration(labelText: 'Rol'),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
            ],
          ),
          actionsPadding: EdgeInsets.only(bottom: 8.0),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                clearTextFields();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                updateUser(user);
                clearTextFields();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateUser(UserModel user) {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String lastname = lastnameController.text;
    final String password = passwordController.text;
    final String rol = rolController.text;

    if (username.isEmpty || email.isEmpty || lastname.isEmpty || password.isEmpty || rol.isEmpty) {
      showErrorMessage('Por favor, complete todos los campos');
      return;
    }

    final updatedUser = UserModel(
      idUser: user.idUser,
      username: username,
      email: email,
      lastname: lastname,
      password: password,
      rol: rol,
    );

    context.read<UserBloc>().add(UpdateUserEvent(updatedUser));
    clearTextFields();
  }

  void deleteUser(UserModel user) {
    context.read<UserBloc>().add(DeleteUserEvent(user));
  }

  void clearTextFields() {
    usernameController.clear();
    emailController.clear();
    lastnameController.clear();
    passwordController.clear();
    rolController.clear();
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoadedState) {
            final userList = state.UserList;
            return userList.isEmpty
                ? Center(child: Text('No hay usuarios disponibles.'))
                : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  title: Text(user.username),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showEditDialog(user);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDeleteConfirmationDialog(user);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.e.toString()}'));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text('Crear Usuario'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Nombre de usuario'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: lastnameController,
                            decoration: InputDecoration(labelText: 'Apellido'),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: rolController,
                            decoration: InputDecoration(labelText: 'Rol'),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Correo electrónico'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Contraseña'),
                    ),
                  ],
                ),
                actionsPadding: EdgeInsets.only(bottom: 8.0),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      clearTextFields();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Crear',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      createUser();
                      clearTextFields();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
