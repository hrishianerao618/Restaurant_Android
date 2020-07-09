import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_project/models/user.dart';
import 'package:food_project/services/database.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User _userfromFirebaseUser(FirebaseUser user) {
    //return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userfromFirebaseUser(user));
    .map(_userfromFirebaseUser);
  }


  // Sign in anonimously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userfromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //await DatabaseService(uid: user.uid).updateUserData('3/44 Bafna Society, Mogal Lane, Mahim, Mumbai-400016', 9876543210, ['Noodles','Pizza','Burger'], 450);
      //return _userfromFirebaseUser(user);
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('3/44 Bafna Society, Mogal Lane, Mahim, Mumbai-400016', 9876543210, ['Noodles','Pizza','Burger'], 450);
      return _userfromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}