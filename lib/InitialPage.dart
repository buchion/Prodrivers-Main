import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prodrivers/Authentication/prodriverssignin.dart';
import 'package:prodrivers/Authentication/prodriverssignup.dart';
import 'package:prodrivers/Dashboard/maindashboard.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/notification.dart';

class InitialPage extends StatefulWidget {
  // this will be used in routing (like a url) to this view, it has to be unique
  static const String routeName = '/';

  const InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage>
    with SingleTickerProviderStateMixin<InitialPage>, RouteAware {
  AnimationController? rotation;
  AnimationController? fade;
  double opacity = 0;
  final _storage = const FlutterSecureStorage();
  GetStorage box = GetStorage();

  login() {
    showLoading();
    AuthAPI.POST_WITHOUT_TOKEN(urlendpoint: 'auth/login', postData: {
      "email": box.read('loginEmail'),
      "password": box.read('loginPassword'),
    }).then((response) async => {
          hideLoading(),
          if (response != null)
            {
              if (response["success"] == true)
                {
                  await _storage.write(
                      key: "token", value: response["result"]["token"]),
                  await _storage.write(
                      key: "userType",
                      value: response["result"]["user"]["user_type"]),
                  await _storage.write(
                      key: "userid",
                      value: response["result"]["user"]["id"].toString()),
                  box.write('userdetails', response["result"]["user"]),
                  box.write('userid', response["result"]["user"]["id"]),
                  box.write(
                      'userType', response["result"]["user"]["user_type"]),
                  if (response["result"]["user"]["user_type"].toString() ==
                      "admin")
                    {
                      notifyInfo(
                          content:
                              "Only Transporters and Cargo Owners can use this version"),
                    }
                  else
                    {Navigator.pushNamed(context, MainDashboard.routeName)}
                }
            }
          else
            {
              notifyInfo(content: "Login Failed"),
            }
        });
  }

  @override
  void initState() {
    super.initState();

    // fade in animation for all widgets
    fade = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..drive(IntTween(begin: 0, end: 1))
      ..forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          opacity = 1;
        });
      }
    });

    // loading delay of 5 seconds

    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (mounted) {
        print("(userdetails) IS ${box.read("userdetails")}");
        print("(mystat) IS ${box.read("mystat")}");
        if (box.read('userdetails') != null && box.read('mystat') != null) {
          // Navigator.pushNamed(context, MainDashboard.routeName);
          login();
        } else {
          Navigator.pushNamed(context, ProdriversSignin.routeName);
        }
      }
    });
  }

  @override
  void dispose() {
    rotation?.dispose();
    fade?.dispose();
    super.dispose();
  }

  @override
  void didPush() {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: opacity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            "assets/icons/prodrivericon.svg",
                            width: width * .4,
                          )
                          // Image.asset(
                          //   "assets/icons/general/icon.png",
                          //   width: width * .4,
                          // ),
                          ),
                    ),
                  ),

                  // SvgPicture.asset("assets/img/watermark.svg"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
