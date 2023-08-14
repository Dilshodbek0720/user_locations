import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_locations/data/model/adress_model.dart';
import 'package:user_locations/provider/location_user_provider.dart';
import 'package:user_locations/ui/map/widgets/address_king_selector.dart';
import 'package:user_locations/ui/map/widgets/address_lang_selector.dart';
import 'package:user_locations/ui/map/widgets/map_type_selector.dart';

import '../../../provider/address_call_provider.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key, required this.addressModel});

  final AddressModel addressModel;
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late CameraPosition initialCameraPosition;
  late CameraPosition currentCameraPosition;
  bool onCameraMoveStarted = false;
  MapType mapType = MapType.normal;

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      target: LatLng(double.parse(widget.addressModel.lat), double.parse(widget.addressModel.long)),
      zoom: 13,
    );

    currentCameraPosition = CameraPosition(
      target: LatLng(double.parse(widget.addressModel.lat), double.parse(widget.addressModel.long)),
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
        title: const Text("Update Screen"),
        actions: [
          MapTypeSelector(onTap: (v) {
            setState(() {
              mapType = v!;
            });
          },),
          const SizedBox(width: 15,)
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
            alignment: Alignment(-0.95,0.55),
            child: AddressKindSelector(),
          ),
          const Align(
            alignment: Alignment(-0.95,0.72),
            child: AddressLangSelector(),
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
                    child: IconButton(onPressed: () async{
                      AddressCallProvider adp =
                      Provider.of<AddressCallProvider>(context, listen: false);
                      await context.read<LocationUserProvider>().updateLocationUser(addressModel: AddressModel(id: widget.addressModel.id,address: adp.scrolledAddressText, lat: currentCameraPosition.target.latitude.toString(), long: currentCameraPosition.target.longitude.toString()),);
                      if(context.mounted) Navigator.pop(context);
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