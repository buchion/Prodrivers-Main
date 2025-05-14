import 'package:prodrivers/Authentication/prodriverscreatepassword.dart';
import 'package:prodrivers/Authentication/prodriversresetpassword.dart';
import 'package:prodrivers/Authentication/prodriverssignin.dart';
import 'package:flutter/material.dart';
import 'package:prodrivers/Authentication/prodriverssignup.dart';
import 'package:prodrivers/Authentication/prodriversverification.dart';
import 'package:prodrivers/Dashboard/maindashboard.dart';
import 'package:prodrivers/Dashboard/profile.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {

    // ONBOADRING ROUTES

    case ProdriversSignin.routeName:
      return MaterialPageRoute(
        builder: (_) => const ProdriversSignin(),
        settings: const RouteSettings(name: ProdriversSignin.routeName),
      );

    case ProdriversSignup.routeName:
      return MaterialPageRoute(
        builder: (_) => ProdriversSignup(),
        settings: RouteSettings(name: ProdriversSignup.routeName),
      );

    case ProfileView.routeName:
      return MaterialPageRoute(
        builder: (_) => ProfileView(),
        settings: RouteSettings(name: ProfileView.routeName),
      );

    case ProdriversCreatePassword.routeName:
      return MaterialPageRoute(
        builder: (_) {
          final Map args = settings.arguments as Map;
          return  ProdriversCreatePassword(
            email: args['email'],
          );
        },
        settings: RouteSettings(name: ProdriversCreatePassword.routeName),
      );

    case ProdriversResetPassword.routeName:
      return MaterialPageRoute(
        builder: (_) => const ProdriversResetPassword(),
        settings: const RouteSettings(name: ProdriversResetPassword.routeName),
      );

    case ProdriversVerification.routeName:
      return MaterialPageRoute(
        builder: (_) {
          final Map args = settings.arguments as Map;
          return  ProdriversVerification(
            email: args['email'],
            token: args['token'],
          );
        },
        settings: RouteSettings(name: ProdriversVerification.routeName),
      );


// DASHBOARD ROUTE

    case MainDashboard.routeName:
      return MaterialPageRoute(
        builder: (_) => MainDashboard(),
        settings: const RouteSettings(name: MainDashboard.routeName),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const ProdriversSignin(),
        settings: const RouteSettings(name: ProdriversSignin.routeName),
      );
  }
}
