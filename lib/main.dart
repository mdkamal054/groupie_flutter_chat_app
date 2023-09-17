import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupie_flutter_chat_app/helper/helper_function.dart';
import 'package:groupie_flutter_chat_app/pages/auth/login_page.dart';
import 'package:groupie_flutter_chat_app/pages/home_page.dart';
import 'package:groupie_flutter_chat_app/shared/constant.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isSignedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLogdingStatus();
  }

  void getUserLogdingStatus() async{

    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if(value != null){
       setState(() {
         isSignedIn = value;
       });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constant().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: isSignedIn? const HomeScreen() : const LoginPage(),
    );
  }
}
