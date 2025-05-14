import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:prodrivers/Authentication/prodriverssignin.dart';
import 'package:prodrivers/Authentication/prodriverssignup.dart';
import 'package:prodrivers/Dashboard/profile.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:auto_size_text/auto_size_text.dart';

// import '../models/values/colors.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  final _storage = const FlutterSecureStorage();

  final dataMap = <String, double>{
    "Unapproved Requests 25": 25,
    "Approved Requests 10": 10,
    "Cancelled Requests 8": 8,
  };

  final colorList = <Color>[
    Color(0xFFE79640),
    Colors.green,
    Colors.red,
  ];
  String dropdownvalue = 'Ongoing Trip';

  var items = [
    'Ongoing Trip',
    'Complete Trip',
    'Cancelled Trip',
  ];

  String totalNumberOfTrips = "";
  String totalNumberOfOngoingTrips = "";
  String totalNumberOfFlaggedTrips = "";
  String totalAmountOfIncome = "";

  String totalNumberOfCompletedTrips = "";
  String totalNumberOfCancelledTrips = "";
  String totalIncomeForTheMonth = "";
  String totalNumberOfDrivers = "";

  String totalAmountOfPendingIncome = "";
  String totalNumberOfTrucks = "";

  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    print("MAINDASBOARD USERTYPE: ${box.read("userType")}");
    CALL_ALL_ENDPOINTS();
  }

  CALL_ALL_ENDPOINTS() async {
    box.write("userType", await _storage.read(key: 'userType'));
    setState(() {});
    GetStatistics();
    GetAllTrips();
    GetAllDrivers();
    GetTonnages();
    GetTruckTypes();
    GetAllTrucks();
    GetOrders();
    callAllBanks();
  }

  GetAllTrips() {
    // if (box.read("userType") == "cargo-owner") {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: "trips").then((response) => {
          if (box.read("userType") == "cargo-owner")
            {
              // print("CARGO__OWNER RES::"),
              // print(response),
              // print(""),
              // print(
              //     response["result"]["meta"]["totalNumberOfTrips"].toString()),
              box.write("totalNumberOfTrips",
                  response["result"]["meta"]["totalNumberOfTrips"].toString()),
              box.write(
                  "totalNumberOfOngoingTrips",
                  response["result"]["meta"]["totalNumberOfOngoingTrips"]
                      .toString()),
              box.write(
                  "totalNumberOfOngoingTrips",
                  response["result"]["meta"]["totalNumberOfOngoingTrips"]
                      .toString()),
              box.write(
                  "totalNumberOfAccidentsTrips",
                  response["result"]["meta"]["totalNumberOfAccidentsTrips"]
                      .toString()),
              box.write(
                  "totalNumberOfDivertedTrips",
                  response["result"]["meta"]["totalNumberOfDivertedTrips"]
                      .toString()),
              box.write(
                  "totalNumberOfCompletedTrips",
                  response["result"]["meta"]["totalNumberOfCompletedTrips"]
                      .toString()),
              box.write(
                  "totalNumberOfCancelledTrips",
                  response["result"]["meta"]["totalNumberOfCancelledTrips"]
                      .toString()),

              box.write("trips", response["result"]["trips"]["data"]),
            }
          else if (box.read("userType") == "transporter")
            {
              print("TRANSPORTER::"),
              print(response),
              box.write("trips", response["result"]["trips"]["data"]),
              box.write("tripsTransporter", response["result"]["meta"]),
              print(response["result"]["meta"]),
            }
        });
  }

  GetTonnages() {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: "tonnages").then((res) => {
          box.write('tonnages', res["result"]["tonnages"]),
        });
  }

  GetTruckTypes() {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: "truckTypes").then((res) => {
          box.write('truck_types', res["result"]["truck_types"]),
        });
  }

  GetOrders() {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: "truckRequests").then((res) => {
          print("GET ORDERS:: RES::"),
          print(res["result"]["requests"]["data"]),
          box.write('truckRequest', res["result"]["requests"]["data"]),
        });
  }

  GetStatistics() {
    if (box.read("userType") == "transporter") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: 'transporter/stats')
          .then((response) async => {
                if (response["success"] == true)
                  {
                    print('I WROTE IN MYSTAT'),
                    box.write("mystat", response["result"]),
                    setState(() {}),
                  }
              });
    } else if (box.read("userType") == "cargo-owner") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: 'cargo-owner/stats')
          .then((response) async => {
                // print(response),
                if (response["success"] == true)
                  {
                    // print(response),
                    print('I WROTE IN MYSTAT'),
                    box.write("mystat", response["result"]),
                    setState(() {
                      totalNumberOfTrips =
                          response["result"]["totalNumberOfTrips"].toString();
                      totalNumberOfOngoingTrips = response["result"]
                              ["totalNumberOfOngoingTrips"]
                          .toString();
                      totalNumberOfFlaggedTrips = response["result"]
                              ["totalNumberOfFlaggedTrips"]
                          .toString();
                      totalNumberOfCompletedTrips = response["result"]
                              ["totalNumberOfCompletedTrips"]
                          .toString();
                      totalNumberOfCancelledTrips = response["result"]
                              ["totalNumberOfCancelledTrips"]
                          .toString();
                    }),
                    box.write("totalNumberOfTrips",
                        response["result"]["totalNumberOfTrips"].toString()),

                    box.write("totalNumberOfCancelledTrips",
                        response["result"]["totalNumberOfTrips"].toString())
                  }
              });
    }
  }

  GetAllTrucks() {
    if (box.read("userType") == "transporter") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: "trucks")
          // urlendpoint: "trucks")
          .then((res) => {
                // print(" ALL TRUCKS INIT${res["result"]["trucks"]}"),
                // print(" ALL TRUCKS LENGTH${res["result"]["trucks"].length}"),
                box.write("trucks", res["result"]["trucks"]["data"]),
              });
    }

    if (box.read("userType") == "admin") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: "transporters/1/truck")
          .then((res) => {
                // print(res),
                // print(res["result"]["drivers"]),
                box.write("drivers", res["result"]["truck"]),
              });
    }
  }

  GetAllDrivers() {
    if (box.read("userType") == "transporter") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: "drivers").then((res) => {
            box.write("drivers", res["result"]["drivers"]["data"]),
          });
    }

    if (box.read("userType") == "admin") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: "transporters/1/driver")
          .then((res) => {
                // print(res),
                // print(res["result"]["drivers"]),
                box.write("drivers", res["result"]["drivers"]),
              });
    }
  }

  callAllBanks() {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: 'banks').then((value) => {
          print(value),
          if (value['success'] == true)
            {box.write('allBanks', value['result']['banks'])}
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: navigationDrawer(context),
        appBar: AppBar(
          toolbarHeight: 55,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF263C91),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: SvgPicture.asset('assets/icons/drawer.svg'),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              SvgPicture.asset(
                'assets/icons/prodriversmallicon.svg',
                width: 30,
                // height: 45,
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                tooltip: 'Notifications',
                onPressed: () {
                  // handle the press
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            if (box.read("userType").toString() == "transporter") ...[
              Transporter(context),
            ],
            if (box.read("userType").toString() == "cargo-owner") ...[
              Cargoowner(context),
            ],
            if (box.read("userType").toString() == "admin") ...[
              Admin(context),
            ],
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
            ),
          ]),
        ));
  }

  Widget Admin(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.185 * 3.3,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        children: [
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.wallet_rounded,
                              color: Colors.green[800],
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Income",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                //                     AutoSizeText(
                                //   box.read('mystat')["totalAmountOfIncome"]
                                //                             .toString(),
                                //   style: TextStyle(fontSize: 30),
                                //   maxLines: 2,
                                // ),
                                SizedBox(
                                  width: width * .5,
                                  child: AutoSizeText(
                                      box
                                          .read('mystat')["totalAmountOfIncome"]
                                          .toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600)),
                                ),

                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),

