import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_locations/utils/constants/constants.dart';

import '../../../provider/address_call_provider.dart';

class AddressLangSelector extends StatefulWidget {
  const AddressLangSelector({Key? key}) : super(key: key);



  @override
  State<AddressLangSelector> createState() => _AddressLangSelectorState();
}

class _AddressLangSelectorState extends State<AddressLangSelector> {
  String dropdownValue = langList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      value: dropdownValue,
      elevation: 8,
      style: const TextStyle(color: Colors.white),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });

        context.read<AddressCallProvider>().updateLang(dropdownValue);
      },
      items: langList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
              margin: const EdgeInsets.only(left: 3),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green,
              ),
              child: Text(language[value]!)),
        );
      }).toList(),
    );
  }
}