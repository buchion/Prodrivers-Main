import 'dart:ui';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
// import 'package:pie_chart/pie_chart.dart';
// import 'package:prodrivers/Authentication/prodriverssignin.dart';
import 'package:prodrivers/Authentication/prodriverssignup.dart';
import 'package:prodrivers/Truck/Truck.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/notification.dart';
import 'package:prodrivers/components/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

// import '../models/values/colors.dart';

class RequestView extends StatefulWidget {
  static const String routeName = '/request';

  @override
  _RequestViewState createState() => _RequestViewState();
}

bool isUploading_Pictures = false;

bool hasSelected_Pictures = false;

String Pictures = 'UPLOAD PRODUCT PICTURES';

String PicturesPATH = '';

dynamic image_Pictures_id = null;

dynamic driver_id = 0;
dynamic tonnage_id = 0;
dynamic trucktype_id = 0;

class _RequestViewState extends State<RequestView> with RouteAware {
  bool showWidget = false;
  bool openForm = false;

  final box = GetStorage();

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

  String dropdownvalue = 'Unapproved';

  final _dateNeededNode = FocusNode();
  final _dateNeededCtrl = TextEditingController();

  final _amountPayNode = FocusNode();
  final _amountPayCtrl = TextEditingController();

  // final searchFocusNode = FocusNode();
  final searchDRIVERFocusNode = FocusNode();

  final searchTONFocusNode = FocusNode();
  final searchTruckFocusNode = FocusNode();

  final _tonnageNode = FocusNode();
  final _tonnageCtrl = TextEditingController();

  final _truckTypeNode = FocusNode();
  final _truckTypeCtrl = TextEditingController();

  final _destinationAddressNode = FocusNode();
  final _destinationAddressCtrl = TextEditingController();

  final _pickupAddressNode = FocusNode();
  final _pickupAddressCtrl = TextEditingController();

  final _descriptionNode = FocusNode();
  final _descriptionCtrl = TextEditingController();

  static final _formRequest = GlobalKey<FormState>();

  var items = [
    'Unapproved',
    'Approved',
    'Cancelled',
  ];

