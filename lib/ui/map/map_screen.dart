import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_locations/data/model/adress_model.dart';
import 'package:user_locations/provider/location_user_provider.dart';
import 'package:user_locations/ui/map/widgets/address_king_selector.dart';
import 'package:user_locations/utils/constants/constants.dart';

import '../../provider/address_call_provider.dart';
import '../user_locations/user_locations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.latLong});

  final LatLng latLong;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition initialCameraPosition;
  late CameraPosition currentCameraPosition;
  bool onCameraMoveStarted = false;
  MapType mapType = MapType.normal;

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      target: widget.latLong,
      zoom: 13,
    );

    currentCameraPosition = CameraPosition(
      target: widget.latLong,
      zoom: 13,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.black,
        title: const Text("Google Map"),
        actions: [
          DropdownButtonHideUnderline(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(16),
                icon: const Icon(Icons.layers_outlined, color: Colors.white,),
                onChanged: (v) {
                  setState(() {
                    mapType = v!;
                  });
                },
                items: maps.map((MapType mapType) {
                  return DropdownMenuItem(
                      value: mapType, child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/${mapsTypeName[mapType.name]}.${mapsTypeName[mapType.name]=="satellite"?"png":"jpg"}"),
                            const SizedBox(width: 12,),
                            Text(mapsTypeName[mapType.name]),
                          ],
                        ),
                      ));
                }).toList(),
              )
          ),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return const UserLocationsScreen();
            }));
          }, icon: const Icon(Icons.maps_ugc_sharp)),
          const SizedBox(width: 5,)
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            onCameraMove: (CameraPosition cameraPosition) {
              currentCameraPosition = cameraPosition;
            },
            onCameraIdle: () {
              debugPrint(
                  "CURRENT CAMERA POSITION: ${currentCameraPosition.target.latitude}");
              context
                  .read<AddressCallProvider>()
                  .getAddressByLatLong(latLng: currentCameraPosition.target);
              setState(() {
                onCameraMoveStarted = false;
              });
              debugPrint("MOVE FINISHED");
            },
            liteModeEnabled: false,
            myLocationEnabled: false,
            padding: const EdgeInsets.all(16),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: mapType,
            onCameraMoveStarted: () {
              setState(() {
                onCameraMoveStarted = true;
              });
              debugPrint("MOVE STARTED");
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: initialCameraPosition,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Text(
                context.watch<AddressCallProvider>().scrolledAddressText,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: AddressKindSelector(),
          ),
          Positioned(
            bottom: 15,
              left: MediaQuery.of(context).size.width/2-32,
              child: Visibility(
                visible: context.watch<AddressCallProvider>().canSaveAddress(),
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                    shape: BoxShape.circle
                  ),
                    child: IconButton(onPressed: (){
                      AddressCallProvider adp =
                      Provider.of<AddressCallProvider>(context, listen: false);
                      context.read<LocationUserProvider>().insertLocationUser(addressModel: AddressModel(address: adp.scrolledAddressText, lat: currentCameraPosition.target.latitude.toString(), long: currentCameraPosition.target.longitude.toString()),);
                    }, icon: const Icon(Icons.add, color: Colors.white,size: 30,),)),
              )),
          Align(
            child: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: onCameraMoveStarted ? 52 : 45,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _followMe(cameraPosition: initialCameraPosition);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }

  Future<void> _followMe({required CameraPosition cameraPosition}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }
}