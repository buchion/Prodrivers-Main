// ignore_for_file: avoid_print

import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:prodrivers/Authentication/prodriverssignup.dart';
import 'package:prodrivers/Dashboard/maindashboard.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/authentication/prodriversresetpassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prodrivers/components/biometrics.dart';
import 'package:prodrivers/components/notification.dart';
import 'package:prodrivers/components/utils.dart';

class ProdriversSignin extends StatefulWidget {
  static const String routeName = '/prodriverssignin';

  const ProdriversSignin({super.key});

  // final String title;

  @override
  ProdriversSigninState createState() => ProdriversSigninState();
}

class ProdriversSigninState extends State<ProdriversSignin> with RouteAware {
  String? owner;
  bool checked = true;
  bool obscurePassword = true;
  final _storage = const FlutterSecureStorage();
  static final LocalAuthentication auth = LocalAuthentication();
  static final Biometric biometrics = Biometric();
  GlobalKey<FormState> _logonKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final box = GetStorage();
  

  login() {
    
    box.write("loginEmail", _emailCtrl.text);
    box.write("loginPassword", _passwordCtrl.text);
    showLoading();
    AuthAPI.POST_WITHOUT_TOKEN(urlendpoint: 'auth/login', postData: {
      "email": _emailCtrl.text,
      "password": _passwordCtrl.text,
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

                  // box.write('companydetails', response["result"]['user']['company']),

                  box.write('userid', response["result"]["user"]["id"]),
                  box.write(
                      'userType', response["result"]["user"]["user_type"]),
                  if (response["result"]["user"]["user_type"].toString() ==
                      "admin")
                    {
                      notifyInfo(
                          content: "Only Transporters and Cargo Owners can use this version"),
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
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: _logonKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 80,
        ),
        Container(
          margin: const EdgeInsets.all(20),
          alignment: AlignmentDirectional.center,
          child: SvgPicture.asset(
            'assets/icons/prodrivericon.svg',
            height: 90,
            width: 74,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: const Text("Welcome back, log into your account to continue",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Email",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              focusNode: _emailNode,
              controller: _emailCtrl,
              // enabled: !processing,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade50,
                // hintText: 'Enter your email',
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) => validateEmail(value!),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_passwordNode);
              },
            ),
            const SizedBox(
              height: 24,
            ),
            const Text("Password",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              focusNode: _passwordNode,
              controller: _passwordCtrl,
              // enabled: !processing,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              obscureText: obscurePassword,
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade50,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue[700],
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
                // hintText: 'Enter your email',
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // labelText: Strings.register.pass,
                // border: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              validator: (value) => validateRequired(
                value!,
                'Password',
              ),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(
              height: 0,
            ),
          ]),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(children: [
              Container(
                  height: 48,
                  margin: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Checkbox(
                            value: checked,
                            onChanged: (changedValue) {
                              setState(() {
                                checked = changedValue!;
                              });
                            },
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                  width: 1.0, color: Color(0xff0263c91)),
                            ),
                            checkColor: Colors.blue.shade900,
                            activeColor: Colors.white,
                          ),
                          const Text(
                            "Remember me",
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProdriversResetPassword()),
                          );
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            // fontSize: 20,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 428,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF0263C91,
                    ),
                    elevation: 1,
                  ),
                  onPressed: () {
                    if (_logonKey.currentState!.validate()) {
                      login();
                    }
                  },
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                margin: const EdgeInsets.all(25),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ProdriversSignup.routeName);
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ]),
              )
            ])),
      ]),
    )));
  }
}
