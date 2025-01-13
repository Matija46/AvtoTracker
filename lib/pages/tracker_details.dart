import 'package:avto_tracker/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api_service.dart';
import '../models/Tracker.dart';

class TrackerDetails extends StatelessWidget {
  final Tracker tracker;

  TrackerDetails({required this.tracker});

  @override
  Widget build(BuildContext context) {
    double multiplier = MediaQuery.sizeOf(context).width / 411;

    if(tracker.minYear == null || tracker.minYear == 'null'){
      tracker.minYear == '';
    }
    if(tracker.maxYear == null || tracker.maxYear == 'null'){
      tracker.maxYear == '';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Podrobnosti"),
        backgroundColor: Barve().primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(6.0*multiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 100*multiplier,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(height: 10*multiplier),
                  Text(
                    tracker.brand ?? "",
                    style: TextStyle(
                      fontSize: 24*multiplier,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tracker.model == null ? 'Vsi modeli' : tracker.model == '' ? 'Vsi modeli' : tracker.model!,
                    style: TextStyle(
                      fontSize: 18*multiplier,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20*multiplier),
            Divider(color: Colors.grey),
            SizedBox(height: 10*multiplier),
            buildDetailRow("Cena:", "${tracker.minPrice ?? "-"} - ${tracker.maxprice ?? "-"}",multiplier),
            buildDetailRow("Letnik:", tracker.minYear == '' && tracker.maxYear == '' ? "vsi letniki" :  "${tracker.minYear ?? "-"} - ${tracker.maxYear ?? "-"}",multiplier),
            buildDetailRow("Kilometri:", tracker.maxMilage ?? "∞",multiplier),
            buildDetailRow("Gorivo:", tracker.fuel ?? "vse",multiplier),
            SizedBox(height: 20*multiplier),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  bool response = await ApiService().deleteTracker(tracker.id!);
                  if(response){
                    Navigator.of(context).pop(true);
                  }
                  else{
                    Fluttertoast.showToast(
                      msg: "Odstranjevanje ni uspelo",
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                child: Text(
                  "Izbriši sledilnik",
                  style: TextStyle(
                    fontSize: 18*multiplier,
                    color: Colors.red
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value, double multiplier) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0*multiplier,horizontal: 20*multiplier),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16*multiplier,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}