import 'package:flutter/material.dart';
import 'data_service.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();

  void saveText(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("text", text);
  }

  void readText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedValue = prefs.getString("text");
    if (savedValue != null) {
      _cityTextController.text =
          savedValue; //we used sharedpreference to show last typed city's name
    }
  }

  @override
  void initState() {
    super.initState();
    readText();
  }

  WeatherResponse? _response;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: 350,
            height: 500,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(150))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_response != null)
                  Column(
                    children: [

                      Image.network(_response!.iconUrl),
                      Text(
                        '${(((_response!.tempInfo.temperature) - 32) * (5 / 9)).toStringAsFixed(1)}°c',
                        style: TextStyle(fontSize: 40),
                      ),
                      Text(_response!.weatherInfo.description),
                    ],
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: SizedBox(
                    width: 150,
                    child: TextField(
                        onChanged: (val) {
                          saveText(val);
                        },
                        controller: _cityTextController,
                        decoration: InputDecoration(
                          labelText: 'Enter your Location',
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
                ElevatedButton(onPressed: _search, child: Text('Search'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => _response = response);
  }
}
