import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jordan_weather/citiesAPI.dart';
import 'package:jordan_weather/splashScreen.dart';
import 'package:jordan_weather/weatherAPI.dart';

import 'favourites.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(JordanWeather());
}

class JordanWeather extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather in Jordan',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: {'/': (context) => SplashScreen(),
          CitiesWeatherJO.routeName:(context)=> CitiesWeatherJO(),
        ShowFavourites.routeName: (context)=> ShowFavourites()},
      initialRoute: '/',
    );
  }
}

class CitiesWeatherJO extends StatefulWidget {
  static const routeName = '/home';
  @override
  _CitiesWeatherJOState createState() => _CitiesWeatherJOState();
}

class _CitiesWeatherJOState extends State<CitiesWeatherJO> {
  CityData cityChoice = CityData(
      id: 245915,
      name: "Zaḩar",
      country: Country.JO,
      coord: Coord(lon: 35.7775, lat: 32.566669));
  String? dropdownCity;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in Jordan'),
        actions: [Tooltip(message: 'Favourites', child: IconButton(onPressed: ()=> Navigator.pushNamed(context, ShowFavourites.routeName), icon: Icon(Icons.star, color: Colors.yellow,),),)],
      ),
      body: FutureBuilder(
        future: readCities(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('${snapshot.error} has occurred.'),
            );
          else if (snapshot.hasData) {
            final List<CityData> cities = snapshot.data as List<CityData>;
            return Center(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          colors: [
                        Colors.deepOrange[500]!,
                        Colors.orange[900]!,
                        Colors.orange,
                        Colors.orange[400]!
                      ])),
                  width: width,
                  height: height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // drop down values
                        Padding(
                          padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                          child: Card(
                            elevation: 50,
                            color: Colors.yellow[300],
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' Choose a city:',
                                  style: TextStyle(fontSize: 15),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: dropdownCity,
                                      icon: Icon(Icons.arrow_downward),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownCity = newValue!;
                                          cityChoice = cities.firstWhere(
                                              (element) =>
                                                  element.id ==
                                                  int.parse(newValue));
                                        });
                                      },
                                      items: cities.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id.toString(),
                                          child: Text(value.name),
                                        );
                                      }).toList()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.wb_sunny_outlined,
                              size: 80,
                              color: Colors.deepOrange,
                            ),
                            Text('Welcome, ${cityChoice.name}!',
                                style: TextStyle(fontSize: 30)),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                                'this city ID is ${cityChoice.id} / coordinates - lon: ${cityChoice.coord.lon}, lat: ${cityChoice.coord.lat}.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: getWeatherData(cityChoice.id),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError)
                              return Center(
                                child: Text(
                                    "Can't retrieve city weather at this time."),
                              );
                            else if (snapshot.hasData) {
                              final WeatherData weather =
                                  snapshot.data as WeatherData;
                              return Container(
                                color: Colors.yellow[400],
                                width: 300,
                                height: 400,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      height: 350,
                                      child: Card(
                                        color: Colors.yellow[400],
                                        elevation: 60,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(alignment: Alignment.topRight, child: Tooltip(message: 'add to favourites',child: IconButton(onPressed: () => addToFavourites(cityChoice.name,weather.main.temp, weather.main.humidity, weather.weather.first.icon), icon: Icon(Icons.favorite, color: Colors.red)))),
                                              Row(children: [
                                                Image.network(
                                                  'http://openweathermap.org/img/w/${weather.weather.first.icon}.png',
                                                ),
                                                Text(
                                                    '${weather.main.temp} C / ${weather.weather.first.main}',
                                                    style:
                                                        TextStyle(fontSize: 18)),

                                              ]),
                                              SizedBox(
                                                height: 18,
                                              ),
                                              Row(children: [
                                                Icon(Icons.beach_access_sharp,
                                                    color: Colors.green),
                                                Text(
                                                    'Feels like: ${weather.main.feelsLike} C',
                                                    style:
                                                        TextStyle(fontSize: 15))
                                              ]),
                                              SizedBox(
                                                height: 18,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.whatshot,
                                                    color: Colors.orange,
                                                  ),
                                                  Text(
                                                      'Range: ${weather.main.tempMin} C',
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  Icon(Icons.arrow_right),
                                                  Text(
                                                      '${weather.main.tempMax} C')
                                                ],
                                              ),
                                              SizedBox(
                                                height: 18,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.water_rounded,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(
                                                      'Humidity: ${weather.main.humidity}',
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                'wind - speed: ${weather.wind.speed}, blow direction from north: ${weather.wind.deg} degrees',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black38),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
  addToFavourites(String name, double temp, int humidity, String icon){
    CollectionReference favourites =
    FirebaseFirestore.instance.collection('favourites');

    favourites.add({
      'city name': name,
      'date': DateTime.now()
          .toString(),
      'temp': temp,
      'humidity': humidity,
      'icon': icon
    }).then((uid) => {
      Fluttertoast.showToast(msg: 'Added to favourites!', webBgColor: '#69615B'),
    });
  }
}
