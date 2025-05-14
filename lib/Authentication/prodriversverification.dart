import 'package:prodrivers/Authentication/prodriverssignin.dart';
import 'package:prodrivers/Dashboard/maindashboard.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class ProdriversVerification extends StatefulWidget {
  static const String routeName = '/prodriversverification';

  final String email;
  final String token;

  const ProdriversVerification({Key? key, required this.email, required this.token})
      : super(key: key);

  @override
  ProdriversVerificationState createState() => ProdriversVerificationState();
}

String verificationCode = "";

class ProdriversVerificationState extends State<ProdriversVerification>
    with RouteAware {

  verify() {
    print("TRIED TO VERIFY");
    AuthAPI.TOKENIZED_GET(urlendpoint: 'auth/email/verify/$verificationCode', token: widget.token)
        .then((response) async => {
              print(response),
              if (response["success"] == true)
                {
                  Navigator.pushNamed(context, ProdriversSignin.routeName)


                } else {}
            });
  }

  resendToken() {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: 'auth/email/resend/token')
        .then((response) async => {
              print(response),
              if (response["success"] == true)
                {
                  Navigator.pushNamed(context, ProdriversVerification.routeName,
                      arguments: {
                        'email': "",
                      })
                }
              else
                {}
            });
  }

  String verificationCode = "";

  @override
  Widget build(BuildContext context) {
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
        const Text("Verification",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            )),
        const SizedBox(
          height: 8,
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: Text(
              "We have sent a verification code to ${widget.email.toString()} input the code to verify.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black45,
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  print(value);
                  setState(() {
                    verificationCode = value;
                  });
                  verify();
                },
                onEditing: (bool value) {
                  // print(value);
                  // setState(() {});
                }),
            const SizedBox(
              height: 32,
            ),
          ]),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(children: [
              SizedBox(
                width: 400,
                height: 43,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF0263C91,
                    ),
                    elevation: 1,
                  ),
                  onPressed: () {
                    verify();
                  },
                  child: const Text(
                    "Verify Code",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 160,
                // margin: const EdgeInsets.all(25),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Didn't receive code?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      )),
                  TextButton(
                    onPressed: () {
                      resendToken();
                    },
                    child: Text(
                      "Resend Code",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
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
