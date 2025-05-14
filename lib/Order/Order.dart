import 'dart:ui';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/utils.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../models/values/colors.dart';

class OrderView extends StatefulWidget {
  static const String routeName = '/orderview';

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> with RouteAware {
  final box = GetStorage();

  GlobalKey<FormState> _logonKey = GlobalKey<FormState>();

  dynamic selectedTruckIdentity = null;
  final _amountNode = FocusNode();
  final _truckNode = FocusNode();
  final searchTRUCKFocusNode = FocusNode();
  final _amountCtrl = TextEditingController();
  final _truckCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // print(box.read("userType"));
    // print(box.read('truckRequest'));
    print(box.read('truckRequest')[0]["tonnage"]);
    print(box.read('truckRequest')[0]["truck_types"]);
    // print(box.read('truckRequest')[0]["id"]);
  }

  AcceptTruckRequest(
    requestID,
    truckID,
    amount,
  ) {
    AuthAPI
        .POST_WITH_TOKEN(
            urlendpoint: "accept/request/$requestID/from/transporter",
            postData: {"truck_id": truckID, "amount": amount}).then((res) => {
          print("ACCEPT REQ::"),
          print(res["result"]["requests"]["data"]),
          box.write('truckRequest', res["result"]["requests"]["data"]),
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              for (var truckRequest in box.read('truckRequest'))
                Container(
                  height: 440,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Available Request",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[900]),
                          ),
                          Text(
                            truckRequest["status"].toString().capitalize(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB2702A),
                              // backgroundColor: Color(0xFFFFF9C5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order ID",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            "Name of the Product",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            truckRequest["id"].toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[900]),
                          ),
                          SizedBox(
                            width: width * .6,
                            child: Text(
                              truckRequest["description"].toString(),
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[900]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SvgPicture.asset('assets/icons/lineicon.svg'),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pickup Address",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                    SizedBox(
                                      width: width * .5,
                                      child: Text(
                                        truckRequest["pickup_address"]
                                            .toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Destination",
                                      style: TextStyle(
                                        fontSize: 12,
                                        // color: Colors.grey[600]
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * .5,
                                      child: Text(
                                        truckRequest["destination_address"]
                                            .toString(),
                                        softWrap: true,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //     Jiffy(truckRequest["created_at"]
                                    //             .toString())
                                    //         .format('HH:MM'),
                                    //     style: TextStyle(
                                    //         fontSize: 11,
                                    //         fontWeight: FontWeight.w500)),
                                    // Text(
                                    //     Jiffy(truckRequest["created_at"]
                                    //             .toString())
                                    //         .format('do MMM'),
                                    //     style: TextStyle(
                                    //         fontSize: 11,
                                    //         fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //     Jiffy(truckRequest["date_needed"]
                                    //             .toString())
                                    //         .format('HH:MM'),
                                    //     style: TextStyle(
                                    //         fontSize: 11,
                                    //         fontWeight: FontWeight.w500)),
                                    // Text(
                                    //     Jiffy(truckRequest["date_needed"]
                                    //             .toString())
                                    //         .format('do MMM'),
                                    //     style: TextStyle(
                                    //         fontSize: 11,
                                    //         fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(Icons.person_pin_circle_sharp,
                              size: 40, color: Colors.grey[600]),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${truckRequest["cargo_owner"]["first_name"].toString().capitalize()} ${truckRequest["cargo_owner"]["last_name"].toString().capitalize()}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[900]),
                              ),
                              Text(
                                truckRequest["cargo_owner"]["email"].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(11)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF0D47A1)),
                              ),

                              onPressed: () => showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25)),
                                    ),
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: height * .9,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 35, vertical: 35),
                                          child: 
                                          
                                          SingleChildScrollView(child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Order ID",
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
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  truckRequest["id"].toString(),
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
                                                "Description of Cargo",
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
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  truckRequest["description"]
                                                      .toString(),
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
                                                "Time Requested",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700]),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              // Container(
                                              //   width: width,
                                              //   padding:
                                              //       const EdgeInsets.fromLTRB(
                                              //           20, 10, 20, 10),
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(5),
                                              //     color: Colors.grey[300],
                                              //   ),
                                              //   child: 
                                                // Text(
                                                //   "${Jiffy(truckRequest["created_at"].toString()).format('HH:MM')}      ${Jiffy(truckRequest["created_at"].toString()).format('do MMM yyyy')}",
                                                //   style: TextStyle(
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.w700,
                                                //     // color: Colors.blue[900],
                                                //   ),
                                                // ),
                                              // ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Expected Arrival",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700]),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              // Container(
                                              //   width: width,
                                              //   padding:
                                              //       const EdgeInsets.fromLTRB(
                                              //           20, 10, 20, 10),
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(5),
                                              //     color: Colors.grey[300],
                                              //   ),
                                              //   child: Text(
                                              //     "${Jiffy(truckRequest["date_needed"].toString()).format('HH:MM')}      ${Jiffy(truckRequest["date_needed"].toString()).format('do MMM yyyy')}",
                                              //     style: TextStyle(
                                              //       fontSize: 14,
                                              //       fontWeight: FontWeight.w700,
                                              //       // color: Colors.blue[900],
                                              //     ),
                                              //   ),
                                              // ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Pickup Address",
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
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  "${truckRequest["pickup_address"].toString()}",
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
                                                "Destination",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: width,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  "${truckRequest["destination_address"].toString()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    // color: Colors.blue[900],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 18,
                                              ),
                                              Text(
                                                "Owner's Details",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: width,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  "${truckRequest["cargo_owner"]["first_name"].toString().capitalize()} ${truckRequest["cargo_owner"]["last_name"].toString().capitalize()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    // color: Colors.blue[900],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1,
                                              ),
                                              Container(
                                                width: width,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  "${truckRequest["cargo_owner"]["email"].toString()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    // color: Colors.blue[900],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1,
                                              ),
                                              Container(
                                                width: width,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  "${truckRequest["cargo_owner"]["phone_number"].toString()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    // color: Colors.blue[900],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 18,
                                              ),
                                              Text(
                                                "Cargo's Details",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: width,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey[300],
                                                ),
                                                child: Text(
                                                  "${truckRequest["tonnage"]["name"].toString()}         ${truckRequest["truck_types"][0]["name"].toString()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    // color: Colors.blue[900],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                          
                                        
                                        
                                        ),
                                      );
                                    },
                                  ),
                              
                              
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: const Text('VIEW',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              )),
                          TextButton(
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(11)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF0D47A1)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          side: BorderSide(
                                              color: Color(0xFF0D47A1))))),
                              onPressed: () => showModalBottomSheet<void>(
                                    
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(50)),
                                    ),
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: height * .5,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: 50),
                                              Text(
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18,
                                                      color: Colors.blue[900]),
                                                  textAlign: TextAlign.center,
                                                  'ACCEPT THIS ORDER'),
                                              SizedBox(height: 30),
                                              const Text("AMOUNT",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              TextFormField(
                                                // focusNode: _amountNode,
                                                // controller: _amountCtrl,

                                                enabled: false,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                cursorColor:
                                                    const Color(0xFF3D3F92),
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  hintText: truckRequest[
                                                          'potential_payout']
                                                      .toString(),
                                                  hintStyle: TextStyle(
                                                      color: Colors.black),
                                                  focusColor:
                                                      Colors.blue.shade50,
                                                  // hintText: 'Enter your email',
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12,
                                                          vertical: 5),
                                                ),
                                                // keyboardType:
                                                //     TextInputType.emailAddress,
                                                // textInputAction:
                                                //     TextInputAction.next,
                                                // validator: (value) =>
                                                //     validateEmail(value!),
                                                // onChanged: (String value) {
                                                //   // user.password = value;
                                                // },
                                                // onEditingComplete: () {
                                                //   FocusScope.of(context)
                                                //       .requestFocus(_truckNode);
                                                // },
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              const Text("DELIVERY TRUCK",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                width: width,
                                                child: DropDownTextField(
                                                  clearOption: false,
                                                  textFieldFocusNode:
                                                      _truckNode,
                                                  validator: (value) =>
                                                      validateRequired(
                                                          value!, "Driver"),
                                                  searchFocusNode:
                                                      searchTRUCKFocusNode,
                                                  textFieldDecoration:
                                                      InputDecoration(
                                                    fillColor: Colors.white,
                                                    focusColor:
                                                        Colors.blue.shade50,
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.blue,
                                                              width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 15,
                                                            vertical: 11),
                                                  ),
                                                  dropDownItemCount: 5,
                                                  searchShowCursor: false,
                                                  enableSearch: true,
                                                  searchKeyboardType:
                                                      TextInputType.name,
                                                  dropDownList: [
                                                    for (var truck
                                                        in box.read('trucks'))
                                                      DropDownValueModel(
                                                        name:
                                                            '${truck["maker"]} ${truck["model"]}',
                                                        value: truck["id"],
                                                      ),
                                                  ],
                                                  onChanged: (selectVal) {
                                                    print(selectVal.value);

                                                    setState(() {
                                                      selectedTruckIdentity =
                                                          selectVal.value;
                                                    });
                                                    Navigator.of(context);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text(
                                                        ' C A N C E L '),
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                  ),
                                                  ElevatedButton(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: Colors
                                                                .blue[900],
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text('PROCEED',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        AcceptTruckRequest(
                                                            truckRequest["id"]
                                                                .toString(),
                                                            selectedTruckIdentity,
                                                            truckRequest[
                                                                'potential_payout']);
                                                      }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: const Text('ACCEPT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ],
                      ),
                    ],
                  ),
                )
            ],
          ),
        ));
  }

  // Widget Transporter(BuildContext context) {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;

  //   return Scaffold(
  //       body: CustomScrollView(
  //           // crossAxisAlignment: CrossAxisAlignment.center,
  //           // children: [
  //           slivers: <Widget>[
  //         SliverList(
  //             delegate:
  //                 SliverChildBuilderDelegate((BuildContext context, int index) {
  //           return Container(
  //             height: 440,
  //             padding: EdgeInsets.all(16),
  //             margin: EdgeInsets.symmetric(vertical: 15),
  //             decoration: const BoxDecoration(
  //               borderRadius: BorderRadius.all(Radius.circular(14)),
  //               color: Colors.white,
  //             ),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Available Request",
  //                       style: TextStyle(
  //                           fontSize: 17,
  //                           fontWeight: FontWeight.w600,
  //                           color: Colors.blue[900]),
  //                     ),
  //                     Text(
  //                       "Pending",
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         color: Color(0xFFB2702A),
  //                         // backgroundColor: Color(0xFFFFF9C5),
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Order ID",
  //                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //                     ),
  //                     Text(
  //                       "Name of the Product",
  //                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 8,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "#167497464",
  //                       style: TextStyle(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500,
  //                           color: Colors.blue[900]),
  //                     ),
  //                     Text(
  //                       "Construction Materials",
  //                       style: TextStyle(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w600,
  //                           color: Colors.blue[900]),
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 40,
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     children: [
  //                       SvgPicture.asset('assets/icons/lineicon.svg'),
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Pickup Address",
  //                                 style: TextStyle(
  //                                     fontSize: 12, color: Colors.grey[600]),
  //                               ),
  //                               Text(
  //                                 "35, Papa, Ogun state",
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Destination",
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                   // color: Colors.grey[600]
  //                                   color: Colors.grey[600],
  //                                 ),
  //                               ),
  //                               Text(
  //                                 "35, Soka, Oyo state",
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             "06/05/2022",
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               // fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           Text(
  //                             "09/05/2022",
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               // fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 40),
  //                 Row(
  //                   children: [
  //                     Icon(Icons.person_pin_circle_sharp,
  //                         size: 40, color: Colors.grey[600]),
  //                     SizedBox(
  //                       width: 25,
  //                     ),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           "Kandre Kan",
  //                           style: TextStyle(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w700,
  //                               color: Colors.blue[900]),
  //                         ),
  //                         Text(
  //                           "Kandre10@gmail.com",
  //                           style: TextStyle(
  //                             fontSize: 12,
  //                             color: Colors.grey[600],
  //                             // fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 25,
  //                 ),
  //                 Row(
  //                   children: [
  //                     IconButton(
  //                         onPressed: () async {
  //                           final call = Uri.parse('tel:08000000000');
  //                           if (await canLaunchUrl(call)) {
  //                             launchUrl(call);
  //                           } else {
  //                             throw 'Could not launch $call';
  //                           }
  //                         },
  //                         icon: Icon(
  //                           Icons.phone,
  //                           size: 34,
  //                           color: Colors.blue[900],
  //                         )),
  //                     SizedBox(
  //                       width: 32,
  //                     ),
  //                     IconButton(
  //                         onPressed: () async {
  //                           final email = Uri(
  //                             scheme: 'mailto',
  //                             path: 'kandre10@gmail.com',
  //                             query: 'subject=Hello&body=Test',
  //                           );
  //                           if (await canLaunchUrl(email)) {
  //                             launchUrl(email);
  //                           } else {
  //                             throw 'Could not launch $email';
  //                           }
  //                         },
  //                         icon: Icon(
  //                           Icons.outgoing_mail,
  //                           size: 40,
  //                           color: Colors.blue[900],
  //                         )),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           );
  //         }, childCount: 1)),
  //       ]
  //           // ],
  //           ));
  // }

}
