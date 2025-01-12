import 'package:avto_tracker/colors.dart';
import 'package:avto_tracker/google_services.dart';
import 'package:avto_tracker/main.dart';
import 'package:avto_tracker/pages/add_tracker.dart';
import 'package:flutter/material.dart';

class TrackersPage extends StatefulWidget {
  const TrackersPage({super.key});

  @override
  TrackersPageState createState() => TrackersPageState();
}

class TrackersPageState extends State<TrackersPage> {

  String? _userId;
  final GoogleServices _googleService = GoogleServices();

  @override
  void initState() {
    super.initState();

    setState(() {
      _userId = _googleService.userId;
    });

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
        print("userID :: ${_userId!}");

      });
    });

  }
  @override
  Widget build(BuildContext context) {
    double multiplier = MediaQuery.sizeOf(context).width/ 411;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sledilniki',
          style: TextStyle(
            fontSize: 24*multiplier,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Barve().primaryColor,
        elevation: 15,
        shadowColor: Barve().primaryColor.withOpacity(0.6),
      ),
      body: Center(
        child: _userId != null
            ? Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(16.0*multiplier),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddTrackerPage()),
                    );
                  },
                  child: Container(
                    width: 70.0*multiplier,
                    height: 70.0*multiplier,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Barve().primaryColor,
                        width: 2.0*multiplier
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Barve().primaryColor,
                      size: 40.0*multiplier,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [

              ],
            )
          ],
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Za ogled sledilnikov je potrebna',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23*multiplier,
              ),
            ),
            SizedBox(height: 20*multiplier),
            OutlinedButton(
              onPressed: () async {
                await GoogleServices().googleSignIn();
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
                    horizontal: 30*multiplier, vertical: 15*multiplier),
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
