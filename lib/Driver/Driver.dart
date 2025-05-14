import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jiffy/jiffy.dart';
import 'package:prodrivers/Dashboard/home.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/notification.dart';
import 'package:prodrivers/components/utils.dart';

class DriverView extends StatefulWidget {
  static const String routeName = '/driverview';

  @override
  _DriverViewState createState() => _DriverViewState();
}

bool isUploadingAvatar = false;
bool isUploadingLicense = false;

bool hasSelectedLicenseImage = false;
String LicenseImageName = "ADD LICENCE IMAGE";
String LicenseImagePath = "";

String AvatarImagePath = "assets/icons/driverplaceholder.png";

dynamic picture_id = null;
dynamic license_picture_id = null;

class _DriverViewState extends State<DriverView> with RouteAware {
  final _storage = const FlutterSecureStorage();

  final _firstnameNode = FocusNode();
  final _firstnameCtrl = TextEditingController();
  final _lastnameNode = FocusNode();
  final _lastnameCtrl = TextEditingController();
  final _phonenumberNode = FocusNode();
  final _phonenumberCtrl = TextEditingController();

  final _licenseNumberNode = FocusNode();
  final _licenseNumberCtrl = TextEditingController();

  static final _formAddDriver = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstnameNode.dispose();
    _firstnameCtrl.dispose();

    _lastnameNode.dispose();
    _lastnameCtrl.dispose();

    _phonenumberNode.dispose();
    _phonenumberCtrl.dispose();

    _licenseNumberNode.dispose();
    _licenseNumberCtrl.dispose();