  GetAllRequest(userType) {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: "truckRequests").then((res) => {
          box.write('truckRequest', res["result"]["requests"]["data"]),
          setState(() {
            
          })
        });
  }

  createRequest() {
    print({
      "amount_willing_to_pay": _amountPayCtrl.text,
      "date_needed": _dateNeededCtrl.text,
      "description": _descriptionCtrl.text,
      "destination_address": _destinationAddressCtrl.text,
      "display_amount_willing_to_pay": true,
      "number_of_trucks": "1",
      "pickup_address": _pickupAddressCtrl.text,
      "tonnage_id": tonnage_id,
      // "product_pictures": [image_Pictures_id],
      "truck_type_ids": [trucktype_id],
    });

    final Map<String, dynamic> REQUEST_DATA = {
      "amount_willing_to_pay": _amountPayCtrl.text,
      "date_needed": _dateNeededCtrl.text,
      "description": _descriptionCtrl.text,
      "destination_address": _destinationAddressCtrl.text,
      "display_amount_willing_to_pay": true,
      "number_of_trucks": "1",
      "pickup_address": _pickupAddressCtrl.text,
      "tonnage_id": tonnage_id,
      // "product_pictures": [image_Pictures_id],
      "truck_type_ids": [trucktype_id],
    };

    image_Pictures_id != null
        ? REQUEST_DATA["product_pictures"] = [image_Pictures_id]
        : null;

    print(REQUEST_DATA);

    // if (_formAddDriver.currentState!.validate()) {
    FocusScope.of(context).unfocus();
    AuthAPI.POST_WITH_TOKEN(
            urlendpoint: "truckRequests", postData: REQUEST_DATA)
        .then((value) => {
              print(value),
              if (value["success"] == true)
                {
                  Navigator.pop(context),
                  _amountPayCtrl.clear(),
                  _dateNeededCtrl.clear(),
                  _descriptionCtrl.clear(),
                  _destinationAddressCtrl.clear(),
                  _pickupAddressCtrl.clear(),
                  setState(() {
                    Pictures = "UPLOAD PRODUCT PICTURES";
                    PicturesPATH = "";
                    hasSelected_Pictures = false;
                  }),
                  GetAllRequest(box.read("userType"))
                }
            });
    // }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return CargoOwner();
  }

  Widget CargoOwner() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.145,
                    width: width * 0.45,
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  StatefulBuilder(builder: (context, setState) {
                                    uploadImage(ImageFilePath, RESOURCE_NAME) {
                                      print(ImageFilePath);
                                      AuthAPI.UploadSingleFiles(
                                              filePath: ImageFilePath)
                                          .then((value) => {
                                                print(
                                                    'VALUE FOR UPLOAD:$value'),
                                                if (RESOURCE_NAME == Pictures)
                                                  {
                                                    if (value["success"] ==
                                                        true)
                                                      {
                                                        notifyInfo(
                                                            content:
                                                                "PRODUCT IMAGES UPLOADED"),
                                                        setState(() {
                                                          image_Pictures_id =
                                                              value["result"]
                                                                      ["file"]
                                                                  ["id"];
                                                          isUploading_Pictures =
                                                              false;
                                                        }),
                                                      }
                                                    else
                                                      {
                                                        notifyError(
                                                            content:
                                                                "PRODUCT IMAGES NOT UPLOADED."),
                                                        setState(() {
                                                          isUploading_Pictures =
                                                              false;
                                                        }),
                                                      }
                                                  },
                                              })
                                          .onError((error, stackTrace) => {
                                                print(error),
                                                notifyError(
                                                    content:
                                                        "DOCUMENT NOT UPLOADED"),
                                                // setState(() {
                                                //   isUploading_TruckLicense = false;
                                                // }),
                                              });
                                    }

                                    uploadFileFunc(DOC_NAME) async {
                                      if (DOC_NAME == Pictures) {
                                        FilePickerResult? result =
                                            await FilePicker.platform
                                                .pickFiles();
                                        if (result != null) {
                                          // File file = File(result.files.single.path.toString());
                                          print(
                                              "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                                          setState(() {
                                            isUploading_Pictures = true;
                                            hasSelected_Pictures = true;
                                            Pictures = result.files.single.name;
                                            PicturesPATH = result
                                                .files.single.path
                                                .toString();
                                          });

                                          uploadImage(PicturesPATH, Pictures);
                                        }
                                      }
                                    }

                                    return AlertDialog(
                                      insetPadding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      content: SizedBox(
                                        height: height * .8,
                                        child: Form(
                                          key: _formRequest,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 2,
                                                  width: width * .8,
                                                ),
                                                const Text("PICKUP ADDRESS",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                SizedBox(
                                                  width: width * .8,
                                                  child: TextField(
                                                    focusNode:
                                                        _pickupAddressNode,
                                                    controller:
                                                        _pickupAddressCtrl,
                                                    // cursorColor: HVColors.newprimary,
                                                    decoration: InputDecoration(
                                                      // fillColor: HVColors.InputBoxFill,
                                                      filled: true,
                                                      errorText:
                                                          validateRequired(
                                                              _pickupAddressCtrl
                                                                  .text,
                                                              "Pickup Address"),
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 15,
                                                              vertical: 11),
                                                      // border: InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      hintText:
                                                          'Enter the Pickup Address',
                                                      // prefixText: 'NGN ',
                                                      hintStyle: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal),
                                                      // enabled: !processing,
                                                      // errorText: emailError,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    maxLines: 3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        // _enteredText = value;
                                                      });
                                                    },
                                                    onEditingComplete: () {
                                                      // FocusScope.of(context).requestFocus(_emailNode);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text(
                                                    "DESTINATION ADDRESS",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                SizedBox(
                                                  width: width * .8,
                                                  child: TextField(
                                                    focusNode:
                                                        _destinationAddressNode,
                                                    controller:
                                                        _destinationAddressCtrl,
                                                    // cursorColor: HVColors.newprimary,
                                                    decoration: InputDecoration(
                                                      // fillColor: HVColors.InputBoxFill,
                                                      filled: true,
                                                      errorText: validateRequired(
                                                          _destinationAddressCtrl
                                                              .text,
                                                          "Destination Address"),
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 15,
                                                              vertical: 11),
                                                      // border: InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      hintText:
                                                          'Enter the Destination Address',
                                                      // prefixText: 'NGN ',
                                                      hintStyle: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal),
                                                      // enabled: !processing,
                                                      // errorText: emailError,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    maxLines: 3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        // _enteredText = value;
                                                      });
                                                    },
                                                    onEditingComplete: () {
                                                      // FocusScope.of(context).requestFocus(_emailNode);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                            "DATE NEEDED",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        SizedBox(
                                                          width: width * .39,
                                                          child: TextFormField(
                                                            focusNode:
                                                                _dateNeededNode,
                                                            controller:
                                                                _dateNeededCtrl,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20),
                                                            cursorColor:
                                                                const Color(
                                                                    0xFF3D3F92),
                                                            validator: (value) =>
                                                                validateRequired(
                                                                    value!,
                                                                    "Date Needed"),
                                                            onTap: () async {
                                                              DateTime?
                                                                  pickedDate =
                                                                  await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate:
                                                                          DateTime
                                                                              .now(), //get today's date
                                                                      firstDate:
                                                                          DateTime
                                                                              .now(), //DateTime.now() - not to allow to choose before today.
                                                                      lastDate:
                                                                          DateTime(
                                                                              2100));

                                                              if (pickedDate !=
                                                                  null) {
                                                                print(
                                                                    pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                                                String
                                                                    formattedDate =
                                                                    DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                                print(
                                                                    formattedDate); //formatted date output using intl package =>  2022-07-04
                                                                //You can format date as per your need

                                                                setState(() {
                                                                  _dateNeededCtrl
                                                                          .text =
                                                                      formattedDate; //set foratted date to TextField value.
                                                                });
                                                              } else {
                                                                print(
                                                                    "Date is not selected");
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              // icon: Icon(Icons
                                                              //     .calendar_today),
                                                              fillColor:
                                                                  Colors.white,
                                                              focusColor: Colors
                                                                  .blue.shade50,
                                                              filled: true,
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          11),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            // validator: (value) => validateEmail(value!),
                                                            onChanged:
                                                                (String value) {
                                                              // user.password = value;
                                                            },
                                                            onEditingComplete:
                                                                () {
                                                              // FocusScope.of(context).requestFocus(_passwordNode);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                            "AMOUNT TO PAY",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        SizedBox(
                                                          width: width * .39,
                                                          child: TextFormField(
                                                            focusNode:
                                                                _amountPayNode,
                                                            controller:
                                                                _amountPayCtrl,
                                                            validator: (value) =>
                                                                validateRequired(
                                                                    value!,
                                                                    "Amount"),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20),
                                                            cursorColor:
                                                                const Color(
                                                                    0xFF3D3F92),
                                                            decoration:
                                                                InputDecoration(
                                                              fillColor:
                                                                  Colors.white,
                                                              focusColor: Colors
                                                                  .blue
                                                                  .shade600,
                                                              filled: true,
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              // labelText: Strings.register.pass,

                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          11),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            // validator: validatePassword as String Function(String),
                                                            onChanged:
                                                                (String value) {
                                                              // user.password = value;
                                                            },
                                                            onEditingComplete:
                                                                () {
                                                              // FocusScope.of(context).requestFocus(_passwordNode);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 13,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                            "Tonnage of Goods",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        SizedBox(
                                                          width: width * .39,
                                                          child:
                                                              DropDownTextField(
                                                            clearOption: false,
                                                            validator: (value) =>
                                                                validateRequired(
                                                                    value!,
                                                                    "Tonnage"),
                                                            textFieldFocusNode:
                                                                _tonnageNode,
                                                            searchFocusNode:
                                                                searchTONFocusNode,
                                                            // searchAutofocus: true,
                                                            textFieldDecoration:
                                                                InputDecoration(
                                                              fillColor:
                                                                  Colors.white,
                                                              focusColor: Colors
                                                                  .blue.shade50,
                                                              // hintText: 'Enter your email',
                                                              filled: true,

                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          11),
                                                            ),
                                                            dropDownItemCount:
                                                                5,
                                                            searchShowCursor:
                                                                false,
                                                            enableSearch: true,
                                                            searchKeyboardType:
                                                                TextInputType
                                                                    .number,
                                                            dropDownList:
                                                                // box.read('tonnages'),
                                                                [
                                                              for (var tons
                                                                  in box.read(
                                                                      'tonnages'))
                                                                DropDownValueModel(
                                                                    name: tons["name"],
                                                                    value: tons[
                                                                        "id"]),
                                                            ],
                                                            onChanged: (val) {
                                                              print(val.value);

                                                            
                                                              setState(() {
                                                                tonnage_id =
                                                                    val.value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                            "Truck Type Needed",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black45,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        SizedBox(
                                                          width: width * .39,
                                                          child:
                                                              DropDownTextField(
                                                            clearOption: false,
                                                            validator: (value) =>
                                                                validateRequired(
                                                                    value!,
                                                                    "Truck Type"),
                                                            textFieldFocusNode:
                                                                _truckTypeNode,
                                                            searchFocusNode:
                                                                searchTruckFocusNode,
                                                            // searchAutofocus: true,
                                                            textFieldDecoration:
                                                                InputDecoration(
                                                              fillColor:
                                                                  Colors.white,
                                                              focusColor: Colors
                                                                  .blue.shade50,
                                                              // hintText: 'Enter your email',
                                                              filled: true,
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                              ),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .blue),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          11),
                                                            ),
                                                            dropDownItemCount:
                                                                6,
                                                            searchShowCursor:
                                                                false,
                                                            enableSearch: true,
                                                            searchKeyboardType:
                                                                TextInputType
                                                                    .number,
                                                            dropDownList:
                                                                // box.read('tonnages'),
                                                                [
                                                              for (var truck
                                                                  in box.read(
                                                                      'truck_types'))
                                                                DropDownValueModel(
                                                                    name: truck[
                                                                            "name"]
                                                                        .toString()
                                                                        .toUpperCase(),
                                                                    value: truck[
                                                                        "id"]),
                                                            ],
                                                            onChanged: (val) {
                                                              print(val.value);
                                                              setState(() {
                                                                trucktype_id = val.value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 11,
                                                ),
                                                const Text("PRODUCT DESCRITION",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                SizedBox(
                                                  width: width * .8,
                                                  child: TextField(
                                                    focusNode: _descriptionNode,
                                                    controller:
                                                        _descriptionCtrl,
                                                    // cursorColor: HVColors.newprimary,
                                                    decoration: InputDecoration(
                                                      // fillColor: HVColors.InputBoxFill,
                                                      filled: true,
                                                      errorText: validateRequired(
                                                          _descriptionCtrl.text,
                                                          "Product Description"),
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 15,
                                                              vertical: 11),
                                                      // border: InputBorder.none,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      hintText:
                                                          'Describe the Good you want to move',
                                                      // prefixText: 'NGN ',
                                                      hintStyle: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal),
                                                      // enabled: !processing,
                                                      // errorText: emailError,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    maxLines: 3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        // _enteredText = value;
                                                      });
                                                    },
                                                    onEditingComplete: () {
                                                      // FocusScope.of(context).requestFocus(_emailNode);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    uploadFileFunc(Pictures);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      hasSelected_Pictures
                                                          ? Icon(
                                                              Icons
                                                                  .library_add_check_rounded,
                                                              size: 35,
                                                              color: Colors
                                                                  .blue[800],
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .add_a_photo_outlined,
                                                              size: 35,
                                                            ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                          Pictures
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black45,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)),
                                                      hasSelected_Pictures
                                                          ? TextButton(
                                                              onPressed: () {
                                                                showDialog<
                                                                        String>(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        StatefulBuilder(builder:
                                                                            (context,
                                                                                setState) {
                                                                          return AlertDialog(
                                                                            content:
                                                                                Image.asset(Pictures.toString()),
                                                                          );
                                                                        }));
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .remove_red_eye_rounded,
                                                                color: Colors
                                                                    .blue[800],
                                                              ))
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                                isUploading_Pictures
                                                    ? LinearProgressIndicator()
                                                    : SizedBox(
                                                        height: 10,
                                                      ),
                                              ]),
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(' C L O S E ')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  createRequest();
                                                },
                                                child: Text(' CREATE NEW '))
                                          ],
                                        )
                                      ],
                                    );
                                  }));
                        },
                        style: 
                        ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFF263C91))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.add,
                              //   size: 30,
                              // ),

                              Text("ADD NEW",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.4)),
                              SizedBox(
                                height: 8,
                              ),
                              Text("REQUEST",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.4)),
                            ])),
                  ),
                  Column(
                    children: [
                      Text("${box.read('truckRequest').length.toString()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00327C),
                            letterSpacing: 2,
                          )),
                      Text("TOTAL REQUEST",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF00327C),
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                  SizedBox(
                    width: 1,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    height: height * 0.185,
                    width: width * 0.4,
                    padding: EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[900],
                          size: 40,
                        ),
                        Text("APPROVED",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(box.read("totalNumberOfTrips"),
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 30,
                                fontWeight: FontWeight.w600)),
                      ],
                    )),
                Container(
                    height: height * 0.185,
                    width: width * 0.4,
                    padding: EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.red[900],
                          size: 40,
                        ),
                        Text("CANCELLED",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(box.read("totalNumberOfCancelledTrips"),
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 30,
                                fontWeight: FontWeight.w600)),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            for (var trip in box.read("truckRequest"))
              Column(
                children: [
                  Container(
                    height: height * .4,
                    width: width * 0.94,
                    padding: EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       "ACTIVE TRIP",
                        //       style: TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.w600),
                        //     ),
                        //     TextButton(
                        //       onPressed: () {

                        //       },
                        //       child: Container(
                        //         width: 90,
                        //         height: 20,
                        //         alignment: AlignmentDirectional.center,
                        //         decoration: const BoxDecoration(
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(12)),
                        //           color: Color(0xFFFFF9C5),
                        //         ),
                        //         child: Text(
                        //           "On Trip",
                        //           style: TextStyle(
                        //             fontSize: 12,
                        //             color: Color(0xFFB2702A),
                        //             // backgroundColor: Color(0xFFFFF9C5),
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),

                        // SizedBox(
                        //   height: 25,
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Order No",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFA2A2A2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Product",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFA2A2A2),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip["id"].toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                                width: width * .6,
                                child: Text(
                                  trip["description"].toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ))
                          ],
                        ),

                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SvgPicture.asset('assets/icons/lineicon.svg'),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pickup Address",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF777777),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .53,
                                            child: Text(
                                              trip["pickup_address"].toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Destination",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF777777),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .53,
                                            child: Text(
                                              trip["destination_address"]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(
                                  //   width: width * .16,
                                  //   child: Text(
                                  //       Jiffy(trip["created_at"].toString())
                                  //           .format(pattern: 'do MMM yyyy HH:mm'),
                                  //       style: TextStyle(
                                  //           fontSize: 15,
                                  //           fontWeight: FontWeight.w500)),
                                  // ),
                                  // SizedBox(
                                  //   width: width * .16,
                                  //   child: Text(
                                  //       Jiffy(trip["created_at"].toString())
                                  //           .format(pattern: 'do MMM yyyy HH:mm'),
                                  //       style: TextStyle(
                                  //           fontSize: 15,
                                  //           fontWeight: FontWeight.w500)),
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
          ]),
        ));
  }

  Widget Admin() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.145,
                    width: width * 0.45,
                    child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                scrollable: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                title: Text(
                                  'Enter Request Details',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                content: SizedBox(
                                  width: width * 0.9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pickup Address",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            height: 30,
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 13),
                                              cursorColor:
                                                  const Color(0xFF3D3F92),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor:
                                                    Colors.blue.shade600,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                              ),
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (String value) {},
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Destination Address",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            height: 30,
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 13),
                                              cursorColor:
                                                  const Color(0xFF3D3F92),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor:
                                                    Colors.blue.shade600,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                              ),
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (String value) {},
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Package Weight(Tons)",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            height: 30,
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 13),
                                              cursorColor:
                                                  const Color(0xFF3D3F92),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor:
                                                    Colors.blue.shade600,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                              ),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (String value) {},
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Product Description",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            height: 30,
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 13),
                                              cursorColor:
                                                  const Color(0xFF3D3F92),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor:
                                                    Colors.blue.shade600,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                              ),
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (String value) {},
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Business Unit",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            height: 30,
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 13),
                                              cursorColor:
                                                  const Color(0xFF3D3F92),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor:
                                                    Colors.blue.shade600,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                              ),
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (String value) {},
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pickup Date",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            height: 30,
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 13),
                                              cursorColor:
                                                  const Color(0xFF3D3F92),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor:
                                                    Colors.blue.shade600,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                              ),
                                              keyboardType:
                                                  TextInputType.datetime,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (String value) {},
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Amount",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            height: 30,
                                            child: TextField(
                                              style:
                                                  const TextStyle(fontSize: 13),
                                              cursorColor:
                                                  const Color(0xFF3D3F92),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor:
                                                    Colors.blue.shade600,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (String value) {},
                                              onEditingComplete: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: width * 0.26,
                                              height: height * 0.03,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Product Picture",
                                                    style: const TextStyle(
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        // height: height * 0.05,
                                        width: width * 0.34,
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Color(0xFF263C91))),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text("CREATE NEW",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                  // Text("Request",
                                                  //     style: TextStyle(
                                                  //       fontSize: 13,
                                                  //       fontWeight:
                                                  //           FontWeight.w400,
                                                  //     )),
                                                ])),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFF263C91))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.add,
                              //   size: 30,
                              // ),

                              Text("ADD NEW",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.4)),
                              SizedBox(
                                height: 8,
                              ),
                              Text("REQUEST",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.4)),
                            ])),
                  ),
                  Column(
                    children: [
                      Text("23",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00327C),
                            letterSpacing: 2,
                          )),
                      Text("TOTAL REQUEST",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF00327C),
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                  SizedBox(
                    width: 1,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
                height: height * 0.185,
                width: width * 0.9,
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
                            Icons.route_rounded,
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
                              Text(box.read("totalNumberOfTrips"),
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
              height: 15,
            ),

            Container(
                height: height * 0.185,
                width: width * 0.9,
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
                            Icons.check_circle,
                            color: Colors.green[900],
                            size: 60,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Approved Request",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(box.read("totalNumberOfTrips"),
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
              height: 15,
            ),

            Container(
                height: height * 0.185,
                width: width * 0.9,
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
                            Icons.cancel,
                            color: Colors.red[900],
                            size: 60,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Cancelled Request",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(box.read("totalNumberOfTrips"),
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
              height: 40,
            ),

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
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Active Trip",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Container(
                                  width: 90,
                                  height: 20,
                                  alignment: AlignmentDirectional.center,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SvgPicture.asset('assets/icons/lineicon.svg'),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Pickup Address",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFCCCCCC),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "35, Papa, Ogun state",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Destination",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFCCCCCC),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "35, Soka, Oyo state",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  final call = Uri.parse('tel:08000000000');
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
                                                BorderRadius.circular(8))),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xFFEEEEEE)),
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.all(0))),
                                child:
                                    SvgPicture.asset('assets/icons/call.svg'),
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
                                                BorderRadius.circular(8))),
                                    backgroundColor: MaterialStatePropertyAll(
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
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Active Trip",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Container(
                                  width: 90,
                                  height: 20,
                                  alignment: AlignmentDirectional.center,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SvgPicture.asset('assets/icons/lineicon.svg'),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Pickup Address",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFCCCCCC),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "35, Papa, Ogun state",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Destination",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFCCCCCC),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "35, Soka, Oyo state",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  final call = Uri.parse('tel:08000000000');
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
                                                BorderRadius.circular(8))),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xFFEEEEEE)),
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.all(0))),
                                child:
                                    SvgPicture.asset('assets/icons/call.svg'),
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
                                                BorderRadius.circular(8))),
                                    backgroundColor: MaterialStatePropertyAll(
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

            // Container(
            //   height: height * 0.55,
            //   width: width * 0.5,
            //   padding: EdgeInsets.all(16),
            //   decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(14)),
            //     color: Colors.white,
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Container(
            //         alignment: Alignment.center,
            //         child: Text(
            //           "Today's History for Request",
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //       PieChart(
            //         dataMap: dataMap,
            //         animationDuration: Duration(milliseconds: 800),
            //         chartLegendSpacing: 18,
            //         chartRadius: MediaQuery.of(context).size.width / 3.1,
            //         colorList: colorList,
            //         initialAngleInDegree: 0,
            //         chartType: ChartType.ring,
            //         ringStrokeWidth: 24,
            //         legendOptions: LegendOptions(
            //           showLegendsInRow: false,
            //           legendPosition: LegendPosition.bottom,
            //           showLegends: false,
            //           legendShape: BoxShape.circle,
            //           legendTextStyle: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //             // color: Color.fromARGB(255, 141, 140, 140),
            //           ),
            //         ),
            //         chartValuesOptions: ChartValuesOptions(
            //           showChartValueBackground: true,
            //           showChartValues: false,
            //           showChartValuesInPercentage: false,
            //           showChartValuesOutside: false,
            //           decimalPlaces: 0,
            //         ),
            //       )

            //     ],
            //   ),
            // ),

            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text(
                "Request History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 36,
                width: width * 0.28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: DropdownButton(
                  iconSize: 13,
                  underline: SizedBox.shrink(),
                  elevation: 4,
                  dropdownColor: Colors.white,
                  alignment: AlignmentDirectional.centerStart,
                  itemHeight: 60,

                  borderRadius: BorderRadius.all(Radius.circular(10)),

                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: SvgPicture.asset('assets/icons/uparrow.svg'),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(
                          fontSize: 12,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProdriversSignup()),
                          );
                        },
                        child: Container(
                          width: 102,
                          height: 25,
                          alignment: AlignmentDirectional.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProdriversSignup()),
                          );
                        },
                        child: Container(
                          width: 102,
                          height: 25,
                          alignment: AlignmentDirectional.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF263C91),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ]),
        ));
  }

}
