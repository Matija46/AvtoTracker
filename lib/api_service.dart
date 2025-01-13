import 'dart:convert';
import 'dart:core';

import 'package:avto_tracker/google_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'models/Oglas.dart';
import 'models/Tracker.dart';



Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");

}

class ApiService {

  final _firebaseMessaging = FirebaseMessaging.instance;

  String? fCMToken;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    fCMToken = await _firebaseMessaging.getToken();
    print("notification token $fCMToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  /*Future<bool> insertUser(String? id, String? notificationToken, String? email) async {
    if(id == null || email == null || notificationToken == null){
      return false;
    }
    try {
      final response = await supabase.from('Profiles').insert({
        'id': id,
        'notification_token': notificationToken,
        'email': email,
      });

      if (response.error == null) {
        print('Notification successfully inserted: ${response.data}');
        return true;
      } else {
        print('Failed to insert notification: ${response.error?.message}');
        return false;
      }
    } catch (e) {
      print('Error inserting notification: $e');
      return false;
    }
  }*/

  Future<List<Oglas>?> fetchOglasi(String id) async {
    try {
      final List<dynamic> response = await supabase
          .from('oglasi')
          .select()
          .eq('user_id', id);
      print(response);
      return response.map((item) => Oglas.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching oglasi: $e');
      return null;
    }
  }

  Future<List<Tracker>?> fetchTrackers(String id) async {
    try {
      final List<dynamic> response = await supabase
          .from('Trackers')
          .select()
          .eq('userID', id);
      print(response);
      return response.map((item) => Tracker.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching oglasi: $e');
      return null;
    }
  }
  Future<bool> insertTracker(String userID, String? znamka, String? model, String? cenaMin, String? cenaMax, String? letnikMin, String? letnikMax, String? gorivo, String? kilometriMax) async {
    print("inserting!!!!!!!!!!!!!!!!!");
    try {
      final trackerData = {
        'userID': userID ?? '',
        'znamka': znamka ?? '',
        'model': model ?? '',
        'cenaMin': cenaMin ?? '',
        'cenaMax': cenaMax ?? '',
        'letnikMin': letnikMin ?? '',
        'letnikMax': letnikMax ?? '',
        'gorivo': gorivo ?? '',
        'kilometriMax': kilometriMax ?? '',
      };

      final response = await supabase.from('Trackers').insert(trackerData);

      if (response.error == null) {
        print('Tracker successfully added: ${response.data}');
        return true;
      } else {
        print('Failed to add tracker: ${response.error?.message}');
        return false;
      }
    } catch (e) {
      print('Error adding tracker: $e');
      return false;
    }
  }
  Future<bool> deleteTracker(String id) async {
    print("deleting tracker with id: $id");
    try {
      final response = await supabase
          .from('Trackers')
          .delete()
          .eq('id', id);

      if (response.error == null) {
        print('Tracker successfully deleted: ${response.data}');
        return true;
      } else {
        print('Failed to delete tracker: ${response.error?.message}');
        return false;
      }
    } catch (e) {
      return true;
    }
  }
  Future<bool> addTracker(String id, String? znamka, String? model, String? cenaMin, String? cenaMax, String? letnikMin, String? letnikMax, String? gorivo, String? prevozeniMax, String? notificationToken) async {
    print(" $znamka, $model, $cenaMin, $cenaMax, $letnikMin, $letnikMax, $gorivo, $prevozeniMax");
    String baseUrl = 'https://avtotracker-fcdtewhqgkajhteq.northeurope-01.azurewebsites.net/add-scraper?userID=$id&znamka=$znamka&notificationToken=$notificationToken';

    if(model != null) {
      baseUrl += "&model=$model";
    }
    if(cenaMin != null){
      baseUrl += "&cenaMin=$cenaMin";
    }
    if(cenaMax != null){
      baseUrl += "&cenaMax=$cenaMax";
    }
    if(letnikMin != null){
      baseUrl += "&letnikMin=$letnikMin";
    }
    if(letnikMax != null){
      baseUrl += "&letnikMax=$letnikMax";
    }
    if(gorivo != null){
      baseUrl += "&bencin=$gorivo";
    }
    if(prevozeniMax != null){
      baseUrl += "&prevozeniMax=$prevozeniMax";
    }
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Scraper Response: $data');
        return true;
      } else {
        print('Failed to call scraper. Status code: ${response.statusCode}');
        return true;
      }
    } catch (e) {
      print('Error calling scraper: $e');
      return true;
    }
  }
}