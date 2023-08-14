import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_locations/data/local/local_database.dart';
import 'package:user_locations/data/model/adress_model.dart';
import 'package:user_locations/provider/location_user_provider.dart';

class UserLocationsScreen extends StatefulWidget {
  const UserLocationsScreen({super.key});

  @override
  State<UserLocationsScreen> createState() => _UserLocationsScreenState();
}

class _UserLocationsScreenState extends State<UserLocationsScreen> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LocationUserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("User Locations Screen"), centerTitle: true, backgroundColor: Colors.black,),
      body: ListView(
              children: List.generate(provider.locationUser.length, (index) =>
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(14)
                    ),
                    child: ListTile(
                      title: Text("Address:  ${provider.locationUser[index].address}", style: TextStyle(fontSize: 20),),
                      subtitle: Text("Latitude: ${provider.locationUser[index].lat.substring(0,6)}  Longitude: ${provider.locationUser[index].long.substring(0,6)}"),
                      trailing: IconButton(onPressed: () async{
                        provider.deleteLocationUser(id: context.read<LocationUserProvider>().locationUser[index].id!);
                      }, icon: Icon(Icons.delete, color: Colors.redAccent,size: 26,),),
                    ),
                  )
              ),
            )
      // FutureBuilder(
      //   future: LocalDatabase.getAllAddress(),
      //   builder: (BuildContext context, AsyncSnapshot<List<AddressModel>> snapshot) {
      //     if(snapshot.connectionState == ConnectionState.done){
      //       if(snapshot.hasError){
      //         return Center(
      //           child: Text('${snapshot.error} occurred', style: const TextStyle(fontSize: 18)),
      //         );
      //       }else if(snapshot.hasData){
      //         List<AddressModel> addresses = snapshot.data!;
      //         return ListView(
      //           children: List.generate(addresses.length, (index) =>
      //               Container(
      //                 margin: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
      //                 decoration: BoxDecoration(
      //                   color: Colors.black26,
      //                   borderRadius: BorderRadius.circular(14)
      //                 ),
      //                 child: ListTile(
      //                   title: Text("Address:  ${addresses[index].address}", style: TextStyle(fontSize: 20),),
      //                   subtitle: Text("Latitude: ${addresses[index].lat.substring(0,6)}  Longitude: ${addresses[index].long.substring(0,6)}"),
      //                   trailing: IconButton(onPressed: () async{
      //                     await LocationUserProvider().deleteAddress(id: addresses[index].id!);
      //                   }, icon: Icon(Icons.delete, color: Colors.redAccent,size: 26,),),
      //                 ),
      //               )
      //           ),
      //         );
      //       }else{
      //         return const Center(child: CircularProgressIndicator());
      //       }
      //     }
      //     else{
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
    );
  }
}
