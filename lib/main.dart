import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:websocket/Screens/provider/auth_provider.dart';
import 'package:websocket/Screens/provider/cartProvider.dart';
import 'package:websocket/Screens/provider/orderProvider.dart';
import 'package:websocket/Screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:websocket/Screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
         ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        
        
     
        ),
      ],
      child:
    MyApp(),));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gomel',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Charter'
      ),
        
      
      darkTheme: ThemeData.dark(),
      home: SplashScreen()
    );
  }
}

