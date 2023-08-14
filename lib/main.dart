import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_locations/data/network/api_service.dart';
import 'package:user_locations/provider/address_call_provider.dart';
import 'package:user_locations/provider/location_user_provider.dart';
import 'package:user_locations/ui/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => LocationUserProvider(),
      ),
      ChangeNotifierProvider(
          create: (context) => AddressCallProvider(apiService: ApiService())
      )
    ],
    child: MainApp(),));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
