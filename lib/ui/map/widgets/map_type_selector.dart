import 'package:flutter/material.dart';
import 'package:user_locations/utils/constants/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypeSelector extends StatelessWidget {
  const MapTypeSelector({Key? key, required this.onTap}) : super(key: key);
  final ValueChanged onTap;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.layers_outlined, color: Colors.white,),
          onChanged: onTap,
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
    );
  }
}