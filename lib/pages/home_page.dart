import 'package:flutter/material.dart';
import 'package:groupie_flutter_chat_app/pages/auth/login_page.dart';
import 'package:groupie_flutter_chat_app/service/auth_service.dart';
import 'package:groupie_flutter_chat_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: ElevatedButton(child: const Text("LOGOUT"),onPressed: (){

          authService.signout();
          nextScreenReplace(context, const LoginPage());

        },)),
    );
  }
}
