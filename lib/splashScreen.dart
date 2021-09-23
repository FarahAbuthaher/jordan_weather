import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CitiesWeatherJO())));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: width * 0.2,
                height: height*0.2,
                child: CircleAvatar(
                    radius:100, backgroundImage: NetworkImage('https://cdn.dribbble.com/users/915711/screenshots/5827243/weather_icon3.png')
                )),
            Text('Done by Farah Abuthaher.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),)
          ],
        ),
      ),
    );
  }
}

