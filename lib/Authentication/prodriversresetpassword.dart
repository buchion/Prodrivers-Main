import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/authentication/prodriverscreatepassword.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProdriversResetPassword extends StatefulWidget {
  static const String routeName = '/prodriversresetpassword';

  const ProdriversResetPassword({super.key});

  @override
  ProdriversResetPasswordState createState() => ProdriversResetPasswordState();
}

class ProdriversResetPasswordState extends State<ProdriversResetPassword>
    with RouteAware {
  final _emailNode = FocusNode();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailNode.dispose();
    _emailCtrl.dispose();

    super.dispose();
  }

  // /auth/forgot-password

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    getResetToken() {
      AuthAPI.POST_WITHOUT_TOKEN(
          urlendpoint: 'auth/forgot-password',
          postData: {
            "email": _emailCtrl.text,
          }).then((response) async => {
            print(response),
            if (response["success"] == true)
              {
                Navigator.pushNamed(context, ProdriversCreatePassword.routeName,
                    arguments: {
                      'email': _emailCtrl.text,
                    })
              }
            else
              {}
          });
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
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
          height: 24,
        ),
        const Text("Reset Your Password ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              // color: Colors.black87,
              fontWeight: FontWeight.w500,
              // fontFamily: 'Montserrat',
            )),
        const SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: const Text(
              "Enter your email and we'll send you a link to reset your password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black45,
              )),
        ),
        const SizedBox(
          height: 0,
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
              style: const TextStyle(fontSize: 25),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade50,
                // hintText: 'Enter your email',
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              // validator: validatePassword as String Function(String),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                // FocusScope.of(context).requestFocus(_passwordNode);
              },
            ),
            const SizedBox(
              height: 60,
            ),
          ]),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(children: [
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
                    getResetToken();
                  },
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ])),
      ]),
    ));
  }
}
