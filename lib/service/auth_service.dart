import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupie_flutter_chat_app/helper/helper_function.dart';
import 'package:groupie_flutter_chat_app/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login

  Future loginInUser(String email, String password) async {

    try{

      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null){

        // upload user data to firebase

        return true;
      }

    } on FirebaseAuthException catch(e){
      return e.message;
    }

  }

  // register

  Future signInWithEmailAndPassword(
      String fullName, String email, String password) async {

    try{

      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null){

        // upload user data to firebase

       await DatabaseService(uid: user.uid).savingUserData(fullName, email);

        return true;
      }

    } on FirebaseAuthException catch(e){
      return e.message;
    }

  }

  // signout

 Future signout() async{
    try{

      await HelperFunctions.savingUserLoggedInStatus(false);
      await HelperFunctions.saveUserName("");
      await HelperFunctions.saveUserEmail("");

      await firebaseAuth.signOut();

    }catch (e){
      return null;
    }
 }

}
