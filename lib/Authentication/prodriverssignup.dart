// ignore_for_file: unused_local_variable

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/authentication/prodriverssignin.dart';
import 'package:prodrivers/authentication/prodriversverification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:prodrivers/components/notification.dart';
import 'package:prodrivers/components/utils.dart';

class ProdriversSignup extends StatefulWidget {
  static const String routeName = '/prodriverssignup';

  const ProdriversSignup({super.key});

  // final String title;

  @override
  ProdriversSignupState createState() => ProdriversSignupState();
}

class ProdriversSignupState extends State<ProdriversSignup> with RouteAware {
  bool checked = false;
  bool obscurePassword = true;
  bool confirmobscurePassword = true;
  String userType = "";

  final _storage = const FlutterSecureStorage();

  final _emailNode = FocusNode();
  final _emailCtrl = TextEditingController();
  final _passwordNode = FocusNode();
  final _passwordCtrl = TextEditingController();
  final _firstnameNode = FocusNode();
  final _firstnameCtrl = TextEditingController();
  final _lastnameNode = FocusNode();
  final _lastnameCtrl = TextEditingController();
  final _phonenumberNode = FocusNode();
  final _phonenumberCtrl = TextEditingController();
  final _confirmpasswordNode = FocusNode();
  final _confirmpasswordCtrl = TextEditingController();
  final _companyNode = FocusNode();
  final _companyCtrl = TextEditingController();

  @override
  void dispose() {
    _emailNode.dispose();
    _emailCtrl.dispose();

    _passwordNode.dispose();
    _passwordCtrl.dispose();

    _firstnameNode.dispose();
    _firstnameCtrl.dispose();

    _lastnameNode.dispose();
    _lastnameCtrl.dispose();

    _phonenumberNode.dispose();
    _phonenumberCtrl.dispose();

    _confirmpasswordNode.dispose();
    _confirmpasswordCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    register() {
      showLoading();
      AuthAPI.POST_WITHOUT_TOKEN(urlendpoint: 'auth/register', postData: {
        "email": _emailCtrl.text,
        'first_name': _firstnameCtrl.text,
        'last_name': _lastnameCtrl.text,
        'phone_number': _phonenumberCtrl.text,
        'user_type': userType,
        "password": _passwordCtrl.text,
        'confirm_password': _confirmpasswordCtrl.text,
        'company_name': _companyCtrl.text
      }).then((response) async => {
        hideLoading(),
            print(response),
            if (response["success"] == true)
              {
                print(response["result"]["token"]),
                await _storage.write(
                    key: "token",
                    value: response["result"]["token"].toString()),
                Navigator.pushNamed(context, ProdriversVerification.routeName,
                    arguments: {
                      'email': _emailCtrl.text,
                      'token': response["result"]["token"].toString()
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
            height: 80,
            width: 64,
          ),
        ),
        const Text("Create an Account",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(
          height: 20,
        ),
        const Text("Fill in the information below to sign up",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              color: Colors.black45,
            )),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("First Name",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              focusNode: _firstnameNode,
              controller: _firstnameCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade600,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // labelText: Strings.register.pass,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              keyboardType: TextInputType.name,
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
              height: 24,
            ),
            const Text("Last Name",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              focusNode: _lastnameNode,
              controller: _lastnameCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade600,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // labelText: Strings.register.pass,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              keyboardType: TextInputType.name,
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
              height: 24,
            ),
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) => validateEmail(value!),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                // FocusScope.of(context).requestFocus(_passwordNode);
              },
            ),
            const SizedBox(
              height: 24,
            ),
            const Text("Phone Number",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            IntlPhoneField(
              focusNode: _phonenumberNode,
              controller: _phonenumberCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade50,
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
              initialCountryCode: 'NG',
              onChanged: (phone) {
                // print(phone.completeNumber);
              },
              dropdownIconPosition: IconPosition.trailing,
              // showCountryFlag: false,
              flagsButtonPadding: const EdgeInsets.only(left: 15),
              // dropdownDecoration: BoxDecoration(),
              // countries: const ['NG', 'GH', 'ZA', 'KE'],
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // validator: numberValidator,
              // onEditingComplete: () {
              // FocusScope.of(context).requestFocus(_passwordNode);
              // },
            ),
            const SizedBox(
              height: 20,
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
              cursorColor: Colors.blue[700],
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
                FocusScope.of(context).requestFocus(_confirmpasswordNode);
              },
            ),
            const SizedBox(
              height: 20,
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
              style: const TextStyle(fontSize: 20),
              cursorColor: Colors.blue[700],

              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade50,
                // hintText: 'Enter your email',
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    confirmobscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.blue[700],
                  ),
                  onPressed: () {
                    setState(() {
                      confirmobscurePassword = !confirmobscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              obscureText: confirmobscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              // validator: validatePassword as String Function(String),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_companyNode);
              },
            ),
            const SizedBox(
              height: 24,
            ),
            // if (userType == 'truck-owner') ...[
            const Text("Company Name",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              focusNode: _companyNode,
              controller: _companyCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.blue.shade600,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // labelText: Strings.register.pass,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              // validator: validatePassword as String Function(String),
              onChanged: (String value) {
                // user.password = value;
              },
              onEditingComplete: () {
                // FocusScope.of(context).requestFocus(_passwordNode);
              },
            ),
            // ],
            RadioListTile(
              activeColor: Colors.blue.shade900,
              title: const Text("Truck Owner",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
              value: "transporter",
              groupValue: userType,
              contentPadding: const EdgeInsets.only(left: 4, bottom: 0),
              onChanged: (value) {
                setState(() {
                  userType = value.toString();
                });
              },
            ),
            RadioListTile(
              activeColor: Colors.blue.shade900,
              title: const Text("Cargo Owner",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
              value: "cargo-owner",
              groupValue: userType,
              contentPadding: const EdgeInsets.only(left: 4, top: 0),
              onChanged: (value) {
                setState(() {
                  userType = value.toString();
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: checked,
                  onChanged: (changedValue) {
                    setState(() {
                      checked = changedValue!;
                    });
                  },
                  side: MaterialStateBorderSide.resolveWith(
                    (states) =>
                        BorderSide(width: 1.0, color: Colors.blue.shade900),
                  ),
                  checkColor: Colors.blue.shade900,
                  activeColor: Colors.white,
                ),
                SizedBox(
                  width: width * .7,
                  child: Text(
                      "Accept to agree to the Terms of Use and Privacy Policy",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            )
          ]),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(children: [
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: width * .8,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    elevation: 1,
                  ),
                  onPressed: () {
                    register();
                  },
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                margin: const EdgeInsets.all(25),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Already have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProdriversSignin()));
                    },
                    child: Container(
                      height: height * 0.025,
                      width: width * 0.15,
                      child: Text(
                        "Sign In",
                        // "SIGN IN",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ]),
              )
            ])),
      ]),
    ));
  }
}