    super.dispose();
  }

  // static const int numItems = 10;
  // List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    print(box.read("drivers"));
  }

  showDriverDetails(driverDetails) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print(driverDetails);

    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              uploadAvatar(ImageFilePath) {
                setState(() {
                  isUploadingAvatar = true;
                });
                print(ImageFilePath);
                AuthAPI.UploadSingleFiles(filePath: ImageFilePath)
                    .then((value) => {
                          print("VALUE FOR UPLOAD AVATAR $value"),
                          if (value["success"] == true)
                            {
                              notifyInfo(content: "Avatar Upload Succesfully"),
                              setState(() {
                                picture_id = value["result"]["file"]["id"];
                                isUploadingAvatar = false;
                              }),
                            }
                          else
                            {
                              notifyError(content: "AVATAR UPLOAD FAILED"),
                              setState(() {
                                isUploadingAvatar = false;
                              }),
                            }
                        })
                    .onError((error, stackTrace) => {
                          notifyError(content: "AVATAR UPLOAD FAILED"),
                          setState(() {
                            isUploadingAvatar = false;
                          }),
                        });
              }

              uploadImage(ImageFilePath) {
                setState(() {
                  isUploadingLicense = true;
                });
                // print(ImageFilePath);
                AuthAPI.UploadSingleFiles(filePath: ImageFilePath)
                    .then((value) => {
                          print('VALUE FOR LICENSE UPLOAD:$value'),
                          if (value["success"] == true)
                            {
                              notifyInfo(content: "LICENSE UPLOAD SUCCESSFUL"),
                              setState(() {
                                license_picture_id =
                                    value["result"]["file"]["id"];
                              }),
                              setState(() {
                                isUploadingLicense = false;
                              }),
                            }
                          else
                            {
                              notifyError(content: "LICENSE NOT UPLOADED"),
                              setState(() {
                                isUploadingLicense = false;
                              }),
                            }
                        })
                    .onError((error, stackTrace) => {
                          notifyError(content: "LICENSE NOT UPLOADED"),
                          setState(() {
                            isUploadingLicense = false;
                          }),
                        });
              }

              return AlertDialog(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                title: Stack(
                  alignment: Alignment.center,
                  children: [
                    driverDetails["picture_id"] != null
                        ? SizedBox(
                            child: CircularProgressIndicator(),
                            height: 150.0,
                            width: 150.0,
                          )
                        : SizedBox(),
                    CircleAvatar(
                      radius: 85,
                      child: CircleAvatar(
                        radius: 81,
                        backgroundColor: Colors.blue[50],
                        foregroundImage:
                            NetworkImage(driverDetails['picture']["url"]),
                        backgroundImage: AssetImage(AvatarImagePath),
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();

                            if (result != null) {
                              File file =
                                  File(result.files.single.path.toString());

                              setState(() {
                                AvatarImagePath =
                                    result.files.single.path.toString();
                              });
                              uploadAvatar(AvatarImagePath);
                            } else {
                              // User canceled the picker
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  height: height * .6,
                  child: Form(
                    // key: _formAddDriver,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 2,
                            width: width * .8,
                          ),
                          const Text("First Name",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            focusNode: _firstnameNode,
                            controller: _firstnameCtrl,
                            style: const TextStyle(fontSize: 17),
                            cursorColor: const Color(0xFF3D3F92),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusColor: Colors.blue.shade600,
                              filled: true,
                              hintText: driverDetails["first_name"],
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              // labelText: Strings.register.pass,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 11),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                validateRequired(value!, "First Name"),
                            onEditingComplete: () {
                              // FocusScope.of(context).requestFocus(_passwordNode);
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Last Name",
                              style: TextStyle(
                                  fontSize: 15,
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
                              hintText: driverDetails["last_name"],
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              // labelText: Strings.register.pass,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 11),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                validateRequired(value!, "Last Name"),
                            onChanged: (String value) {
                              // user.password = value;
                            },
                            onEditingComplete: () {
                              // FocusScope.of(context).requestFocus(_passwordNode);
                            },
                          ),
                          const SizedBox(
                            height: 11,
                          ),
                          const Text("Phone Number",
                              style: TextStyle(
                                  fontSize: 15,
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
                              hintText: driverDetails["phone_number"],
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              // labelText: Strings.register.pass,
                              // border: InputBorder.none,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 11),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) => validateRequired(
                                value.toString(), "Phone Number"),
                            // validator: numberValidator,
                            // onEditingComplete: () {
                            // FocusScope.of(context).requestFocus(_passwordNode);
                            // },
                          ),
                          const Text("License Number",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            focusNode: _licenseNumberNode,
                            controller: _licenseNumberCtrl,
                            // enabled: !processing,
                            style: const TextStyle(fontSize: 20),
                            cursorColor: const Color(0xFF3D3F92),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusColor: Colors.blue.shade50,
                              hintText: driverDetails["license_number"],
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              // labelText: Strings.register.pass,
                              // border: InputBorder.none,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 11),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            // validator: (value) => validateEmail(value!),
                            onChanged: (String value) {
                              // user.password = value;
                            },
                            onEditingComplete: () {
                              // FocusScope.of(context).requestFocus(_passwordNode);
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    File file = File(
                                        result.files.single.path.toString());
                                    print("file PATH::++__+_::=>");
                                    print(file);
                                    print(result.files.single.name);

                                    setState(() {
                                      isUploadingLicense = true;
                                      LicenseImagePath =
                                          result.files.single.path.toString();
                                      LicenseImageName =
                                          result.files.single.name;
                                      hasSelectedLicenseImage = true;
                                    });

                                    uploadImage(LicenseImagePath);
                                  } else {}
                                },
                                child: Row(
                                  children: [
                                    driverDetails["license_picture_id"] != null
                                        ? Icon(
                                            Icons.library_add_check_rounded,
                                            size: 35,
                                            color: Colors.blue[800],
                                          )
                                        : Icon(
                                            Icons.photo_camera_front_rounded,
                                            size: 35,
                                          ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        driverDetails["license_picture"]
                                            ["name"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                              driverDetails["license_picture_id"] != null
                                  ? TextButton(
                                      onPressed: () {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return AlertDialog(
                                                    content: Image.network(
                                                        driverDetails[
                                                                    "license_picture"]
                                                                ["url"] ??
                                                            ''),
                                                  );
                                                }));
                                      },
                                      child: Text('VIEW LICENSE'),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          isUploadingLicense
                              ? LinearProgressIndicator()
                              : SizedBox(),
                        ]),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(' C L O S E ')),
                      ElevatedButton(
                          onPressed: () {}, child: Text(' U P D A T E ')),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                ],
              );
            }));
  }

  GetAllDrivers(userType) {
    if (userType.toString() == "transporter") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: "drivers")
          // urlendpoint: "transporters/${box.read('userid')}/driver")
          .then((res) => {
                print(res),
                print(res["result"]["drivers"]["data"]),
                box.write("drivers", res["result"]["drivers"]["data"]),
                setState(() {}),
              });
    }

    if (userType.toString() == "admin") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: "transporters/1/driver")
          .then((res) => {
                // print(res),
                print(res["result"]["drivers"]),
                box.write("drivers", res["result"]["drivers"]),
                setState(() {}),
              });
    }
  }

  createDriver() {
    print({
      "first_name": _firstnameCtrl.text,
      "last_name": _lastnameCtrl.text,
      "phone_number": _phonenumberCtrl.text,
      "_licenseNumberCtrl": _licenseNumberCtrl.text,
      "picture_id": picture_id,
      "license_picture_id": license_picture_id,
      "user_id": box.read('userid'),
    });

    final Map<String, dynamic> DRIVER_DATA = {
      "first_name": _firstnameCtrl.text,
      "last_name": _lastnameCtrl.text,
      "phone_number": _phonenumberCtrl.text,
      "_licenseNumberCtrl": _licenseNumberCtrl.text,
      "picture_id": picture_id,
      "license_picture_id": license_picture_id,
      "user_id": box.read('userid'),
    };

    picture_id != null ? DRIVER_DATA["picture_id"] = picture_id : null;

    license_picture_id != null
        ? DRIVER_DATA["license_picture_id"] = license_picture_id
        : null;

    print(DRIVER_DATA);

    if (_formAddDriver.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      AuthAPI.POST_WITH_TOKEN(urlendpoint: "drivers", postData: DRIVER_DATA)
          .then((value) => {
                print(value),
                if (value["success"] == true)
                  {
                    Navigator.pop(context),
                    _firstnameCtrl.clear(),
                    _lastnameCtrl.clear(),
                    _phonenumberCtrl.clear(),
                    _licenseNumberCtrl.clear(),
                    setState(() {
                      LicenseImageName = "ADD LICENCE IMAGE";
                      LicenseImagePath = "";
                      AvatarImagePath = "assets/icons/user.png";
                      hasSelectedLicenseImage = false;
                    }),
                    GetAllDrivers(box.read("userType"))
                  }
              });
    }
  }



  // uploadAvatar(ImageFilePath) {
  //   setState(() {
  //     isUploadingAvatar = true;
  //   });
  //   print(ImageFilePath);
  //   AuthAPI.UploadSingleFiles(url: "upload/file", filePath: ImageFilePath)
  //       .then((value) => {
  //             if (value["success"] == true)
  //               {
  //                 notifyInfo(content: "Avatar Upload Succesfully"),
  //                 setState(() {
  //                   picture_id = value["result"]["file"]["id"];
  //                 }),
  //                 setState(() {
  //                   isUploadingAvatar = false;
  //                 }),
  //               }
  //             else
  //               {
  //                 notifyError(content: "Avatar not uploaded"),
  //                 setState(() {
  //                   isUploadingAvatar = false;
  //                 }),
  //               }
  //           });
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    initializeDateFormatting('en', null);

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: width * 0.42,
                    width: width * .42,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.blue[900]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("TOTAL",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: 3,
                              ),
                              Text("DRIVERS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Text(box.read('drivers').length.toString(),
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                      ],
                    )),
                InkWell(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            StatefulBuilder(builder: (context, setState) {
                              
                              uploadAvatar(ImageFilePath) {
                                setState(() {
                                  isUploadingAvatar = true;
                                });
                                print(ImageFilePath);
                                AuthAPI.UploadSingleFiles(
                                        filePath: ImageFilePath)
                                    .then((value) => {
                                          print(
                                              "VALUE FOR UPLOAD AVATAR $value"),
                                          if (value["success"] == true)
                                            {
                                              notifyInfo(
                                                  content:
                                                      "Avatar Upload Succesfully"),
                                              setState(() {
                                                picture_id = value["result"]
                                                    ["file"]["id"];
                                              }),
                                              setState(() {
                                                isUploadingAvatar = false;
                                              }),
                                            }
                                          else
                                            {
                                              notifyError(
                                                  content:
                                                      "AVATAR UPLOAD FAILED"),
                                              setState(() {
                                                isUploadingAvatar = false;
                                              }),
                                            }
                                        })
                                    .onError((error, stackTrace) => {
                                          notifyError(
                                              content: "AVATAR UPLOAD FAILED"),
                                          setState(() {
                                            isUploadingAvatar = false;
                                          }),
                                        });
                              }

                              uploadImage(ImageFilePath) {
                                setState(() {
                                  isUploadingLicense = true;
                                });
                                // print(ImageFilePath);
                                AuthAPI.UploadSingleFiles(
                                        filePath: ImageFilePath)
                                    .then((value) => {
                                          print(
                                              'VALUE FOR LICENSE UPLOAD:$value'),
                                          if (value["success"] == true)
                                            {
                                              notifyInfo(
                                                  content:
                                                      "LICENSE UPLOAD SUCCESSFUL"),
                                              setState(() {
                                                license_picture_id =
                                                    value["result"]["file"]
                                                        ["id"];
                                              }),
                                              setState(() {
                                                isUploadingLicense = false;
                                              }),
                                            }
                                          else
                                            {
                                              notifyError(
                                                  content:
                                                      "LICENSE NOT UPLOADED"),
                                              setState(() {
                                                isUploadingLicense = false;
                                              }),
                                            }
                                        })
                                    .onError((error, stackTrace) => {
                                          notifyError(
                                              content: "LICENSE NOT UPLOADED"),
                                          setState(() {
                                            isUploadingLicense = false;
                                          }),
                                        });
                              }

                              return AlertDialog(
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                title: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    isUploadingAvatar
                                        ? SizedBox(
                                            child: CircularProgressIndicator(),
                                            height: 130.0,
                                            width: 130.0,
                                          )
                                        : SizedBox(),
                                    CircleAvatar(
                                      radius: 65,
                                      child: CircleAvatar(
                                        radius: 61,
                                        backgroundColor: Colors.blue[50],
                                        foregroundImage:
                                            AssetImage(AvatarImagePath),
                                        backgroundImage: AssetImage(
                                          'assets/icons/user.png',
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles();

                                            if (result != null) {
                                              File file = File(result
                                                  .files.single.path
                                                  .toString());
                                              print("file PATH::++__+_::=>");
                                              print(file);

                                              setState(() {
                                                AvatarImagePath = result
                                                    .files.single.path
                                                    .toString();
                                              });
                                              uploadAvatar(AvatarImagePath);
                                            } else {
                                              // User canceled the picker
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                content: SizedBox(
                                  height: height * .5,
                                  child: Form(
                                    key: _formAddDriver,
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
                                          const Text("First Name",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            focusNode: _firstnameNode,
                                            controller: _firstnameCtrl,
                                            style:
                                                const TextStyle(fontSize: 17),
                                            cursorColor:
                                                const Color(0xFF3D3F92),
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              focusColor: Colors.blue.shade600,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),

                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                              ),

                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 11),
                                            ),
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) =>
                                                validateRequired(value!, "First Name"),
                                            onEditingComplete: () {
                                              // FocusScope.of(context).requestFocus(_passwordNode);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text("Last Name",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            focusNode: _lastnameNode,
                                            controller: _lastnameCtrl,
                                            style:
                                                const TextStyle(fontSize: 20),
                                            cursorColor:
                                                const Color(0xFF3D3F92),
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              focusColor: Colors.blue.shade600,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // labelText: Strings.register.pass,

                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 11),
                                            ),
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) =>
                                                validateRequired(
                                                    value!, "Last Name"),
                                            onChanged: (String value) {
                                              // user.password = value;
                                            },
                                            onEditingComplete: () {
                                              // FocusScope.of(context).requestFocus(_passwordNode);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 11,
                                          ),
                                          const Text("Phone Number",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          IntlPhoneField(
                                            focusNode: _phonenumberNode,
                                            controller: _phonenumberCtrl,
                                            style:
                                                const TextStyle(fontSize: 20),
                                            cursorColor:
                                                const Color(0xFF3D3F92),
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              focusColor: Colors.blue.shade50,
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // labelText: Strings.register.pass,
                                              // border: InputBorder.none,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 11),
                                            ),
                                            initialCountryCode: 'NG',
                                            onChanged: (phone) {
                                              // print(phone.completeNumber);
                                            },
                                            dropdownIconPosition:
                                                IconPosition.trailing,
                                            // showCountryFlag: false,
                                            flagsButtonPadding:
                                                const EdgeInsets.only(left: 15),
                                            // dropdownDecoration: BoxDecoration(),
                                            // countries: const [
                                            //   'NG',
                                            //   'GH',
                                            //   'ZA',
                                            //   'KE'
                                            // ],
                                            keyboardType: TextInputType.phone,
                                            textInputAction:
                                                TextInputAction.next,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) =>
                                                validateRequired(
                                                    value.toString(),
                                                    "Phone Number"),
                                            // validator: numberValidator,
                                            // onEditingComplete: () {
                                            // FocusScope.of(context).requestFocus(_passwordNode);
                                            // },
                                          ),
                                          const Text("License Number",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                            focusNode: _licenseNumberNode,
                                            controller: _licenseNumberCtrl,
                                            // enabled: !processing,
                                            style:
                                                const TextStyle(fontSize: 20),
                                            cursorColor:
                                                const Color(0xFF3D3F92),
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              focusColor: Colors.blue.shade50,
                                              // hintText: 'Enter your email',
                                              filled: true,
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // labelText: Strings.register.pass,
                                              // border: InputBorder.none,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 11),
                                            ),
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) =>
                                                validateRequired(
                                                    value!, "License Number"),
                                            onChanged: (String value) {
                                              // user.password = value;
                                            },
                                            onEditingComplete: () {
                                              // FocusScope.of(context).requestFocus(_passwordNode);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          
                                          InkWell(
                                            onTap: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles();

                                              if (result != null) {
                                                File file = File(result
                                                    .files.single.path
                                                    .toString());
                                                print("file PATH::++__+_::=>");
                                                print(file);
                                                print(result.files.single.name);

                                                setState(() {
                                                  isUploadingLicense = true;
                                                });

                                                setState(() {
                                                  LicenseImagePath = result
                                                      .files.single.path
                                                      .toString();
                                                });

                                                setState(() {
                                                  LicenseImageName =
                                                      result.files.single.name;
                                                });

                                                setState(() {
                                                  hasSelectedLicenseImage =
                                                      true;
                                                });
                                                uploadImage(LicenseImagePath);
                                              } else {
                                                // User canceled the picker
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                // Icon(Icons.add_a_photo_outlined, size: 35,),
                                                hasSelectedLicenseImage
                                                    ? Icon(
                                                        Icons
                                                            .library_add_check_rounded,
                                                        size: 35,
                                                        color: Colors.blue[800],
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .add_a_photo_outlined,
                                                        size: 35,
                                                      ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(LicenseImageName,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w400)),

                                                hasSelectedLicenseImage
                                                    ? TextButton(
                                                        onPressed: () {
                                                          showDialog<String>(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setState) {
                                                                    return AlertDialog(
                                                                      content: Image
                                                                          .asset(
                                                                              LicenseImagePath),
                                                                    );
                                                                  }));
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .remove_red_eye_rounded,
                                                          color:
                                                              Colors.blue[800],
                                                        ))
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                          isUploadingLicense
                                              ? LinearProgressIndicator()
                                              : SizedBox(),
                                          SizedBox(
                                            height: 20,
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
                                            createDriver();
                                          },
                                          child: Text(' S U B M I T '))
                                    ],
                                  )
                                ],
                              );
                            }));
                  },
                  child: Container(
                      height: width * 0.42,
                      width: width * .42,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.blue[900]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 50,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("ADD NEW",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: 3,
                          ),
                          Text("DRIVER",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      )),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Table(context),
          ],
        ),
      ),
    ));
  }

  Widget Table(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    initializeDateFormatting('en', null);

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        showCheckboxColumn: false,
        columnSpacing: 20,
        columns: <DataColumn>[
          DataColumn(
            label: Text('NAMES'),
          ),
          DataColumn(
            label: Text('CONTACT'),
          ),
          DataColumn(
            label: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(onTap: () {
                  
                }, child: Icon(Icons.chevron_left_outlined),),
                SizedBox(width: 15, child: Text(' 1'),),
                InkWell(onTap: () {
                  
                },child: Icon(Icons.chevron_right_outlined),),
                ],
                ),
          ),
        ],
        rows: List<DataRow>.generate(
          box.read('drivers').length > 15 ? 15 : box.read('drivers').length,
          (int index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.grey.withOpacity(0.3);
              }
              return null; // Use default value for other states and odd rows.
            }),
            cells: <DataCell>[
              DataCell(Text(
                  '${box.read('drivers')[index]['first_name']} ${box.read('drivers')[index]['last_name']}')),
              DataCell(Text('${box.read('drivers')[index]['phone_number']}')),
              DataCell(TextButton(
                onPressed: () {
                  showDriverDetails(box.read('drivers')[index]);

                  // showDialog<String>(
                  //   context: context,
                  //   builder: (BuildContext context) => AlertDialog(
                  //     insetPadding:
                  //         EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius.all(Radius.circular(15.0))),
                  //     title: CircleAvatar(
                  //       radius: 45,
                  //       child: CircleAvatar(
                  //         radius: 42,
                  //         backgroundColor: Colors.blue[50],
                  //         foregroundImage: NetworkImage(
                  //             "${box.read('drivers')[index]['picture']["url"] ?? ''}"),
                  //         // backgroundImage: NetworkImage(
                  //         //     box.read('drivers')[index]['picture_id'] ?? ''),
                  //         child:
                  //             box.read('drivers')[index]['picture_id'] != null
                  //                 ? Text('')
                  //                 : Text(
                  //                     box
                  //                             .read('drivers')[index]
                  //                                 ['first_name'][0]
                  //                             .toString() +
                  //                         box
                  //                             .read('drivers')[index]
                  //                                 ['last_name'][0]
                  //                             .toString(),
                  //                     style: TextStyle(
                  //                         fontSize: 30,
                  //                         color: Colors.blue[900],
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //       ),
                  //     ),
                  //     content: SizedBox(
                  //       height: height * .7,
                  //       child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   '${box.read('drivers')[index]['first_name']} ${box.read('drivers')[index]['last_name']}',
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(
                  //                       color: Colors.black,
                  //                       fontWeight: FontWeight.w700),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 15,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text('Phone Number',
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleSmall!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w300,
                  //                         )),
                  //                 Text('License Number',
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleSmall!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w300,
                  //                         )),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 5,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(
                  //                     "${box.read('drivers')[index]['phone_number']}",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleMedium!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w600,
                  //                         )),
                  //                 Text(
                  //                     "${box.read('drivers')[index]['license_number']}",
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleMedium!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w600,
                  //                         )),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 15,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text('Date Added',
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleSmall!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w300,
                  //                         )),
                  //                 Text('On a Trip',
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleSmall!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w300,
                  //                         )),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 5,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(
                  //                     Jiffy(box.read('drivers')[index]
                  //                             ['created_at'])
                  //                         .format('do MMM yyyy'),
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleMedium!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w600,
                  //                         )),
                  //                 Text(
                  //                     '${box.read('drivers')[index]['on_trip'] == 0 ? "False" : "Yes"}',
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .titleMedium!
                  //                         .copyWith(
                  //                           fontWeight: FontWeight.w600,
                  //                         )),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 15,
                  //             ),
                  //             box.read('drivers')[index]['picture_id'] == null
                  //                 ? Container(
                  //                     height: 250.0,
                  //                     width: width * .8,
                  //                     child: SvgPicture.network(
                  //                       'https://www.svgrepo.com/show/477704/license-1.svg',
                  //                       color: Colors.blue[600],
                  //                     ),
                  //                   )
                  //                 : Container(
                  //                     height: 150.0,
                  //                     width: width * .8,
                  //                     decoration: BoxDecoration(
                  //                       image: DecorationImage(
                  //                           fit: BoxFit.cover,
                  //                           image: NetworkImage(
                  //                               "${box.read('drivers')[index]['picture_id']}")),
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(8.0)),
                  //                     ),
                  //                   ),
                  //           ]),
                  //     ),
                  //   ),
                  // );
                },
                child: Text(
                  "view",
                  style: TextStyle(color: Colors.blue[900]),
                ),
              )),
            ],
            // selected: selected[index],
            // onSelectChanged: (bool? value) {
            //   setState(() {
            //     selected[index] = value!;
            //   });
            // },
          ),
        ),
      ),
    );
  }

}
