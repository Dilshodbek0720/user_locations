import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_locations/provider/location_user_provider.dart';
import 'package:user_locations/ui/user_locations/widgets/update_screen.dart';

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
      appBar: AppBar(title: const Text("User Locations Screen"), centerTitle: true, backgroundColor: Colors.black,
      ),
      body: ListView(
              children: List.generate(provider.locationUser.length, (index) =>
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(14)
                    ),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return UpdateScreen(addressModel: provider.locationUser[index]);
                        }));
                      },
                      title: Text("Address:  ${provider.locationUser[index].address}", style: TextStyle(fontSize: 20),),
                      subtitle: Text("Latitude: ${provider.locationUser[index].lat.substring(0,6)}  Longitude: ${provider.locationUser[index].long.substring(0,6)}"),
                      trailing: IconButton(onPressed: () async{
                        provider.deleteLocationUser(id: context.read<LocationUserProvider>().locationUser[index].id!);
                      }, icon: const Icon(Icons.delete, color: Colors.redAccent,size: 26,),),
                    ),
                  )
              ),
            )
    );
  }
}
