import 'dart:convert';
import 'dart:core';

import 'package:avto_tracker/google_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'main.dart';



Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");

}

class ApiService {

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("notification token $fCMToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

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




  Future<bool> addTracker(String? znamka, String? model, String? cenaMin, String? cenaMax, String? letnikMin, String? letnikMax, String? gorivo, String? prevozeniMax) async {
    print("$znamka, $model, $cenaMin, $cenaMax, $letnikMin, $letnikMax, $gorivo, $prevozeniMax");
    return false;
    /*const String baseUrl = 'http://127.0.0.1:5000/add-scraper';
    final url = Uri.parse('$baseUrl?znamka=$znamka');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response if needed
        final data = jsonDecode(response.body);
        print('Scraper Response: $data');
        return true;
      } else {
        print('Failed to call scraper. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error calling scraper: $e');
      return false;
    }*/
  }
}
class Tracker {
  String? brand;
  String? model;
  String? minPrice;
  String? maxprice;
  String? minYear;
  String? maxYear;
  String? maxMilage;
  String? fuel;
  Tracker({
    this.brand,
    this.model,
    this.minPrice,
    this.maxprice,
    this.minYear,
    this.maxYear,
    this.maxMilage,
    this.fuel,
  });
}
class Oglas {
  String? id;
  int? avtonetID;
  String? userID;
  String? name;
  String? price;
  int? letnik;
  String? motor;
  String? menjalnik;
  String? mocMotorja;
  String? photoUrl;
  String? adUrl;

  Oglas({
    required this.id,
    required this.avtonetID,
    required this.userID,
    required this.name,
    required this.price,
    required this.letnik,
    required this.motor,
    required this.menjalnik,
    required this.mocMotorja,
    required this.photoUrl,
    required this.adUrl,
  });
  izpisi(){
    print("id --- $id");
    print("avtonet id --- $avtonetID");
    print("user id--- $userID");
    print("name --- $name");
    print("price --- $price");
    print("letnik --- $letnik");
    print("motor --- $motor");
    print("menjalnik --- $menjalnik");
    print("moc motorja --- $mocMotorja");
    print("photo url --- $photoUrl");
    print("ad url --- $adUrl");
  }
  factory Oglas.fromJson(Map<String, dynamic> json) {
    return Oglas(
      id: json['id'],
      avtonetID: json['avtonet_id'],
      userID: json['user_id'],
      name: json['name'],
      price: json['price'],
      letnik: json['letnik'],
      motor: json['motor'],
      menjalnik: json['menjalnik'],
      mocMotorja: json['moc_motorja'],
      photoUrl: json['photo_url'],
      adUrl: json['ad_url'],
    );
  }
}

