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