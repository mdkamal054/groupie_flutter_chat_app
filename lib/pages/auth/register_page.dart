import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groupie_flutter_chat_app/helper/helper_function.dart';
import 'package:groupie_flutter_chat_app/pages/auth/login_page.dart';
import 'package:groupie_flutter_chat_app/pages/home_page.dart';
import 'package:groupie_flutter_chat_app/service/auth_service.dart';

import '../../widgets/widgets.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String fullName = "";
  String password = "";

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading ? Center(
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
                  "Create new account to chat and explore",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Image.asset("images/register.png"),

                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                  // check the validation
                  validator: (val) {
                    if (val!.isNotEmpty){
                      return null;
                    }else{
                     return "Please Enter Full Name";
                    }
                  },
                ),

               const SizedBox(height: 10,),

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
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),
                    onPressed: (){
                      registerUser();
                    },
                    child: const Text("Register",
                      style: TextStyle(color: Colors.white,fontSize: 16),),
                  ),
                ),

                const SizedBox(height: 10,),
                Text.rich(
                    TextSpan(
                        text: "Already have an account? ",
                        style:const TextStyle(color: Colors.black,fontSize: 14),
                        children: [
                          TextSpan(
                              text: "Login here",
                              style: const TextStyle(color: Colors.black,decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = (){

                                nextScreenReplace(context,const LoginPage());
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

  void registerUser() async{

    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });

      await authService.signInWithEmailAndPassword(fullName, email, password).then((value) async {
        if(value == true){
          // saving the login state to shared pref

           await HelperFunctions.savingUserLoggedInStatus(true);
           await HelperFunctions.saveUserEmail(email);
           await HelperFunctions.saveUserName(fullName);
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
