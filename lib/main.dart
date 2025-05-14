import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

import 'package:prodrivers/Dashboard/maindashboard.dart';
import 'package:prodrivers/InitialPage.dart';
import 'package:prodrivers/authentication/prodriverssignin.dart';

import 'package:flutter/material.dart';

import 'package:prodrivers/router.dart';

String storeToken = '';
// GetStorage box = GetStorage();

Future<void> main() async {
  GetStorage.init();
  
  final _storage = const FlutterSecureStorage();
  final box = GetStorage();

  // storeToken = await _storage.read(key: 'token').toString();
  // print("STORE TOKEN: ${storeToken}");
  box.write("userType", await _storage.read(key: 'userType'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // setState(() {});
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      home: InitialPage(),

      // storeToken.isEmpty ||
      //         storeToken == Empty ||
      //         storeToken == ""
      //     ? ProdriversSignin() : 
          // MainDashboard(),
          // ProdriversSignin(),

      onGenerateRoute: onGenerateRoute,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
























// import 'package:prodrivers/authentication/prodriverscreatepassword.dart';
// import 'package:prodrivers/authentication/prodriversresetpassword.dart';
// import 'package:prodrivers/authentication/prodriverssignin.dart';
// import 'package:flutter/material.dart';
// import 'package:prodrivers/router.dart';

// void main() {
//    runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         pageTransitionsTheme: const PageTransitionsTheme(builders: {
//           TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//         }),
//       ),
//       home: const ProdriversSignin(),
//       onGenerateRoute: onGenerateRoute,
//     );
//   }
// }

// /// feu

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const <Widget>[],
//         ),
//       ),
//     );
//   }
// }
