class Tracker {
  String? id;
  String? userID;
  String? brand;
  String? model;
  String? minPrice;
  String? maxprice;
  String? minYear;
  String? maxYear;
  String? maxMilage;
  String? fuel;
  Tracker({
    this.id,
    this.userID,
    this.brand,
    this.model,
    this.minPrice,
    this.maxprice,
    this.minYear,
    this.maxYear,
    this.maxMilage,
    this.fuel,
  });
  izpisi(){
    print("id --- $id");
    print("user id--- $userID");
    print("brand --- $brand");
    print("model --- $model");
    print("priceMin --- $minPrice");
    print("priceMax --- $maxprice");
    print("minYaer --- $minYear");
    print("maxYaar --- $maxYear");
    print("maxMilage --- $maxMilage");
    print("fuel --- $fuel");
  }
  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      id: json['id'],
      userID: json['userID'],
      brand: json['znamka'],
      model: json['model'],
      minPrice: json['cenaMin'],
      maxprice: json['cenaMax'],
      minYear: json['letnikMin'],
      maxYear: json['letnikMax'],
      fuel: json['gorivo'],
      maxMilage: json['kilometri_max'],
    );
  }

}