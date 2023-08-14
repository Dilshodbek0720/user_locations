import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_locations/data/model/universal_data.dart';
import 'package:user_locations/data/network/api_service.dart';

class AddressCallProvider with ChangeNotifier {
  AddressCallProvider({required this.apiService});

  final ApiService apiService;

  String scrolledAddressText = '';
  String kind = "house";
  String lang = "uz_UZ";

  getAddressByLatLong({required LatLng latLng}) async {
    UniversalData universalData = await apiService.getAddress(
      latLng: latLng,
      kind: kind,
      lang: lang,
    );

    if (universalData.error.isEmpty) {
      scrolledAddressText = universalData.data as String;
    } else {
      debugPrint("ERROR:${universalData.error}");
    }
    notifyListeners();
  }

  void updateKind(String newKind) {
    kind = newKind;
  }

  void updateLang(String newLang) {
    lang = newLang;
  }

  bool canSaveAddress() {
    if (scrolledAddressText.isEmpty) return false;
    if (scrolledAddressText == 'Aniqlanmagan Hudud') return false;

    return true;
  }
}