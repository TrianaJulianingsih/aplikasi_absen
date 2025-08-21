import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tugas_13/dashboard/buttom_nav.dart';
import 'package:tugas_13/preference/login.dart';
import 'package:tugas_13/sqflite/db_helper.dart';
import 'package:tugas_13/views/register_screen.dart';
import 'package:tugas_13/extension/navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const id = "/login";

  @override
  State<Login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> login() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      setState(() => isLoading = false);

      return;
    }
    final userData = await DbHelper.loginUser(email, password);
    if (userData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selamat datang, ${userData.nama}")),
      );
      PreferenceHandler.saveLogin(userData.id!, userData.email, userData.nama);
      Navigator.pushReplacementNamed(context, "/buttomNav");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau Password salah")),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(

      // ),
      body: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background.jpg"),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 68),
              height: 744,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 92),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 42),
                  Padding(
                    padding: const EdgeInsets.only(right: 112),
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Gilroy_Medium",
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 39),
                    child: Text(
                      "Welcome back to Estero. Have a good time",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(204, 67, 66, 66),
                        fontFamily: "Gilroy_Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: 327,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(47, 174, 174, 178),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hint: Text(
                              "Your Email/id",
                              style: TextStyle(
                                color: const Color.fromARGB(223, 85, 85, 88),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Gilroy_Regular",
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 8),
                            prefixIcon: Transform.translate(
                              offset: Offset(0, -2),
                              child: Image.asset(
                                "assets/icons/iconProfil.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email tidak boleh kosong";
                            } else if (!value.contains("@")) {
                              return "Email tidak valid";
                            } else if (RegExp(r'^\d').hasMatch(value)) {
                              return "Email tidak valid";
                            }
                            return null;
                          },
                        ),
                        Divider(
                          indent: 15,
                          endIndent: 15,
                          color: const Color.fromARGB(71, 152, 152, 161),
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10),
                            prefixIcon: Transform.translate(
                              offset: Offset(0, -1),
                              child: Image.asset(
                                "assets/icons/iconLock.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            hint: Text(
                              "Your Password",
                              style: TextStyle(
                                color: const Color.fromARGB(195, 61, 61, 62),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: "Gilroy_Regular",
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            } else if (RegExp(r'^\d').hasMatch(value)) {
                              return "Password tidak valid";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(right: 210),
                    child: Text(
                      "Forget Password ?",
                      style: TextStyle(
                        color: const Color.fromARGB(148, 62, 62, 70),
                        fontSize: 12,
                        fontFamily: "Poppins_Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 45),
                  SizedBox(
                    height: 56,
                    width: 327,
                    child: ElevatedButton(
                      onPressed: () {
                        login();
                        
                        //Error dan sukses menggunakan ScaffoldMessenger dan formKey
                        // if (_formKey.currentState!.validate()) {
                        //   // ScaffoldMessenger.of(context).showSnackBar(
                        //   //   SnackBar(content: Text("Form Validasi Berhasil")),
                        //   // );
                        //   context.pushReplacement(TugasDelapan());
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text("Form Validasi Berhasil"),
                        //       duration: Duration(microseconds: 2),
                        //     ),
                        //   );
                        // } else {
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Text("Login failed"),
                        //         content: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             Text("Email or password is invalid"),
                        //             SizedBox(height: 20),
                        //             // Image.asset(
                        //             //   'assets/images/rendang.jpeg',
                        //             //   width: 90,
                        //             //   height: 100,
                        //             //   fit: BoxFit.cover,
                        //             // ),
                        //             Lottie.asset(
                        //               'assets/animations/false.json',
                        //               width: 100,
                        //               height: 100,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ],
                        //         ),
                        //         actions: [
                        //           TextButton(
                        //             child: Text("Batal"),
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //           ),
                        //           TextButton(
                        //             child: Text("Ok"),
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          111,
                          30,
                          192,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading 
                        ? const CircularProgressIndicator() 
                        : const Text("Login", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(9),
                            child: Image.asset("assets/icons/iconPembatas.png"),
                          ),
                        ),
                        Text(
                          "Or continue with",
                          style: TextStyle(
                            color: const Color.fromARGB(200, 62, 62, 70),
                            fontFamily: "Poppins_Medium",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset("assets/icons/iconPembatas.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 35,
                      right: 35,
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(59, 190, 190, 195),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage("assets/images/google.png"),
                              ),
                            ),
                            // child: Text("Postingan"),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(59, 190, 190, 195),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/cib_apple.png",
                                ),
                              ),
                            ),
                            // child: Text("Follower"),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(59, 190, 190, 195),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage("assets/images/twitter.png"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 140),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: const Color.fromARGB(182, 100, 100, 106),
                          fontFamily: "Poppins_Regular",
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(RegisterScreen());
                              },
                            text: " Register",
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 11, 39, 164),
                              fontFamily: "Poppins_Bold",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}