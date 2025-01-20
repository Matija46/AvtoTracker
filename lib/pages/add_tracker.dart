import 'package:avto_tracker/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avto_tracker/colors.dart';
import 'package:avto_tracker/google_services.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';


import '../main.dart';

class AddTrackerPage extends StatefulWidget {
  const AddTrackerPage({super.key});

  @override
  AddTrackerPageState createState() => AddTrackerPageState();
}

class AddTrackerPageState extends State<AddTrackerPage> {
  String? _userId;
  bool addingTracker = false;
  final GoogleServices _googleService = GoogleServices();

  final List<String> brands = [
    'Abarth', 'AEV', 'Aiways', 'Aixam', 'Alfa Romeo', 'Alpine', 'Artega', 'Aston Martin',
    'Audi', 'Austin', 'Autobianchi', 'Bentley', 'BMW', 'Borgward', 'Brilliance', 'Bugatti',
    'Buick', 'BYD', 'Cadillac', 'Casalini', 'Caterham', 'Chatenet', 'Chevrolet', 'Chrysler',
    'Citroen', 'Cobra', 'Cupra', 'Dacia', 'Daewoo', 'DAF', 'Daihatsu', 'DFSK', 'DKW', 'Dodge',
    'Donkervoort', 'Dongfeng', 'DR Automobiles', 'DS Automobiles', 'EV', 'EVO', 'Ferrari', 'Fiat',
    'Fisker', 'Ford', 'Forthing', 'Geely', 'Genesis', 'GMC', 'Greatwall', 'Grecav', 'Hansa',
    'Honda', 'Hongqi', 'Hummer', 'Hyundai', 'Infiniti', 'Iso', 'Isuzu', 'Iveco', 'JAC', 'Jaguar',
    'JBA', 'JDM', 'Jeep', 'Kia', 'KG Mobility', 'KTM', 'Lada', 'Lamborghini', 'Lancia',
    'LandRover', 'LandWind', 'Lexus', 'Ligier', 'Lincoln', 'London Taxi', 'Lotus', 'LuAZ',
    'Lynk&Co', 'Mahindra', 'Maruti', 'Maserati', 'Maybach', 'Mazda', 'McLaren', 'Mercedes-Benz',
    'MG', 'Microcar', 'Mini', 'Mitsubishi', 'Morgan', 'Moskvič', 'MPM Motors', 'Nissan', 'NSU',
    'Oldsmobile', 'Opel', 'Peugeot', 'Piaggio', 'Plymouth', 'Polestar', 'Pontiac', 'Porsche',
    'Proton', 'Puch', 'Renault', 'Replica', 'Rolls-Royce', 'Rosengart', 'Rover', 'Saab', 'Saturn',
    'Seat', 'Shuanghuan', 'Simca', 'Singer', 'Smart', 'Spyker', 'SsangYong', 'Subaru', 'Suzuki',
    'Škoda', 'Talbot', 'Tata', 'Tavria', 'Tazzari', 'Tesla', 'Toyota', 'Trabant', 'Triumph',
    'TVR', 'UAZ', 'Vauxhall', 'Venturi', 'Volga', 'Volvo', 'Volkswagen', 'Voyah', 'Wartburg',
    'Westfield', 'Wiesmann', 'XEV', 'Zastava', 'ZAZ', 'Zhidou'
  ];
  final List<String> fuelTypes = ['bencin', 'dizel', 'hibridni pogon(vsi)', 'HEV - hibrid', 'PHEV - plugin hibrid', 'e-pogon', 'plin'];
  final List<String> prices = ['500', '1000', '1500', '2000', '2500', '3000', '3500', '4000', '4500', '5000', '6000', '7000', '8000', '9000', '10000', '11000', '12000', '13000', '14000', '15000', '16000', '17000', '18000', '19000', '20000', '22500', '25000', '27500', '30000', '35000', '40000', '45000', '50000', '60000', '70000', '80000', '90000', '100000'];
  final List<String> years = ['2025', '2024', '2023', '2022', '2021', '2020', '2019', '2018', '2017', '2016', '2015', '2014', '2013', '2012', '2011', '2010', '2009', '2008', '2007', '2006', '2005', '2004', '2003', '2002', '2001', '2000', '1999', '1995', '1990', '1985', '1980', '1975', '1970'];
  final List<String> mileages = ['5000', '10000', '15000', '20000', '25000', '50000', '75000', '100000', '125000', '150000', '200000', '250000'];

