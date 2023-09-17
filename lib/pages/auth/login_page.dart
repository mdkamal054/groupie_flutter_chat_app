import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groupie_flutter_chat_app/pages/auth/register_page.dart';
import 'package:groupie_flutter_chat_app/service/auth_service.dart';
import 'package:groupie_flutter_chat_app/service/database_service.dart';
import 'package:groupie_flutter_chat_app/widgets/widgets.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading? Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      ) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Groupie",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Login in now to see what they are talking ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Image.asset("images/login.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email,
                        color: Theme.of(context).primaryColor),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  // check the validation
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon:
                        Icon(Icons.lock, color: Theme.of(context).primaryColor),
                  ),
                  validator: (val){
                    if (val!.length < 6){
                      return "Password must be at least 6 characters";
                    }else{
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),

                const SizedBox(height: 20,),
                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       primary: Theme.of(context).primaryColor,
                       elevation: 0,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                     ),
                     onPressed: (){
                       login();
                     },
                     child: const Text("Sign In",
                       style: TextStyle(color: Colors.white,fontSize: 16),),
                   ),
                 ),

               const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style:const TextStyle(color: Colors.black,fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Register here",
                        style: const TextStyle(color: Colors.black,decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = (){

                          nextScreen(context,const RegisterPage());
                      }
                      )
                    ]
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );

  }

  void login() async{

    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });

      await authService.loginInUser(email, password).then((value) async {
        if(value == true){
          // saving the login state to shared pref

          QuerySnapshot snapshot =  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .getUserData(email);

          await HelperFunctions.savingUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(snapshot.docs[0]["fullName"]);
          nextScreenReplace(context, HomeScreen());
        }else{
          setState(() {
            // show snckbar if error
            showSnackBar(context, Colors.red, value);
            _isLoading = false;
          });
        }
      });

    }

  }

}
