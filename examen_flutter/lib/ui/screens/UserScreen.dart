import 'package:flutter/material.dart';
import 'package:examen_flutter/model/userModel.dart';
import 'package:examen_flutter/apis/user_api.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserScreen> {
  List<UserModel> userList = [];
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  UserModel? editingUser;

  @override
  void initState() {
    super.initState();
    loadUserList();
  }

  Future<void> loadUserList() async {
    try {
      final api = UserApi.create();
      final users = await api.listUsers();
      setState(() {
        userList = users;
      });
    } catch (e) {
      print("Error al cargar la lista de usuarios: $e");
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      final api = UserApi.create();
      await api.deleteUser(userId);
      await loadUserList();
    } catch (e) {
      print("Error al eliminar el usuario: $e");
    }
  }

  Future<void> createUser() async {
    final String username = usernameController.text;
    final String email = emailController.text;

    if (username.isEmpty || email.isEmpty) {
      print("Por favor, complete todos los campos");
      return;
    }

    try {
      final api = UserApi.create();
      final newUser = UserModel(
        idUser: 0,
        username: username,
        email: email,
        lastname: '',
        password: '',
        rol: '',
      );

      final createdUser = await api.createUser(newUser);
      await loadUserList();
      usernameController.clear();
      emailController.clear();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al crear el usuario: $e");
    }
  }

  Future<void> editUser(UserModel user) {
    setState(() {
      editingUser = user;
      usernameController.text = user.username;
      emailController.text = user.email;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Actualizar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                usernameController.clear();
                emailController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Actualizar',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                updateUser().then((_) {
                  loadUserList();
                  usernameController.clear();
                  emailController.clear();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
    return Future.value();
  }

  Future<void> updateUser() async {
    if (editingUser == null) {
      return;
    }

    final String username = usernameController.text;
    final String email = emailController.text;

    if (username.isEmpty || email.isEmpty) {
      print("Por favor, complete todos los campos");
      return;
    }

    try {
      final api = UserApi.create();
      final updatedUser = UserModel(
        idUser: editingUser!.idUser,
        username: username,
        email: email,
        lastname: editingUser!.lastname,
        password: editingUser!.password,
        rol: editingUser!.rol,
      );

      await api.updateUser(editingUser!.idUser, updatedUser);
      await loadUserList();
      editingUser = null;
      usernameController.clear();
      emailController.clear();
    } catch (e) {
      print("Error al actualizar el usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: Column(
        children: [
          userList.isEmpty
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              editUser(user);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Eliminar Usuario'),
                                    content: Text(
                                        '¿Estás seguro de que deseas eliminar este usuario?'),
                                    actions: [
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
                                          deleteUser(user.idUser);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abre el diálogo para crear un nuevo usuario
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Crear Usuario'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Nombre de usuario'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Correo electrónico'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      usernameController.clear();
                      emailController.clear();
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
                      usernameController.clear();
                      emailController.clear();
                      loadUserList();
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
