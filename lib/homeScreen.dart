import 'package:flutter/material.dart';
import 'deviceScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen( {super.key} );
	@override
	Widget build( BuildContext context ) {
		return Scaffold(
			appBar: AppBar(	
					title: Text( 'Home Controller' ),
					leading: Icon( Icons.home_work_outlined ),
					backgroundColor: Colors.teal.shade300,
			),
			body: Container (
				padding: const EdgeInsets.all( 16.0 ),
				decoration: const BoxDecoration(
					 gradient: LinearGradient(
						colors: [ Colors.greenAccent, Colors.blueAccent ],
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
					 ),
				),
				child: SingleChildScrollView(
						child: ConstrainedBox(
							constraints: BoxConstraints(
								minHeight: MediaQuery.of(context).size.height,
							),
							child: Column(
								children: [
									..._buildRoomTiles( context ),
								],
							),
						),
			  )
			)
		);
  }
	List<Widget> _buildRoomTiles( BuildContext context ) {
		final places = [
			{
				'type' : DeviceScreenType.home,
				'icon' : Icons.home,
			},
			{
				'type' : DeviceScreenType.hall,
				'icon' : Icons.kitchen,
			},
			{
				'type' : DeviceScreenType.kitchen,
				'icon' : Icons.home,
			},
			{
				'type' : DeviceScreenType.room1,
				'icon' : Icons.bed_rounded,
			},
			{
				'type' : DeviceScreenType.room2,
				'icon' : Icons.bed_rounded,
			},
		];
		return places.map( ( place ) {
			return Column(
				children: [
					ListTile(
						title: Text(
							(place['type'] as DeviceScreenType).name,
							style: const TextStyle( color:  Colors.black, fontSize: 16, fontWeight: FontWeight.bold ),
						),
						tileColor: Colors.white,
						leading: Icon( place['icon'] as IconData ),
						shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular( 12 ) ),
						onTap: () {
							final modeNow = place['type'] as DeviceScreenType;
 							Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => DeviceListScreen(mode: modeNow ),
								),
							);
 						},
					),
					Divider(),
					const SizedBox( height:  12 ),
				],
			);
		}).toList();
	}

} 