// Trips --:
                      Container(
                        // change your height based on preference
                        height: 480,
                        width: double.infinity,
                        child: ListView(
                            controller: ScrollController(),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                height: height * 3,
                                width: width * 0.87,
                                padding: EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Active Trip",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            width: 90,
                                            height: 20,
                                            alignment:
                                                AlignmentDirectional.center,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              color: Color(0xFFFFF9C5),
                                            ),
                                            child: Text(
                                              "On Trip",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFB2702A),
                                                // backgroundColor: Color(0xFFFFF9C5),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          "Order ID",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFCCCCCC),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Name of the Product",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFCCCCCC),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          "#167497464",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Construction Materials",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/lineicon.svg'),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topStart,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        "Pickup Address",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFFCCCCCC),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "35, Papa, Ogun state",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Container(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topStart,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        "Destination",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFFCCCCCC),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "35, Soka, Oyo state",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                "06/05/2022",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "09/05/2022",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/profile.svg',
                                          height: 50,
                                          width: 50,
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Kandre Kan",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Kandre10@gmail.com",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFCCCCCC),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            final call =
                                                Uri.parse('tel:08000000000');
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xFFEEEEEE)),
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.all(0))),
                                          child: SvgPicture.asset(
                                              'assets/icons/call.svg'),
                                        ),
                                        SizedBox(
                                          width: 32,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final email = Uri(
                                              scheme: 'mailto',
                                              path: 'kandre10@gmail.com',
                                              query: 'subject=Hello&body=Test',
                                            );
                                            if (await canLaunchUrl(email)) {
                                              launchUrl(email);
                                            } else {
                                              throw 'Could not launch $email';
                                            }
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xFFEEEEEE)),
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.all(0))),
                                          child: SvgPicture.asset(
                                              'assets/icons/message.svg'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                height: height * 3,
                                width: width * 0.87,
                                padding: EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Active Trip",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            width: 90,
                                            height: 20,
                                            alignment:
                                                AlignmentDirectional.center,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              color: Color(0xFFFFF9C5),
                                            ),
                                            child: Text(
                                              "On Trip",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFB2702A),
                                                // backgroundColor: Color(0xFFFFF9C5),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          "Order ID",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFCCCCCC),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Name of the Product",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFCCCCCC),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          "#167497464",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Construction Materials",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/lineicon.svg'),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topStart,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        "Pickup Address",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFFCCCCCC),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "35, Papa, Ogun state",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Container(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topStart,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        "Destination",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFFCCCCCC),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "35, Soka, Oyo state",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                "06/05/2022",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "09/05/2022",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/profile.svg',
                                          height: 50,
                                          width: 50,
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Kandre Kan",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Kandre10@gmail.com",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFCCCCCC),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            final call =
                                                Uri.parse('tel:08000000000');
                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xFFEEEEEE)),
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.all(0))),
                                          child: SvgPicture.asset(
                                              'assets/icons/call.svg'),
                                        ),
                                        SizedBox(
                                          width: 32,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final email = Uri(
                                              scheme: 'mailto',
                                              path: 'kandre10@gmail.com',
                                              query: 'subject=Hello&body=Test',
                                            );
                                            if (await canLaunchUrl(email)) {
                                              launchUrl(email);
                                            } else {
                                              throw 'Could not launch $email';
                                            }
                                          },
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xFFEEEEEE)),
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.all(0))),
                                          child: SvgPicture.asset(
                                              'assets/icons/message.svg'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ]),
                      ),

                      SizedBox(
                        height: 50,
                      ),

                      Container(
                        height: height * 0.55,
                        width: width * 0.87,
                        padding: EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Today's History for Request",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            PieChart(
                              dataMap: dataMap,
                              animationDuration: Duration(milliseconds: 1000),
                              chartLegendSpacing: 24,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.1,
                              colorList: colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 24,
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.bottom,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontSize: 18,
                                  // fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 141, 140, 140),
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: false,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 0,
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 50,
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Overall History",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 36,
                              width: width * 0.28,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: DropdownButton(
                                iconSize: 13,
                                underline: SizedBox.shrink(),
                                elevation: 4,
                                dropdownColor: Colors.white,
                                alignment: AlignmentDirectional.centerStart,
                                itemHeight: 60,

                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),

                                // Initial Value
                                value: dropdownvalue,

                                // Down Arrow Icon
                                icon: SvgPicture.asset(
                                    'assets/icons/uparrow.svg'),

                                // Array list of items
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF263C91),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ]),

                      SizedBox(
                        height: 30,
                      ),

                      Container(
                        height: height * 0.30,
                        width: width * 0.88,
                        padding: EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transporter",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF263C91),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 55,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "Power Driver Transporter",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF263C91),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Destination",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263C91),
                                  ),
                                ),
                                SizedBox(
                                  width: 55,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "35, Soka, Ibadan, Oyo state",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF263C91),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Truck Type",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263C91),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "Regular Truck",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF263C91),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Status",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF263C91)),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    width: 102,
                                    height: 25,
                                    alignment: AlignmentDirectional.center,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: Color(0xFFFFF9C5),
                                    ),
                                    child: Text(
                                      "Processing",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFB2702A),
                                        // backgroundColor: Color(0xFFFFF9C5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/editicon.svg'),
                                SizedBox(
                                  width: 32,
                                ),
                                SvgPicture.asset('assets/icons/deleteicon.svg')
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Container(
                        height: height * 0.30,
                        width: width * 0.88,
                        padding: EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transporter",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF263C91),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 55,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "Power Driver Transporter",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF263C91),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Destination",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263C91),
                                  ),
                                ),
                                SizedBox(
                                  width: 55,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "35, Soka, Ibadan, Oyo state",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF263C91),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Truck Type",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263C91),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "Regular Truck",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF263C91),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Status",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF263C91)),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    width: 102,
                                    height: 25,
                                    alignment: AlignmentDirectional.center,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: Color(0xFFFFF9C5),
                                    ),
                                    child: Text(
                                      "Processing",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFB2702A),
                                        // backgroundColor: Color(0xFFFFF9C5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/editicon.svg'),
                                SizedBox(
                                  width: 32,
                                ),
                                SvgPicture.asset('assets/icons/deleteicon.svg')
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Container(
                        height: height * 0.30,
                        width: width * 0.88,
                        padding: EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transporter",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF263C91),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 55,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "Power Driver Transporter",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF263C91),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Destination",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263C91),
                                  ),
                                ),
                                SizedBox(
                                  width: 55,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "35, Soka, Ibadan, Oyo state",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF263C91),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Truck Type",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263C91),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                ),
                                Container(
                                    height: height * 0.05,
                                    width: width * 0.38,
                                    child: Text(
                                      "Regular Truck",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF263C91),
                                      ),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Status",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF263C91)),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    width: 102,
                                    height: 25,
                                    alignment: AlignmentDirectional.center,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: Color(0xFFFFF9C5),
                                    ),
                                    child: Text(
                                      "Processing",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFB2702A),
                                        // backgroundColor: Color(0xFFFFF9C5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/editicon.svg'),
                                SizedBox(
                                  width: 32,
                                ),
                                SvgPicture.asset('assets/icons/deleteicon.svg')
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 50,
                      ),

                      // Container(
                      //   alignment: Alignment.center,
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     child: Text(
                      //       "View all",
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         color: Color(0xFF263C91),
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/bluetrip.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/truck.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Registered Truck",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .025),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/greenincome.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Advance Income",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalAmountOfIncome,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/yellowtrip.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ongoing Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfOngoingTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/greentruck.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Available Truck",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrucks,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .025),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/yellowincome.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pending Income",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalAmountOfPendingIncome,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/completetrip.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Complete Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfCompletedTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/yellowtruck.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Unavailable Truck",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrucks,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .025),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/redincome.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Declined Income",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalAmountOfPendingIncome,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/redtrip.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Cancelled Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/unapprovedrequest.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Unapproved Request",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .025),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/approvedrequest.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Approved Request",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrucks,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/icons/cancelrequest.svg',
                              height: 64,
                              width: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Cancelled Request",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            width: width * 0.025,
          ),
        ],
      ),
    );
  }

  Widget Cargoowner(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.185 * 2.2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        children: [
          SizedBox(
            width: 5,
          ),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.bus_alert_outlined,
                              color: Colors.yellow[900],
                              size: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Trips",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.checklist_rtl_rounded,
                              size: 50,
                              color: Colors.green[800],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Completed Trips",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfCompletedTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .025),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.flag_rounded,
                              size: 60,
                              color: Colors.red[700],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Flagged Trips",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfFlaggedTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                              size: 60,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cancelled Trips",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(totalNumberOfCancelledTrips,
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .025),
        ],
      ),
    );
  }

  Widget Transporter(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.185 * 4.4,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        children: [
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.wallet_rounded,
                              color: Colors.green[800],
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Income",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),

                                SizedBox(
                                  width: width * .5,
                                  child: AutoSizeText(
                                      box
                                          .read('mystat')["totalAmountOfIncome"]
                                          .toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.w600)),
                                ),

                                // Text(
                                //     box
                                //         .read("mystat")["totalAmountOfIncome"]
                                //         .toString(),
                                //     style: TextStyle(
                                //         color: Color(0xFF333333),
                                //         fontSize: 25,
                                //         fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.add_location_alt,
                              size: 50,
                              color: Colors.green[900],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('mystat')["totalNumberOfTrips"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.checklist_rtl_rounded,
                              size: 50,
                              color: Colors.green[800],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Completed Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('mystat')[
                                            "totalNumberOfCompletedTrips"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.flag,
                              color: Colors.red,
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Flagged Trips",
                                    // "Total Advance Paid",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('mystat')[
                                            "totalNumberOfFlaggedTrips"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),

                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .05),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 70,
                              child: Stack(
                                // alignment: Alignment.centerRight,
                                children: [
                                  Icon(
                                    Icons.wallet,
                                    size: 50,
                                    color: Colors.amber[800],
                                  ),
                                  Positioned(
                                    left: 45, top: -3,
                                    child: Text(
                                      "₦",
                                      style: TextStyle(
                                          color: Colors.amber[800],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //   Icon(
                                    //   Icons.money,
                                    //   size: 40,
                                    //   color: Colors.red[700],
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pending Income",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                    box
                                        .read('mystat')[
                                            "totalAmountOfPendingIncome"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ]),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 70,
                              child: Stack(
                                // alignment: Alignment.centerRight,
                                children: [
                                  Icon(
                                    Icons.local_shipping_rounded,
                                    size: 50,
                                    color: Colors.amber[700],
                                  ),
                                  Positioned(
                                    left: 41,
                                    top: -3,
                                    child:
                                        // Text("₦", style: TextStyle(color: Colors.red[700], fontSize: 20, fontWeight: FontWeight.bold),),
                                        Icon(
                                      Icons.location_on_rounded,
                                      size: 30,
                                      color: Colors.amber[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ongoing Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('mystat')[
                                            "totalNumberOfOngoingTrips"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 7,
                            ),
                            SizedBox(
                              width: 70,
                              child: Stack(
                                // alignment: Alignment.centerRight,
                                children: [
                                  Icon(
                                    Icons.calendar_month_sharp,
                                    size: 50,
                                    color: Colors.amber[700],
                                  ),
                                  Positioned(
                                    left: 45, top: -3,
                                    child: Text(
                                      "₦",
                                      style: TextStyle(
                                          color: Colors.amber[700],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //   Icon(
                                    //   Icons.money,
                                    //   size: 40,
                                    //   color: Colors.red[700],
                                    // ),
                                  ),
                                ],
                              ),
                            ),

                            // Icon(
                            //   Icons.calendar_month_sharp,
                            //   size: 50,
                            //   color: Colors.red[700],
                            // ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Monthly Income",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),

                                SizedBox(
                                  width: width * .5,
                                  child: AutoSizeText(
                                      box
                                          .read('mystat')[
                                              "totalIncomeForTheMonth"]
                                          .toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600)),
                                ),

                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.cancel_presentation_outlined,
                              color: Colors.red,
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cancelled Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('mystat')[
                                            "totalNumberOfCancelledTrips"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          SizedBox(width: width * .05),
          Column(
            children: [
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.local_shipping_rounded,
                              size: 50,
                              color: Colors.yellow[900],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Truck",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('mystat')["totalNumberOfTrucks"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: height * 0.185,
                  width: width * 0.8,
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFFFFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.person_pin_circle_rounded,
                              size: 50,
                              color: Colors.yellow[900],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Number of Drivers",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('mystat')["totalNumberOfDrivers"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     "View all",
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       color: Color(0xFF263C91),
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget navigationDrawer(BuildContext context) => Drawer(
        child: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/icons/driverplaceholder.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${box.read('userdetails')['first_name']} ${box.read('userdetails')['last_name']}",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),

            // TextButton(
            //   onPressed: () {
            //   },
            //   child: const Text(
            //     'Manage Account',
            //     style: TextStyle(fontSize: 14, color: Colors.blue),
            //   ),
            // ),

            // const Divider(),

            const SizedBox(
              height: 10,
            ),
            // Padding(
            //     padding:
            //         EdgeInsets.only(top: MediaQuery.of(context).padding.top)),

            // ListTile(
            //     leading: Padding(
            //         padding: const EdgeInsets.only(top: 6),
            //         child: Icon(Icons.monetization_on)),
            //     title: const Text('Payment'),
            //     subtitle: const Text('Your Monitization channels'),
            //     onTap: () {
            //       Navigator.pop(context);
            //     }),
            // Divider(),
            // ListTile(
            //     leading: Padding(
            //         padding: const EdgeInsets.only(top: 6),
            //         child: Icon(Icons.info)),
            //     title: const Text('About ProDrivers'),
            //     subtitle: const Text('About ProDriver App'),
            //     onTap: () {

            //     }),

            // ListTile(
            //     leading: Padding(
            //       padding: const EdgeInsets.only(top: 6),
            //       child: Icon(Icons.support_agent),
            //     ),
            //     title: const Text('Support'),
            //     subtitle: const Text('Get support'),
            //     onTap: () {
            //       Navigator.pop(context);
            //     }),

            Divider(),

            ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(Icons.person_outlined),
                ),
                title: const Text('Profile'),
                subtitle: const Text('Edit Profile'),
                onTap: () {
                  Navigator.of(context);
                  Navigator.pushNamed(context, ProfileView.routeName);
                 
                }),

            Divider(),

            ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(Icons.logout),
                ),
                title: const Text('Log Out'),
                // subtitle: const Text('Get support'),
                onTap: () {
                  box.erase();
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(pageBuilder: (BuildContext context,
                          Animation animation, Animation secondaryAnimation) {
                        return ProdriversSignin();
                      }, transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return new SlideTransition(
                          position: new Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      }),
                      (Route route) => false);
                }),
          ],
        )),
      );
}
