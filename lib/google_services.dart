import 'package:avto_tracker/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';

class GoogleServices {
  static const _webClientId =
      '269797533471-5nagtbku5itq27i5n2cdib297c0h88i8.apps.googleusercontent.com';
  static const _iosClientId =
      '269797533471-bms6e35s2hmgsom0n15637u44898md0j.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _iosClientId,
    serverClientId: _webClientId,
  );

  String? _userId;
  String? _email;

  String? get userId => _userId;
  String? get email => _email;

  bool get isLoggedIn => _userId != null;

  Future<AuthResponse> googleSignIn() async {
    final googleUser = await _googleSignIn.signIn();



    if (googleUser == null) {
      throw 'Sign-in was cancelled or failed.';
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final authResponse = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    _userId = authResponse.session?.user?.id;
    _email = authResponse.session?.user?.email;

    String? nottok = await ApiService().initNotifications();

    if(nottok != null && _userId != null && _email != null){
      ApiService().createUser(_userId!, nottok, _email!);
    }


    return authResponse;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await supabase.auth.signOut();
    _userId = null;
    _email = null;
  }
}
