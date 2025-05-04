import 'dart:ffi';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
enum DeviceScreenType { HOME, KITCHEN, HALL, ROOM1,ROOM2 }


class Device {
	final String deviceId;
	final String deviceAccess;

	Device( { required this.deviceId, required this.deviceAccess } );
}

class DeviceListScreen extends StatefulWidget {
	final DeviceScreenType mode;

	const DeviceListScreen( {
		super.key,
		required this.mode,
});

	@override
	_DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
		List<Device> homeDevices = [];
		List<Device> kitchenDevices = [];
		List<Device> hallDevices = [];
		List<Device> room1Devices = [];
		List<Device> room2Devices = [];

		int count = 0;
		bool _showAddDevice = false;
		final _deviceAddKey = GlobalKey<FormState>();

		final TextEditingController idController = TextEditingController();
		final TextEditingController accessController = TextEditingController();

			void _addDevice() {
					final String id = idController.text.trim();
					final String access = accessController.text.trim();
					if(id.isNotEmpty && access.isNotEmpty) {
						setState(() {
							if( widget.mode == DeviceScreenType.HOME ) {
								homeDevices.add(Device( deviceId : id, deviceAccess :access));
							}
							else if( widget.mode == DeviceScreenType.KITCHEN ) {
								kitchenDevices.add(Device( deviceId : id, deviceAccess :access));
							}
							else if( widget.mode == DeviceScreenType.HALL ) {
								hallDevices.add(Device( deviceId : id, deviceAccess :access));
							}
							else if( widget.mode == DeviceScreenType.ROOM1 ) {
								room1Devices.add(Device( deviceId : id, deviceAccess :access));
							}
							else if( widget.mode == DeviceScreenType.ROOM2 ) {
								room2Devices.add(Device( deviceId : id, deviceAccess :access));
							}
							_showAddDevice = false;
							idController.clear();
							accessController.clear();
						});
					}
			}

			Future<void> saveDevices( String key, List<Device> devices ) async {
				final localStore = await SharedPreferences.getInstance();

				final deviceListJson = jsonEncode(
					devices.map( (d) => {
						'id' : d.deviceId,
						'access' : d.deviceAccess,
					}).toList(),
				);

				await localStore.setString( key, deviceListJson );
			}

			Future<List<Device>> loadDevices( String key ) async {
				final localStore = await SharedPreferences.getInstance();
				final jsonString = localStore.getString( key );

				if( jsonString == null ) {
					return [];
				}
				final List<dynamic> decodedJson = jsonDecode( jsonString );
				return decodedJson.map(
								(item) => Device(
									deviceId: item['id'],
									deviceAccess: item['access'],
								)
				).toList();
			}

			@override
			void initState() {
				super.initState();
				loadDevicesForMode();
			}

			void loadDevicesForMode() async {
				final loadedDevices = await loadDevices( widget.mode.name );
				setState(() {
				  switch( widget.mode ) {
						case DeviceScreenType.HOME:
							homeDevices = loadedDevices;
							break;
						case DeviceScreenType.KITCHEN:
							kitchenDevices = loadedDevices;
							break;
						case DeviceScreenType.HALL:
							hallDevices = loadedDevices;
							break;
						case DeviceScreenType.ROOM1:
							room1Devices = loadedDevices;
							break;
						case DeviceScreenType.ROOM2:
							room2Devices = loadedDevices;
							break;
					}
				});
			}

			List<Device> get devices {
				switch ( widget.mode ) {
					case DeviceScreenType.HOME:
						return homeDevices;
					case DeviceScreenType.HALL:
						return hallDevices;
					case DeviceScreenType.KITCHEN:
						return kitchenDevices;
					case DeviceScreenType.ROOM1:
						return room1Devices;
					case DeviceScreenType.ROOM2:
						return room2Devices;
				}
			}


		@override
		Widget build(BuildContext context) {
				return Scaffold(
					appBar: AppBar(
						title: Text( widget.mode.name ),
						backgroundColor: Colors.deepPurpleAccent,
					),
					body: Container(
						decoration: BoxDecoration(
							gradient: LinearGradient(
								colors: [Colors.greenAccent, Colors.blueAccent],
								begin: Alignment.topLeft,
								end: Alignment.bottomRight,
							),
						),
						padding: EdgeInsets.all(15.0),
						child: Column(
							mainAxisAlignment: MainAxisAlignment.start,
							children: [
								ElevatedButton(
									onPressed: () {
										setState(() {
										  _showAddDevice = true;
										});
									},
									child: Text('ADD'),
								),
								SizedBox(height: 16.0),
								if(_showAddDevice) ...[
									Form(
										key: _deviceAddKey,
										child: Column(
											children: [
												TextFormField(
													controller: idController,
													decoration: InputDecoration( labelText: 'Device ID'),
													validator: (value){
														if( value == null || value.isEmpty ) {
															return 'Please enter device Id';
														}
														return null;
													},
												),
												SizedBox(height: 16.0),
												TextFormField(
													controller:  accessController,
													decoration: InputDecoration(labelText: 'Access'),
													validator: (value){
														if( value == null || value.isEmpty) {
															return 'Please enter access token';
														}
														return null;
													},
												),
												SizedBox(height: 16.0),
												ElevatedButton(
													onPressed: () {
														if(_deviceAddKey.currentState!.validate() ) {
															_addDevice();
															saveDevices( widget.mode.name, devices);
														}
													}
												, child: Text('Save device')),
											],
										),
									)
								],
								SizedBox(height: 16.0),
								Expanded(
									child: ListView.builder(
										itemCount: devices.length,
										itemBuilder: (context, index){
											final device = devices[index];
											return Card(
												margin: EdgeInsets.symmetric(vertical: 8.0),
												child: ListTile(
													title: Text(device.deviceId),
													subtitle: Text('Access: ${device.deviceAccess}'),
													tileColor: Colors.pinkAccent,
												),
											);
										},
									),
								)
							],

						),
					)
				);
		}

}
		
