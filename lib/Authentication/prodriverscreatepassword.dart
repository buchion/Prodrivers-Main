import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/authentication/prodriverssignin.dart';

// import 'package:flutter_verification_code/flutter_verification_code.dart';
// import 'package:flutter/services.dart';

class ProdriversCreatePassword extends StatefulWidget {
  static const String routeName = '/prodriverscreatepassword';

  final String email;

  const ProdriversCreatePassword({
    Key? key,
    required this.email,
  }) : super(key: key);

  // final String title;

  @override
  ProdriversCreatePasswordState createState() =>
      ProdriversCreatePasswordState();
}

String verificationCode = "";

class ProdriversCreatePasswordState extends State<ProdriversCreatePassword>
    with RouteAware {
  bool obscurePassword = true;
  bool confirmobscurePassword = true;

  final _passwordNode = FocusNode();
  final _passwordCtrl = TextEditingController();

  final _confirmpasswordNode = FocusNode();
  final _confirmpasswordCtrl = TextEditingController();

  @override
  void dispose() {
    // _codeNode.dispose();
    // _codeCtrl.dispose();

    _passwordNode.dispose();
    _passwordCtrl.dispose();

    _confirmpasswordNode.dispose();
    _confirmpasswordCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    resetPassword() {

      AuthAPI.POST_WITHOUT_TOKEN(
        urlendpoint: 'auth/reset-password', 
      postData: {
        "email": widget.email,
        'password': _passwordCtrl.text,
        'confirm_password': _confirmpasswordCtrl.text,
        'token': verificationCode
      }).then((response) async => {
            print(response),
            if (response["success"] == true)
              {Navigator.pushNamed(context, ProdriversSignin.routeName)}
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
        const Text("Create New Password ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              // color: Colors.black87,
              // fontWeight: FontWeight.w500,
              // fontFamily: 'Montserrat',
            )),
        const SizedBox(
          height: 2,
        ),
        Container(
          height: 45,
          margin: const EdgeInsets.all(25),
          child: const Text("Enter New Password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
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
            Text("One Time Code",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            VerificationCode(
                textStyle:
                    TextStyle(fontSize: 20.0, color: Colors.blue.shade900),
                itemSize: 52,
                fullBorder: true,
                digitsOnly: true,
                keyboardType: TextInputType.number,
                underlineColor: Colors.blue,
                length: 6,
                cursorColor: Color(0xFFF9FAFA),
                onCompleted: (String value) {
                  setState(() {
                    verificationCode = value;
                  });
                  FocusScope.of(context).requestFocus(_passwordNode);
                },
                onEditing: (bool value) {
                  // print(value);
                  // setState(() {});
                }),
            SizedBox(
              height: 16,
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
              style: const TextStyle(fontSize: 25),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade50,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.blue[700],
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // labelText: Strings.register.pass,
                // border: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              // validator: validatePassword as String Function(String),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_confirmpasswordNode);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Confirm Password",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              focusNode: _confirmpasswordNode,
              controller: _confirmpasswordCtrl,
              // enabled: !processing,
              style: const TextStyle(fontSize: 25),
              cursorColor: const Color(0xFF3D3F92),
              obscureText: confirmobscurePassword,
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade50,
                // hintText: 'Enter your email',
                suffixIcon: IconButton(
                  icon: Icon(
                    confirmobscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue[700],
                  ),
                  onPressed: () {
                    setState(() {
                      confirmobscurePassword = !confirmobscurePassword;
                    });
                  },
                ),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // labelText: Strings.register.pass,
                // border: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              // validator: validatePassword as String Function(String),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_passwordNode);
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
                    elevation: 3,
                  ),
                  onPressed: () {
                    resetPassword();
                  },
                  child: const Text(
                    "Create Password",
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
