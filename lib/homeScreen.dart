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
								title: Text( DeviceScreenType.home.name ),
								tileColor: Colors.lightBlueAccent,
								textColor: Colors.black,
								leading: Icon( Icons.home ),
								onTap: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceListScreen( mode: DeviceScreenType.home )),
									);
								},
							),
							SizedBox(height: 15.0),
							ListTile(
								title: Text( DeviceScreenType.hall.name ),
								tileColor: Colors.lightBlueAccent,
								textColor: Colors.black,
								leading: Icon( Icons.meeting_room ),
								onTap: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceListScreen( mode: DeviceScreenType.hall )),
									);
								},
							),
							SizedBox( height: 15.0 ),
							ListTile(
								title: Text( DeviceScreenType.kitchen.name ),
								tileColor: Colors.lightBlueAccent,
								textColor: Colors.black,
								leading: Icon( Icons.kitchen ),
								onTap: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceListScreen(mode: DeviceScreenType.kitchen)),
									);
								},
							),
							SizedBox( height: 15.0 ),
							ListTile(
								title: Text( DeviceScreenType.room1.name ),
								tileColor: Colors.lightBlueAccent,
								textColor: Colors.black,
								leading: Icon( Icons.bedroom_parent_rounded ),
								onTap: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceListScreen(mode: DeviceScreenType.room1)),
									);
								},
							),
							SizedBox( height: 15.0 ),
							ListTile(
								title: Text( DeviceScreenType.room2.name ),
								tileColor: Colors.lightBlueAccent,
								textColor: Colors.black,
								leading: Icon( Icons.bedroom_parent_rounded ),
								onTap: () {
									Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceListScreen(mode: DeviceScreenType.room2)),
									);
								},
							)
						],
					),
			)
		);
  }
} 