  String? selectedBrand;
  String? enteredModel;
  String? selectedMinPrice;
  String? selectedMaxPrice;
  String? selectedMinYear;
  String? selectedMaxYear;
  String? selectedMaxMileage;
  String? selectedFuelType;

  @override
  void initState() {
    super.initState();
    if(mounted) {
      setState(() {
        _userId = _googleService.userId;
      });
    }

    supabase.auth.onAuthStateChange.listen((data) {
      if(mounted) {
        setState(() {
          _userId = data.session?.user.id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double multiplier = MediaQuery.sizeOf(context).width / 411;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40 * multiplier),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Dodaj Sledilnik',
          style: TextStyle(
            fontSize: 24 * multiplier,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Barve().primaryColor,
        elevation: 15,
        shadowColor: Barve().primaryColor.withOpacity(0.6),
      ),
      body: Stack(
        children: [
          if (addingTracker)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          if (addingTracker)
          Center(
            child: CircularProgressIndicator(color: Barve().primaryColor),
          ),
          AbsorbPointer(
            absorbing: addingTracker,
            child: Padding(
              padding: EdgeInsets.all(16.0 * multiplier),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _manualDropdown('Znamka', brands, selectedBrand, (value) => setState(() => selectedBrand = value)),
                          _manualTextInput('Model', 'Vnesite model', enteredModel, (value) => setState(() => enteredModel = value)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _manualDropdown('Cena od', prices, selectedMinPrice, (value) => setState(() => selectedMinPrice = value)),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _manualDropdown('Cena do', prices, selectedMaxPrice, (value) => setState(() => selectedMaxPrice = value)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _manualDropdown('Letnik od', years, selectedMinYear, (value) => setState(() => selectedMinYear = value)),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _manualDropdown('Letnik do', years, selectedMaxYear, (value) => setState(() => selectedMaxYear = value)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _manualDropdown('Prevoženi KM', mileages, selectedMaxMileage, (value) => setState(() => selectedMaxMileage = value)),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _manualDropdown('Gorivo', fuelTypes, selectedFuelType, (value) => setState(() => selectedFuelType = value)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * multiplier),
                  ElevatedButton(
                    onPressed: _saveTracker,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith((states) => null),
                      elevation: WidgetStateProperty.resolveWith((states) => 0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade700,
                            Colors.blue.shade300,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: const Text(
                        'Shrani Sledilnik',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _manualDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () => _showPicker(context, items, onChanged),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selectedValue ?? 'Izberite',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _manualTextInput(String label, String hint, String? value, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 16)),
            TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTracker() async {
    setState(() => addingTracker = true);
    if (selectedBrand == null || selectedBrand!.isEmpty) {
      Fluttertoast.showToast(
        msg: "Izberite znamko!",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Barve().errorColor,
        textColor: Colors.white,
      );
    } else {

      dynamic response1 = await ApiService().insertTracker(
          _userId!,
          selectedBrand,
          enteredModel,
          selectedMinPrice,
          selectedMaxPrice,
          selectedMinYear,
          selectedMaxYear,
          selectedFuelType,
          selectedMaxMileage
      );
      print("responseeeeeeeeeee ::: $response1");
      String trackerid = response1[0]['id'];
      print("TRACKER IDDD ::: $trackerid");
      String? notTok = await ApiService().initNotifications();
      print("nottok: $notTok");
      bool response = await ApiService().addTracker(
        _userId!,
        trackerid,
        selectedBrand,
        enteredModel,
        selectedMinPrice,
        selectedMaxPrice,
        selectedMinYear,
        selectedMaxYear,
        selectedFuelType,
        selectedMaxMileage,
        notTok,
      );




      if (response) {
        Navigator.of(context).pop(true);
      } else {
        Fluttertoast.showToast(
          msg: "Dodajanje sledilnika ni uspelo!",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
    if(mounted) {
      setState(() => addingTracker = false);
    }
  }

  void _showPicker(BuildContext context, List<String> items, ValueChanged<String?> onSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    onSelected(items[index]);
                  },
                  children: items.map((item) => Text(item)).toList(),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Zapri', style: TextStyle(color: Colors.blue)),
              )
            ],
          ),
        );
      },
    );
  }
}
