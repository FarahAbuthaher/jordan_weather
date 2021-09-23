import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowFavourites extends StatelessWidget {
static const routeName = '/favourites';

  @override
  Widget build(BuildContext context) {
    CollectionReference favourites =
    FirebaseFirestore.instance.collection('favourites');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Container(
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
        child: Center(
          child: StreamBuilder(
              stream: favourites.orderBy('city name').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if ((snapshot.connectionState == ConnectionState.waiting)) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if(snapshot.connectionState == ConnectionState.active && snapshot.data!.docs.isNotEmpty)
                  {
                  return ListView(
                    children: snapshot.data!.docs.map((city) {
                      return Center(
                        child: Card(
                          color: Colors.yellow[400],
                          elevation: 50,
                          child: ListTile(
                            leading: Image.network(
                              'http://openweathermap.org/img/w/${city['icon']}.png',
                            ),
                            title: Text(city['city name']),
                            subtitle: Text(
                                'Temperature: ${city['temp']}C, humidity: ${city['humidity']}\nsaved at ${city['date']}'),
                            trailing: IconButton(onPressed: () =>
                                city.reference.delete(),
                              icon: Icon(
                                Icons.remove_circle_outline, color: Colors.red,)
                              ,),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return Center(child: Text('No favourites added yet!', style: TextStyle(fontSize: 30)));
              }),
        ),
      ),
    );
  }
}
