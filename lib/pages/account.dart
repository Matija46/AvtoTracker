import 'package:avto_tracker/api_service.dart';
import 'package:avto_tracker/colors.dart';
import 'package:avto_tracker/google_services.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  String? _userId;
  String? email;
  final GoogleServices _googleService = GoogleServices();

  @override
  void initState() {
    super.initState();

    setState(() {
      _userId = _googleService.userId;
      email = _googleService.email;
    });

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
        email = data.session?.user.email;
        //ApiService().insertUser(_userId, ApiService().fCMToken, email);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double multiplier = MediaQuery.sizeOf(context).width / 411;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Moj Račun',
          style: TextStyle(
            fontSize: 24*multiplier,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Barve().primaryColor,
        elevation: 10,
        shadowColor: Barve().primaryColor.withOpacity(0.5),
      ),
      body: Center(
        child: _userId != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 100*multiplier,
              color: Colors.grey,
            ),
            SizedBox(height: 20*multiplier),
            Text(
              email == null ? '' : email!,
              style: TextStyle(
                fontSize: 25*multiplier,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40*multiplier),
            OutlinedButton(
              onPressed: () async {
                await _googleService.signOut();
                setState(() {
                  _userId = null;
                });
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                side: BorderSide(
                  color: Barve().primaryColor,
                  width: 3*multiplier,
                ),
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 30*multiplier,
                  vertical: 15*multiplier,
                ),
              ),
              child: Text(
                'Odjava',
                style: TextStyle(
                  color: Barve().primaryColor,
                  fontSize: 20*multiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Za ogled računa je potrebna prijava',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23*multiplier,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20*multiplier),
            OutlinedButton(
              onPressed: () async {
                await _googleService.googleSignIn();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                side: BorderSide(
                  color: Barve().primaryColor,
                  width: 3*multiplier,
                ),
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 30*multiplier,
                  vertical: 15*multiplier,
                ),
              ),
              child: Text(
                'Prijava',
                style: TextStyle(
                  color: Barve().primaryColor,
                  fontSize: 20*multiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
