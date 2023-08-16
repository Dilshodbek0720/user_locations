import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:user_locations/data/model/adress_model.dart';
import 'package:user_locations/provider/location_provider.dart';
import 'package:user_locations/provider/location_user_provider.dart';
import 'package:user_locations/ui/map/widgets/address_king_selector.dart';
import 'package:user_locations/ui/map/widgets/address_lang_selector.dart';
import 'package:user_locations/ui/map/widgets/map_type_selector.dart';
import '../../provider/address_call_provider.dart';
import '../user_locations/user_locations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.latLong});

  final LatLng latLong;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

Set<Marker> markers = {};

class _MapScreenState extends State<MapScreen> {
  late CameraPosition initialCameraPosition;
  late CameraPosition currentCameraPosition;
  static CameraPosition currentPosition = CameraPosition(target: LatLng(41.26431679638257,69.23665791749954), zoom: 13);
  static CameraPosition initialPosition = CameraPosition(target: LatLng(41.27983980636389,69.23507642000915), zoom: 13);
  bool onCameraMoveStarted = false;
  MapType mapType = MapType.normal;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();


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
    context.read<LocationProvider>().getLocation();
    // getPolyPoints();
    getCurrentLocation();
    super.initState();
  }

  List<LatLng> polylineCoordinates = [];
  LocationData? locationData;

  void getCurrentLocation() async{
    Location location = Location();


    // GoogleMapController googleMapController = await _controller.future;

    location.getLocation().then((location) {
      locationData = location;
    });
    location.onLocationChanged.listen((newLocation) {
      locationData = newLocation;

      // googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //   zoom: 13,
      //     target: LatLng(newLocation.latitude!, newLocation.longitude!))),
      // );
      setState(() { });
    });
  }

  // void getPolyPoints() async{
  //   PolylinePoints polylinePoints = PolylinePoints();
  //
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       "AIzaSyDfTnv0dUVfo3Mg_NJOAUoZDaUXUqYK76c",
  //       PointLatLng(initialPosition.target.latitude, initialPosition.target.longitude),
  //       PointLatLng(currentPosition.target.latitude, currentPosition.target.longitude)
  //   );
  //
  //   if(result.points.isNotEmpty){
  //     result.points.forEach((PointLatLng point) {
  //       return polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }
  //   setState(() { });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.black,
        title: const Text("Google Map"),
        actions: [
          MapTypeSelector(onTap: (v) {
            setState(() {
              mapType = v!;
            });
          },),
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
            markers: markers,
            // {
            //   Marker(
            //       markerId: MarkerId("currentLocation"),
            //       position: LatLng(locationData!.latitude!,locationData!.longitude!),
            //   ),
            //   Marker(
            //       markerId: MarkerId("source"),
            //       position: initialPosition.target
            //   ),
            //   Marker(
            //     markerId: MarkerId("source"),
            //     position: currentPosition.target
            //   )
            // },
            onCameraIdle: () {
              debugPrint(
                  "CURRENT CAMERA POSITION: ${currentCameraPosition.target.latitude} ${currentCameraPosition.target.longitude}");
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
