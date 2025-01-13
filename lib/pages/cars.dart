import 'package:avto_tracker/api_service.dart';
import 'package:avto_tracker/colors.dart';
import 'package:avto_tracker/google_services.dart';
import 'package:avto_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Oglas.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({super.key});

  @override
  CarsPageState createState() => CarsPageState();
}

class CarsPageState extends State<CarsPage> {

  String? _userId;
  bool loading = false;
  final GoogleServices _googleService = GoogleServices();
  List<Oglas> oglasi = [];
  @override
  void initState() {
    super.initState();

    setState(() {
      _userId = _googleService.userId;
    });


    Future<void> fetchOglasi() async {
      final fetchedOglasi = await ApiService().fetchOglasi(_userId!);
      if (fetchedOglasi != null) {
        setState(() {
          oglasi = fetchedOglasi;
          print("count: ${oglasi.length}");
          for(var oglas in oglasi){
            //oglas.izpisi();
            //print("");
          }
        });
      }
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
        await fetchOglasi();
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
          'Moji Avti',
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
        loading ? CircularProgressIndicator(color: Barve().primaryColor) :
        ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: oglasi.length,
          itemBuilder: (context, index) {
            final oglas = oglasi[index];
            return GestureDetector(
              onTap: () async{
                if (oglas.adUrl != null && oglas.adUrl!.isNotEmpty) {
                  final url = Uri.parse(oglas.adUrl!);
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No URL available for this car')),
                  );
                }
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 12),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                            bottom: Radius.circular(15),
                          ),
                          child: oglas.photoUrl != null
                              ? Image.network(
                            oglas.photoUrl!,
                            height: 120*multiplier,
                            width: 160*multiplier,
                            fit: BoxFit.cover,
                          )
                          : Container(height: 200,),
                        ),
                        SizedBox(width: 15*multiplier),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              oglas.letnik != null
                                  ? 'Letnik: ${oglas.letnik}'
                                  : 'Letnik: N/A',
                              style: TextStyle(
                                fontSize: 17*multiplier,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              oglas.mocMotorja != null
                                  ? 'Motor: ${oglas.mocMotorja}'
                                  : 'Motor: N/A',
                              style: TextStyle(
                                fontSize: 17*multiplier,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              oglas.motor != null
                                  ? 'Gorivo: ${oglas.motor}'
                                  : 'Gorivo: N/A',
                              style: TextStyle(
                                fontSize: 17*multiplier,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              oglas.menjalnik != null
                                  ? 'Menjalnik: ${oglas.menjalnik}'
                                  : 'Menjalnik: N/A',
                              style: TextStyle(
                                fontSize: 17*multiplier,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(15*multiplier),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            oglas.name!,
                            style: TextStyle(
                              fontSize: 20*multiplier,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          oglas.price == null ? const SizedBox() :
                          Text(
                            'Cena: ${oglas.price!.substring(0, oglas.price!.length - 2)}€',
                            style: TextStyle(
                              fontSize: 18*multiplier,
                              color: Barve().primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
        :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Za ogled avtov je potrebna prijava',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23*multiplier,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                await GoogleServices().googleSignIn();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50*multiplier),
                ),
                side: BorderSide(
                  color: Barve().primaryColor,
                  width: 3*multiplier,
                ),
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 30*multiplier, vertical: 15*multiplier
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
