import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _auth.currentUser != null;

  // 1. Login Logic
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(), 
        password: password,
      );
      
//    final user = _auth.currentUser;
//  if (user != null) {
//   print("STARTING ENGINE");
//   NotificationEngine._listenRealTime("test");
// }


    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      if (e.code == 'user-not-found') errorMessage = "No user found with this email.";
      else if (e.code == 'wrong-password') errorMessage = "Incorrect password.";
      else if (e.code == 'invalid-credential') errorMessage = "Invalid login credentials.";
      throw errorMessage; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// 2. Google Sign-In Method
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // If the user clicks outside the account picker dialog (cancels the operation)
      if (googleUser == null) {
        throw "google_signin_cancelled"; // Error key for localization
      } 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      // Pass the specific cancellation key or forward the general error message
      if (e == "google_signin_cancelled") {
        throw e;
      }
      throw "Google Sign-In failed: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. Registration
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), 
        password: password
      );
      await result.user?.updateDisplayName(fullName);
      
      await _db.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'fullName': fullName,
        'email': email,
        'profile_url': '',
      });

    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed.";
      if (e.code == 'email-already-in-use') errorMessage = "This email is already in use.";
      else if (e.code == 'weak-password') errorMessage = "The password is too weak.";
      throw errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. Save/Update additional user data
  Future<void> saveAdditionalUserData({
    required String age,
    required String gender,
    required String weight,
    required String height,
    required String country,
  }) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid != null) {
        await _db.collection('users').doc(uid).set({
          'uid': uid,
          'age': age,
          'gender': gender,
          'weight': weight,
          'height': height,
          'country': country,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw "Failed to save profile data: ${e.toString()}";
    }
  }

//  User Profile Image - Version 2.0
  Future<void> updateProfileImage(File imageFile) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Cloudinary configuration credentials
      String cloudName = "drdeqb1lg"; 
      String uploadPreset = "profile_images";

      // Cloudinary Upload API endpoint
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      
      // Initialize multipart request for file upload
      var request = http.MultipartRequest("POST", uri);
      
      // Add required fields and the image file to the request
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      // Execute the request and capture the response
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var jsonResponse = jsonDecode(responseString);

      if (response.statusCode == 200) {
        // Extract the secure URL from Cloudinary response
        String imageUrl = jsonResponse['secure_url']; 

        // Update the 'profile_url' field in the user's Firestore document
        await updateUserData({'profile_url': imageUrl});
        
        debugPrint("Upload Success: $imageUrl");
      } else {
        // Handle Cloudinary specific errors
        throw "Upload failed: ${jsonResponse['error']['message']}";
      }
    } catch (e) {
      debugPrint("Error in updateProfileImage: $e");
      throw "Failed to upload image: $e";
    } finally {
      // Reset loading state and notify UI
      _isLoading = false;
      notifyListeners();
    }
  }

  // [NEW] Update Any User Data (for Edit Profile)
  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      throw "Update failed: $e";
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }
}


