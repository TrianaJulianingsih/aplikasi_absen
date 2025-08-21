import 'package:flutter/material.dart';
import 'package:tugas_13/dashboard/drawer.dart';
import 'package:tugas_13/models/user.dart';
import 'package:tugas_13/preference/login.dart';
import 'package:tugas_13/sqflite/db_helper.dart';
import 'package:tugas_13/views/login_screen.dart';
import 'package:tugas_13/textForm/text_form.dart';
import 'package:tugas_13/extension/navigation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const id = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<User> users = [];
  String? emailUser;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  Future<void> getUser() async {
    final dataUser = await DbHelper.getAllUser();
    
    setState(() {
      users = dataUser;
    });
  }

  
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor:  const Color.fromARGB(255, 15, 216, 166),
      ),
      drawer: DrawerMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stack(
          //   children: [Padding(
          //     padding: const EdgeInsets.all(20),
          //     child: Container(
          //       height: 200,
          //       width: 350,
          //       decoration: BoxDecoration(
          //         color: Colors.greenAccent,
          //         borderRadius: BorderRadius.circular(10)
                  
          //       ),
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.all(60),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           height: 90,
          //           width: 90,
          //           decoration: BoxDecoration(
          //             image: DecorationImage(image: AssetImage("assets/images/jiso.jpg"), fit: BoxFit.cover),
          //             shape: BoxShape.circle,
                  
          //           ),
          //         ),
          //         SizedBox(width: 20),
                    // Text(
                    //   emailUser ?? "Loading...",
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold
                    //   ),
                    // ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final dataUser = users[index];
              return Card(
                color: const Color.fromARGB(255, 244, 187, 54),
                child: ListTile(
                  title: Text(dataUser.nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataUser.email),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        color: Colors.blue,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Edit Data'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormConst(
                                      controller: namaController
                                      ..text = dataUser.nama,
                                      hintText: 'Nama',
                                    ),
                                    SizedBox(height: 12),
                                    TextFormConst(
                                      controller: emailController
                                      ..text = dataUser.email,
                                      hintText: 'Email',
                                    ),
                                      
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      final dataUser = User(
                                        // id: dataUser.id!,
                                        nama: namaController.text,
                                        email: emailController.text,    
                                      );
                                      DbHelper.updateUser(dataUser);
                                      getUser();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Simpan'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Batal'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                      Card(
                        color: Colors.red,
                        child: IconButton(
                          onPressed: () {
                            DbHelper.deletePeserta(dataUser.id!);
                            getUser();
                          },
                          icon: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      
                    ],
                  ),
                )
              );
              
            }
          ),
          ElevatedButton(onPressed: (){PreferenceHandler.removeLogin();
        context.pushReplacementNamed(Login.id);}, child: Text("Keluar"))

        ]
      ),
          
    );
        
  }
}