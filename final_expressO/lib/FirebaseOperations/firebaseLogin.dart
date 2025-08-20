import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_nexus/FirebaseOperations/FirebaseuserService.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Make sure this file exists

User? rootUser;

UserCredential? userCreds;
List<String>? excepmtedList;
Map<String, dynamic>? selectedApplication;
Map<String, dynamic>? selectedRequirement;
Map<String, dynamic>? selectedRequest;
Map<String, dynamic>? selectedAnnouncement;
String? uid = FirebaseAuth.instance.currentUser?.uid;
String? homeRoute;
Map<String, dynamic>? requestedDoc; // Parameter to be passed
Map<String, dynamic>? appliedProgram; // Parameter to be passed

// Future<Map<String, dynamic>?> setUserData() async {
//   // print('ahas');
//   // print(FirebaseAuth.instance.currentUser?.email);
//   return getCreds(FirebaseAuth.instance.currentUser?.email as String);
//   // print('userData');
//   // print(userData);

// }

Future<UserCredential?> signInWithGoogle() async {
  try {
    // Trigger the Google authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // User canceled sign-in

    // Obtain auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase
    UserCredential cred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    bool isRegistered = await checkEmail(
        cred.user!.email as String);

    print('isRegistered');
    print('$isRegistered with cred: ${cred.user!.email}');
    if (isRegistered) {

      
      // await loginUser(
      //     cred.user!.email as String, '${cred.user!.email.hashCode}');
      return cred;
    } else {
      await FirebaseFirestore.instance
          .collection('/barangayNexus/users/loginCredentials')
          .doc(cred.user?.uid)
          .set({
        'email': cred.user!.email as String,
        'firstname': cred.user?.displayName as String,
        'middlename': ' ',
        'lastname': ' ',
        'subdiv': ' ',
        'street': ' ',
        'housenum': ' ',
        'barangay': ' ',
        'gender': ' ',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return cred;
  } catch (e) {
    print("Google sign-in error: $e");
    return null;
  }
}

Future<bool> checkUserExists(String email) async {
  final QuerySnapshot query = await FirebaseFirestore.instance
      .collection(
          '/barangayNexus/users/loginCredentials') // Replace with your collection name
      .where('email', isEqualTo: email)
      .limit(1) // Limits to one result to optimize performance
      .get();

  return query.docs.isNotEmpty; // Returns true if user exists
}

Future<UserCredential?> loginUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    userCreds = userCredential;

    return userCredential; // Successfully logged in, return user credential
  } on FirebaseAuthException catch (e) {
    print("Error: ${e.message}"); // Handle login errors
    return null;
  }
}

Future<bool> checkCreds(String email, String password) async {
  try {
    print('haha $email $password');

    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection(
            '/barangayNexus/users/loginCredentials') // Replace with your collection name
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1) // Limits to one result to optimize performance
        .get();
    return query.docs.isNotEmpty; // Returns true if user exists
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

Future<bool> checkEmail(String email) async {
  try {

    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection(
            '/barangayNexus/users/loginCredentials') // Replace with your collection name
        .where('email', isEqualTo: email)
        .limit(1) // Limits to one result to optimize performance
        .get();
    return query.docs.isNotEmpty; // Returns true if user exists
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

Future<Map<String, dynamic>?> getCreds(String email) async {
  try {
    final query = await FirebaseFirestore.instance
        .collection(
            'barangayNexus/users/loginCredentials') // Ensure correct path
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data(); // Return document data
    }

    return null; // Return null if no document found
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching credentials: $e");
    }
    return null; // Return null on error
  }
}

Future<bool> checkName(
  String fn,
  String ln,
) async {
  try {
    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection(
            '/barangayNexus/users/loginCredentials') // Replace with your collection name
        .where('fname', isEqualTo: fn)
        .where('lname', isEqualTo: ln)
        .limit(1) // Limits to one result to optimize performance
        .get();
    return query.docs.isNotEmpty; // Returns true if user exists
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

Future<String> signUpUser({
  required String email,
  required dynamic password,
  required String firstname,
  required String lastname,
  required String gender,
}) async {
  try {
    // Create user in Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Get UID of newly created user
    String uid = userCredential.user!.uid;

    // Store additional user info in Firestore
    await FirebaseFirestore.instance
        .collection('/barangayNexus/users/loginCredentials')
        .doc(uid)
        .set({
      'email': email,
      // 'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await loginUser(email, password);

    return 'Success: User signed up!';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return 'Error: Email is already registered!';
    } else if (e.code == 'weak-password') {
      return 'Error: Password should be at least 6 characters!';
    } else {
      return 'Error: ${e.message}';
    }
  } catch (e) {
    print(e);
    return 'Error: Something went wrong!';
  }
}

Future<String> postGoogleSignup({
  required String firstname,
  required String middlename,
  required String lastname,
  required String subdiv,
  required String street,
  required String housenum,
  required String barangay,
  required String gender,
}) async {
  try {
    // Store additional user info in Firestore
    await FirebaseFirestore.instance
        .collection('/barangayNexus/users/loginCredentials')
        .doc(uid)
        .set({
          'email': FirebaseAuth.instance.currentUser?.email,
      'firstname': firstname,
      'middlename': middlename,
      'lastname': lastname,
      'subdiv': subdiv,
      'street': street,
      'housenum': housenum,
      'barangay': barangay,
      'gender': gender,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Firebaseuserservice.userData = 
    return 'Success: User info successfully set up!';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return 'Error: Email is already registered!';
    } else if (e.code == 'weak-password') {
      return 'Error: Password should be at least 6 characters!';
    } else {
      return 'Error: ${e.message}';
    }
  } catch (e) {
    print(e);
    return 'Error: Something went wrong!';
  }
}
