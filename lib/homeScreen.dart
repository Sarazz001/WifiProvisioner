import 'package:flutter/material.dart';
import 'deviceScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
	@override
	Widget build( BuildContext context ) {
		return Scaffold(
			appBar: AppBar(	
					title: Text('Home Controller'),
					backgroundColor: Colors.deepPurpleAccent,
			),
			body: Container(
				padding: const EdgeInsets.all(16.0),
				decoration: BoxDecoration(
					 gradient: LinearGradient(
						colors: [Colors.greenAccent, Colors.blueAccent],
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
					 ),
				 ),
					child: Column(
						children: [
							ListTile (
								title: Text('Floor'),
								tileColor: Colors.lightBlueAccent,
								textColor: Colors.black,
								leading: Icon(Icons.home),
								onTap: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceListScreen( mode: DeviceScreenType.HOME )),
									);
								},
							),
							SizedBox(height: 15.0),
							ListTile(
								title: Text('Kitchen'),
								tileColor: Colors.lightBlueAccent,
								textColor: Colors.black,
								leading: Icon(Icons.kitchen),
								onTap: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceListScreen( mode: DeviceScreenType.KITCHEN )),
									);
								},
							),
						],
					),
			)
		);
  }
} 
