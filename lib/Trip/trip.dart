import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:prodrivers/Authentication/prodriverssignin.dart';
import 'package:prodrivers/Authentication/prodriverssignup.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/utils.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../models/values/colors.dart';

class TripView extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _TripViewState createState() => _TripViewState();
}

class _TripViewState extends State<TripView> with RouteAware {
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

    print(box.read("userType"));
  }

  // GetAllTrips(userType) {
  //   // if (userType.toString() == "transporter") {
  //   AuthAPI.GET_WITH_TOKEN(urlendpoint: "trips").then((res) => {
  //         print(res),
  //       });
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            if (box.read("userType").toString() == "transporter") ...[
              Transporter(context),
            ],

            if (box.read("userType").toString() == "cargo-owner") ...[
              CargoOwner(context),
              
            ],
            SizedBox(
              height: 10,
            ),

            for (var trip in box.read("trips"))
              InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        height: height * .9,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "TRIP ID",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: width,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[300],
                                ),
                                child: Text(
                                  trip["trip_id"].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    // color: Colors.blue[900],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "DRIVER DETAILS",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: width,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${trip["driver"]["first_name"].toUpperCase()}  ${trip["driver"]["last_name"].toUpperCase()}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${trip["driver"]["phone_number"].toString()}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      //     Text(
                                      //   "PLATE: ${trip["driver"]["phone_number"].toString()}",
                                      //   style: TextStyle(
                                      //     fontSize: 15,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                    ],
                                  )),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "VEHICLE DETAILS",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: width,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${trip["truck"]["maker"].toString().toUpperCase()}  ${trip["truck"]["model"].toString().toUpperCase()}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                      Text(
                                        "${trip["truck"]["plate_number"].toString().toUpperCase()}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      //     Text(
                                      //   "PHONE: ${trip["driver"]["phone_number"].toString()}",
                                      //   style: TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w700,
                                      //   ),
                                      // ),
                                    ],
                                  )),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "PAYMENT DETAILS",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: width,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Payout Status",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "${trip["payout_status"].toString().toUpperCase()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total Payout",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            " ₦ ${trip["total_payout"].toString()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Advance Payout",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            " ₦ ${trip["advance_payout"].toString()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 12,
                              ),

                              Text(
                                "Time Requested",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "",
                              //     // "${Jiffy(trip["created_at"].toString()).format('HH:MM')}      ${Jiffy(trip["created_at"].toString()).format('do MMM yyyy')}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Text(
                              //   "Expected Arrival",
                              //   style: TextStyle(
                              //       fontSize: 12,
                              //       fontWeight: FontWeight.w600,
                              //       color: Colors.grey[700]),
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "",
                              //     // "${Jiffy(trip["date_needed"].toString()).format('HH:MM')}      ${Jiffy(trip["date_needed"].toString()).format('do MMM yyyy')}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Text(
                              //   "Pickup Address",
                              //   style: TextStyle(
                              //       fontSize: 12,
                              //       fontWeight: FontWeight.w600,
                              //       color: Colors.grey[700]),
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "${trip["pickup_address"].toString()}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 12,
                              // ),
                              // Text(
                              //   "Destination",
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w600,
                              //     color: Colors.grey[700],
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "${trip["destination_address"].toString()}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 18,
                              // ),
                              // Text(
                              //   "Owner's Details",
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w600,
                              //     color: Colors.grey[700],
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "${trip["cargo_owner"]["first_name"].toString().capitalize()} ${trip["cargo_owner"]["last_name"].toString().capitalize()}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 1,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "${trip["cargo_owner"]["email"].toString()}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 1,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "${trip["cargo_owner"]["phone_number"].toString()}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 18,
                              // ),
                              // Text(
                              //   "Cargo's Details",
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w600,
                              //     color: Colors.grey[700],
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   width: width,
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5),
                              //     color: Colors.grey[300],
                              //   ),
                              //   child: Text(
                              //     "${trip["tonnage"]["name"].toString()}         ${trip["truck_types"][0]["name"].toString()}",
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       // color: Colors.blue[900],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Card(
                  child: ListTile(
                    // leading: Image.network("https://media.istockphoto.com/id/1166844534/vector/young-male-worker-avatar-flat-illustration-police-man-bus-driver.jpg?s=1024x1024&w=is&k=20&c=_A2Py3WytcgYDmdONuvBRaA-UpgRJ4IhZjdvMMS_vGU="),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${trip["driver"]["first_name"].toString()}  ${trip["driver"]["last_name"].toString()}",
                          style: TextStyle(fontSize: 15),
                          maxLines: 1,
                        ),
                        Text(
                          "${trip["driver"]["phone_number"].toString()}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("DESTINATION ADDRESS",
                            style: TextStyle(fontSize: 11)),
                        Text(
                          trip["order"]["destination_address"].toString(),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            trip['trip_status']['name']
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(fontSize: 12),
                          ),
                          // Text("12:49 AM", style: TextStyle(fontSize: 12))
                        ]),
                    isThreeLine: true,
                  ),
                ),
              )
          
            
          ]),
    ));
  }

  Widget Transporter(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.185 * 2.2,
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
                            // Icon(Icons.bus_alert, color: Colors.yellow[900], size: 50,),
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
                                    box.read('tripsTransporter')["totalNumberOfTrips"]
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('tripsTransporter')[
                                            "totalNumberOfCompletedTrips"]
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
                              Icons.gesture_rounded,
                              color: Colors.green,
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ongoing Trips",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('tripsTransporter')[
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
                              Icons.car_crash,
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
                                Text("Accidented Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('tripsTransporter')[
                                            "totalNumberOfAccidentsTrips"]
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
                              Icons.rotate_90_degrees_ccw_rounded,
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
                                Text("Diverted Trips",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    box
                                        .read('tripsTransporter')[
                                            "totalNumberOfDivertedTrips"]
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
                                        .read('tripsTransporter')[
                                            "totalNumberOfCancelledTrips"]
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
            ],
          ),
        



          
        
        ],
      ),
    );
  }

  Widget CargoOwner(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.185 * 2.2,
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
                              Icons.bus_alert,
                              color: Colors.yellow[900],
                              size: 50,
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
                                Text(box.read("totalNumberOfTrips"),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
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
                              Icons.mark_email_read_rounded,
                              color: Colors.blue[900],
                              size: 50,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(box.read("totalNumberOfCompletedTrips"),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
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
                                Text("Ongoing Trips",
                                    // "Total Advance Paid",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(box.read("totalNumberOfOngoingTrips"),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
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
                              Icons.car_crash,
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
                                Text("Accidented Trip",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(box.read("totalNumberOfAccidentsTrips"),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
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
                              Icons.rotate_90_degrees_ccw_rounded,
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
                                Text("Diverted Trips",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(box.read("totalNumberOfDivertedTrips"),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
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
                                Text(box.read("totalNumberOfCancelledTrips"),
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                // ),
                              ],
                            ),
                          ]),
                    ],
                  )),
            ],
          ),
        
        
          
        ],
      ),
    );
  }
}
