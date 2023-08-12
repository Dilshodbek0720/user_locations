import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_locations/data/model/adress_model.dart';

import '../data/local/local_database.dart';
import '../utils/ui_utils/loading_dialog.dart';
class LocationUserProvider with ChangeNotifier{

  LocationUserProvider(){
    getLocationUser();
    notifyListeners();
  }


  List<AddressModel> locationUser=[];

  getLocationUser()async{
    locationUser = await LocalDatabase.getAllAddress();

    notifyListeners();
  }

  deleteLocationUser({required int id})async{
    await LocalDatabase.deleteAddress(id);
    await getLocationUser();
    notifyListeners();
  }

  // deleteAllLocationUsers({required BuildContext context})async{
  //   showLoading(context: context);
  //   await LocalDatabase.deleteAllLocationUsers();
  //   await getLocationUser();
  //   if(context.mounted)hideLoading(dialogContext: context);
  //   notifyListeners();
  //
  // }

  insertLocationUser({required AddressModel addressModel})async{
    await LocalDatabase.insertAddress(addressModel);
    await getLocationUser();
    notifyListeners();
  }

}