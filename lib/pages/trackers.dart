import 'package:avto_tracker/colors.dart';
import 'package:avto_tracker/google_services.dart';
import 'package:avto_tracker/main.dart';
import 'package:avto_tracker/pages/add_tracker.dart';
import 'package:avto_tracker/pages/tracker_details.dart';
import 'package:flutter/material.dart';

import '../api_service.dart';
import '../models/Tracker.dart';

class TrackersPage extends StatefulWidget {
  const TrackersPage({super.key});

  @override
  TrackersPageState createState() => TrackersPageState();
}

class TrackersPageState extends State<TrackersPage> {

  String? _userId;
  List<Tracker> trackers = [];
  bool loading = false;
  final GoogleServices _googleService = GoogleServices();

  Future<void> fetchTrackers() async {
    final fetchedOglasi = await ApiService().fetchTrackers(_userId!);
    if (fetchedOglasi != null) {
      if(mounted) {
        setState(() {
          trackers = fetchedOglasi;
          print("count: ${trackers.length}");
          for (var tracker in trackers) {
            tracker.izpisi();
            print("");
          }
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();

    if(mounted) {
      setState(() {
        _userId = _googleService.userId;
      });
    }

    supabase.auth.onAuthStateChange.listen((data) async {
      if(mounted) {
        setState(() {
          loading = true;
          _userId = data.session?.user.id;
          //ApiService().insertUser(_userId, ApiService().fCMToken, data.session?.user.email);
        });
      }
      if(_userId != null) {
        await fetchTrackers();
      }
      if(mounted) {
        setState(() {
          loading = false;
        });
      }
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
        child: _userId != null ?
        Stack(
          children: [
            if(trackers.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(15.0*multiplier),
                child: Text(
                  "Trenutno nimate nobenih sledilnikov",
                  style: TextStyle(
                    fontSize: 23*multiplier,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.all(16.0 * multiplier),
              itemCount: trackers.length,
              itemBuilder: (context, index) {
                final tracker = trackers[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0 * multiplier),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0 * multiplier),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tracker.brand ?? '',
                              style: TextStyle(
                                fontSize: 18 * multiplier,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8 * multiplier),
                            Text(
                              tracker.model == null ? 'Vsi modeli' : tracker.model == '' ? 'Vsi modeli' : tracker.model!,
                              style: TextStyle(
                                fontSize: 16 * multiplier,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrackerDetails(tracker: tracker),
                              ),
                            );
                            if (result == true) {
                              await fetchTrackers();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Barve().primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0 * multiplier),
                            ),
                          ),
                          child: Text(
                            'Več',
                            style: TextStyle(
                              fontSize: 16 * multiplier,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(16.0*multiplier),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTrackerPage(),
                      ),
                    );
                    if (result == true) {
                      await fetchTrackers();
                    }
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