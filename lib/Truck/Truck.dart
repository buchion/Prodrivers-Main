import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/notification.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:prodrivers/components/utils.dart';

class Truck extends StatefulWidget {
  static const String routeName = '/truck';

  const Truck({super.key});

  @override
  _TruckState createState() => _TruckState();
}

bool isUploading_TruckLicense = false;
bool isUploading_OwnershipProof = false;
bool isUploading_Insurance = false;
bool isUploading_Pictures = false;
bool isUploading_RoadWorthiness = false;

bool hasSelected_TruckLicense = false;
bool hasSelected_OwnershipProof = false;
bool hasSelected_Insurance = false;
bool hasSelected_Pictures = false;
bool hasSelected_RoadWorthiness = false;

String TruckLicense = 'UPLOAD TRUCK LICENSE';
String OwnershipProof = 'UPLOAD PROOF OF OWNERSHIP';
String Insurance = 'UPLOAD TRUCK INSURANCE';
String Pictures = 'UPLOAD TRUCK PICTURES';
String RoadWorthiness = 'UPLOAD ROAD WORTHINESS';

String TruckLicensePATH = '';
String OwnershipProofPATH = '';
String InsurancePATH = '';
String PicturesPATH = '';
String RoadWorthinessPATH = '';

dynamic image_TruckLicense_id = null;
dynamic image_OwnershipProof_id = null;
dynamic image_Insurance_id = null;
dynamic image_Pictures_id = null;
dynamic image_RoadWorthiness_id = null;

int driver_id = 0;
int tonnage_id = 0;
int trucktype_id = 0;

class _TruckState extends State<Truck> with RouteAware {
  // static const int numItems = 10;
  // List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  final box = GetStorage();

  final _makerNode = FocusNode();
  final _makerCtrl = TextEditingController();

  final _modelNode = FocusNode();
  final _modelCtrl = TextEditingController();

  // final searchFocusNode = FocusNode();
  final searchDRIVERFocusNode = FocusNode();

  final searchTONFocusNode = FocusNode();
  final searchTruckFocusNode = FocusNode();

  final _tonnageNode = FocusNode();
  final _tonnageCtrl = TextEditingController();

  final _truckTypeNode = FocusNode();
  final _truckTypeCtrl = TextEditingController();

  final _chassisNumberNode = FocusNode();
  final _chassisNumberCtrl = TextEditingController();

  final _plateNumberNode = FocusNode();
  final _plateNumberCtrl = TextEditingController();

  final _driverNode = FocusNode();
  final _driverCtrl = TextEditingController();

  static final _formAddTruck = GlobalKey<FormState>();

  @override
  void dispose() {
    _makerNode.dispose();
    _makerCtrl.dispose();

    _modelNode.dispose();
    _modelCtrl.dispose();

    _tonnageNode.dispose();
    _tonnageCtrl.dispose();

    _chassisNumberNode.dispose();
    _chassisNumberCtrl.dispose();

    _plateNumberNode.dispose();
    _plateNumberCtrl.dispose();

    _truckTypeNode.dispose();
    _truckTypeCtrl.dispose();

    _driverNode.dispose();
    _driverCtrl.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    print(box.read("userType"));
  }

  GetAllTrucks() {
    if (box.read("userType") == "transporter") {
      AuthAPI.GET_WITH_TOKEN(
              urlendpoint: "transporters/${box.read('userid')}/trucks")
          .then((res) =>
              {box.write("trucks", res["result"]["trucks"]), setState(() {})});
    }

    if (box.read("userType") == "admin") {
      AuthAPI.GET_WITH_TOKEN(urlendpoint: "trucks").then((res) => {
            // print(res),
            // print(res["result"]["drivers"]),
            box.write("drivers", res["result"]["truck"]),
          });
    }
  }

  clearFields() {
    setState(() {
      _chassisNumberCtrl.clear();
      _modelCtrl.clear();
      _makerCtrl.clear();
      _plateNumberCtrl.clear();

      hasSelected_Insurance = false;
      hasSelected_TruckLicense = false;
      hasSelected_OwnershipProof = false;
      hasSelected_Insurance = false;
      hasSelected_Pictures = false;
      hasSelected_RoadWorthiness = false;

      TruckLicense = 'UPLOAD TRUCK LICENSE';
      OwnershipProof = 'UPLOAD PROOF OF OWNERSHIP';
      Insurance = 'UPLOAD TRUCK INSURANCE';
      Pictures = 'UPLOAD TRUCK PICTURES';
      RoadWorthiness = 'UPLOAD ROAD WORTHINESS';

      TruckLicensePATH = '';
      OwnershipProofPATH = '';
      InsurancePATH = '';
      PicturesPATH = '';
      RoadWorthinessPATH = '';

      image_TruckLicense_id = null;
      image_OwnershipProof_id = null;
      image_Insurance_id = null;
      image_Pictures_id = null;
      image_RoadWorthiness_id = null;
    });
  }

  showTruckDetails(truckDetail) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              uploadImage(ImageFilePath, RESOURCE_NAME) {
                print(ImageFilePath);
                AuthAPI.UploadSingleFiles(filePath: ImageFilePath)
                    .then((value) => {
                          print('VALUE FOR UPLOAD:$value'),
                          if (RESOURCE_NAME == TruckLicense)
                            {
                              if (value["success"] == true)
                                {
                                  notifyInfo(
                                      content:
                                          "TRUCK LICENSE UPLOAD SUCCESSFUL"),
                                  setState(() {
                                    image_TruckLicense_id =
                                        value["result"]["file"]["id"];
                                    isUploading_TruckLicense = false;
                                  }),
                                }
                              else
                                {
                                  notifyError(
                                      content: "TRUCK LICENSE NOT UPLOADED."),
                                  setState(() {
                                    isUploading_TruckLicense = false;
                                  }),
                                }
                            },
                          if (RESOURCE_NAME == OwnershipProof)
                            {
                              if (value["success"] == true)
                                {
                                  notifyInfo(
                                      content:
                                          "PROOF OF OWNERSHIP UPLOAD SUCCESSFUL"),
                                  setState(() {
                                    image_OwnershipProof_id =
                                        value["result"]["file"]["id"];
                                    isUploading_OwnershipProof = false;
                                  }),
                                }
                              else
                                {
                                  notifyError(
                                      content:
                                          "PROOF OF OWNERSHIP NOT UPLOADED."),
                                  setState(() {
                                    isUploading_OwnershipProof = false;
                                  }),
                                }
                            },
                          if (RESOURCE_NAME == Insurance)
                            {
                              if (value["success"] == true)
                                {
                                  notifyInfo(
                                      content: "INSURANCE UPLOAD SUCCESSFUL"),
                                  setState(() {
                                    image_Insurance_id =
                                        value["result"]["file"]["id"];
                                    isUploading_Insurance = false;
                                  }),
                                }
                              else
                                {
                                  notifyError(
                                      content: "INSURANCE NOT UPLOADED."),
                                  setState(() {
                                    isUploading_Insurance = false;
                                  }),
                                }
                            },
                          if (RESOURCE_NAME == Pictures)
                            {
                              if (value["success"] == true)
                                {
                                  notifyInfo(
                                      content:
                                          "TRUCK PICTURES UPLOAD SUCCESSFUL"),
                                  setState(() {
                                    image_Pictures_id =
                                        value["result"]["file"]["id"];
                                    isUploading_Pictures = false;
                                  }),
                                }
                              else
                                {
                                  notifyError(
                                      content: "TRUCK PICTURES NOT UPLOADED."),
                                  setState(() {
                                    isUploading_Pictures = false;
                                  }),
                                }
                            },
                          if (RESOURCE_NAME == RoadWorthiness)
                            {
                              if (value["success"] == true)
                                {
                                  notifyInfo(
                                      content:
                                          "ROAD WORTHINESS UPLOAD SUCCESSFUL"),
                                  setState(() {
                                    image_RoadWorthiness_id =
                                        value["result"]["file"]["id"];
                                    isUploading_RoadWorthiness = false;
                                  }),
                                }
                              else
                                {
                                  notifyError(
                                      content: "ROAD WORTHINESS NOT UPLOADED."),
                                  setState(() {
                                    isUploading_RoadWorthiness = false;
                                  }),
                                }
                            },
                        })
                    .onError((error, stackTrace) => {
                          print(error),
                          notifyError(content: "DOCUMENT NOT UPLOADED"),
                          // setState(() {
                          //   isUploading_TruckLicense = false;
                          // }),
                        });
              }

              uploadFileFunc(DOC_NAME) async {
                if (DOC_NAME == TruckLicense) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    // File file = File(result.files.single.path.toString());
                    print(
                        "...DOC_NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                    setState(() {
                      isUploading_TruckLicense = true;
                      hasSelected_TruckLicense = true;
                      TruckLicense = result.files.single.name;
                      TruckLicensePATH = result.files.single.path.toString();
                    });

                    uploadImage(TruckLicensePATH, TruckLicense);
                  }
                }

                if (DOC_NAME == OwnershipProof) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    // File file = File(result.files.single.path.toString());
                    print(
                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                    setState(() {
                      isUploading_OwnershipProof = true;
                      hasSelected_OwnershipProof = true;
                      OwnershipProof = result.files.single.name;
                      OwnershipProofPATH = result.files.single.path.toString();
                    });

                    uploadImage(OwnershipProofPATH, OwnershipProof);
                  }
                }

                if (DOC_NAME == Insurance) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    // File file = File(result.files.single.path.toString());
                    print(
                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                    setState(() {
                      isUploading_Insurance = true;
                      hasSelected_Insurance = true;
                      Insurance = result.files.single.name;
                      InsurancePATH = result.files.single.path.toString();
                    });

                    uploadImage(InsurancePATH, Insurance);
                  }
                }

                if (DOC_NAME == Pictures) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    // File file = File(result.files.single.path.toString());
                    print(
                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                    setState(() {
                      isUploading_Pictures = true;
                      hasSelected_Pictures = true;
                      Pictures = result.files.single.name;
                      PicturesPATH = result.files.single.path.toString();
                    });

                    uploadImage(PicturesPATH, Pictures);
                  }
                }

                if (DOC_NAME == RoadWorthiness) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    // File file = File(result.files.single.path.toString());
                    print(
                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                    setState(() {
                      isUploading_RoadWorthiness = true;
                      hasSelected_RoadWorthiness = true;
                      RoadWorthiness = result.files.single.name;
                      RoadWorthinessPATH = result.files.single.path.toString();
                    });

                    uploadImage(RoadWorthinessPATH, RoadWorthiness);
                  }
                }
              }

              return AlertDialog(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                content: SizedBox(
                  height: height * .8,
                  child: Form(
                    // key: _formAddTruck,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 2,
                            width: width * .8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Maker",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: width * .39,
                                    child: TextFormField(
                                      focusNode: _makerNode,
                                      controller: _makerCtrl,
                                      style: const TextStyle(fontSize: 20),
                                      cursorColor: const Color(0xFF3D3F92),
                                      validator: (value) => validateRequired(
                                          value!, "Maker/Brand Name"),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        focusColor: Colors.blue.shade50,
                                        filled: true,
                                        hintText: truckDetail["maker"],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
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
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Model",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: width * .39,
                                    child: TextFormField(
                                      focusNode: _modelNode,
                                      controller: _modelCtrl,
                                      validator: (value) =>
                                          validateRequired(value!, "Model"),
                                      style: const TextStyle(fontSize: 20),
                                      cursorColor: const Color(0xFF3D3F92),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        focusColor: Colors.blue.shade600,
                                        hintText: truckDetail["model"],
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
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
                                                horizontal: 15, vertical: 11),
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Tonnage",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: width * .39,
                                    child: DropDownTextField(
                                      clearOption: false,
                                      validator: (value) =>
                                          validateRequired(value!, "Tonnage"),
                                      textFieldFocusNode: _tonnageNode,
                                      searchFocusNode: searchTONFocusNode,
                                      // searchAutofocus: true,
                                      textFieldDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        focusColor: Colors.blue.shade50,
                                        hintText: truckDetail["tonnage"]["name"]
                                            .toString(),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
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
                                                horizontal: 15, vertical: 11),
                                      ),
                                      dropDownItemCount: 5,
                                      searchShowCursor: false,
                                      enableSearch: true,
                                      searchKeyboardType: TextInputType.number,
                                      dropDownList:
                                          // box.read('tonnages'),
                                          [
                                        for (var tons in box.read('tonnages'))
                                          DropDownValueModel(
                                              name: tons["name"],
                                              value: tons["id"]),
                                      ],
                                      onChanged: (val) {
                                        print(val.value);

                                        setState(() {
                                          tonnage_id = val.value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Truck Type",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: width * .39,
                                    child: DropDownTextField(
                                      clearOption: false,
                                      validator: (value) => validateRequired(
                                          value!, "Truck Type"),
                                      textFieldFocusNode: _truckTypeNode,
                                      searchFocusNode: searchTruckFocusNode,
                                      // searchAutofocus: true,
                                      textFieldDecoration: InputDecoration(
                                        fillColor: Colors.white,
                                        focusColor: Colors.blue.shade50,
                                        hintText: truckDetail["truck_type"]
                                            ["name"],
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
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
                                                horizontal: 15, vertical: 11),
                                      ),
                                      dropDownItemCount: 6,
                                      searchShowCursor: false,
                                      enableSearch: true,
                                      searchKeyboardType: TextInputType.number,
                                      dropDownList:
                                          // box.read('tonnages'),
                                          [
                                        for (var truck
                                            in box.read('truck_types'))
                                          DropDownValueModel(
                                              name: truck["name"]
                                                  .toString()
                                                  .toUpperCase(),
                                              value: truck["id"]),
                                      ],
                                      onChanged: (val) {
                                        print(val.value);

                                        setState(() {
                                          trucktype_id = int.parse(val.value);
                                        });
                                      },
                                    ),
                                  ),
                                
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Chassis number",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: width * .39,
                                    child: TextFormField(
                                      focusNode: _chassisNumberNode,
                                      controller: _chassisNumberCtrl,
                                      validator: (value) => validateRequired(
                                          value!, "Chassis Number"),
                                      style: const TextStyle(fontSize: 17),
                                      cursorColor: const Color(0xFF3D3F92),

                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        focusColor: Colors.blue.shade600,
                                        filled: true,
                                        hintText: truckDetail["chassis_number"],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
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
                                                horizontal: 15, vertical: 11),
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
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Plate Number",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: width * .39,
                                    child: TextFormField(
                                      focusNode: _plateNumberNode,
                                      controller: _plateNumberCtrl,
                                      validator: (value) => validateRequired(
                                          value!, "Plate Number"),
                                      style: const TextStyle(fontSize: 20),
                                      cursorColor: const Color(0xFF3D3F92),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        focusColor: Colors.blue.shade600,
                                        filled: true,
                                        hintText: truckDetail["plate_number"],
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
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
                                                horizontal: 15, vertical: 11),
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 11,
                          ),
                          const Text("Driver",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: width * .8,
                            child: DropDownTextField(
                              clearOption: false,
                              textFieldFocusNode: _driverNode,
                              validator: (value) =>
                                  validateRequired(value!, "Driver"),
                              searchFocusNode: searchDRIVERFocusNode,
                              textFieldDecoration: InputDecoration(
                                fillColor: Colors.white,
                                focusColor: Colors.blue.shade50,
                                filled: true,
                                hintText: '${truckDetail["driver"]["first_name"]} ${truckDetail["driver"]["last_name"]}',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 11),
                              ),
                              dropDownItemCount: 5,
                              searchShowCursor: false,
                              enableSearch: true,
                              searchKeyboardType: TextInputType.name,
                              dropDownList: [
                                for (var driver in box.read('drivers'))
                                  DropDownValueModel(
                                    name:
                                        '${driver["first_name"]} ${driver["last_name"]}',
                                    value: driver["id"],
                                    // toolTipMsg: driver["phone_number"].toString(),
                                  ),
                              ],
                              onChanged: (val) {
                                print(val.value);
                                print(int.parse(val.value));

                                setState(() {
                                  driver_id = int.parse(val.value);
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              uploadFileFunc(TruckLicense);
                            },
                            child: Row(
                              children: [
                                hasSelected_TruckLicense
                                    ? Icon(
                                        Icons.library_add_check_rounded,
                                        size: 35,
                                        color: Colors.blue[800],
                                      )
                                    : Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 35,
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(TruckLicense.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700)),
                                hasSelected_TruckLicense
                                    ? TextButton(
                                        onPressed: () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return AlertDialog(
                                                      content: Image.asset(
                                                          TruckLicensePATH
                                                              .toString()),
                                                    );
                                                  }));
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: Colors.blue[800],
                                        ))
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          isUploading_TruckLicense
                              ? LinearProgressIndicator()
                              : SizedBox(
                                  height: 10,
                                ),
                          InkWell(
                            onTap: () {
                              uploadFileFunc(OwnershipProof);
                            },
                            child: Row(
                              children: [
                                hasSelected_OwnershipProof
                                    ? Icon(
                                        Icons.library_add_check_rounded,
                                        size: 35,
                                        color: Colors.blue[800],
                                      )
                                    : Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 35,
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(OwnershipProof.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700)),
                                hasSelected_OwnershipProof
                                    ? TextButton(
                                        onPressed: () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return AlertDialog(
                                                      content: Image.asset(
                                                          OwnershipProofPATH
                                                              .toString()),
                                                    );
                                                  }));
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: Colors.blue[800],
                                        ))
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          isUploading_OwnershipProof
                              ? LinearProgressIndicator()
                              : SizedBox(
                                  height: 10,
                                ),
                          InkWell(
                            onTap: () {
                              uploadFileFunc(Insurance);
                            },
                            child: Row(
                              children: [
                                hasSelected_Insurance
                                    ? Icon(
                                        Icons.library_add_check_rounded,
                                        size: 35,
                                        color: Colors.blue[800],
                                      )
                                    : Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 35,
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(Insurance.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700)),
                                hasSelected_Insurance
                                    ? TextButton(
                                        onPressed: () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return AlertDialog(
                                                      content: Image.asset(
                                                          Insurance.toString()),
                                                    );
                                                  }));
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: Colors.blue[800],
                                        ))
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          isUploading_Insurance
                              ? LinearProgressIndicator()
                              : SizedBox(
                                  height: 10,
                                ),
                          InkWell(
                            onTap: () {
                              uploadFileFunc(Pictures);
                            },
                            child: Row(
                              children: [
                                hasSelected_Pictures
                                    ? Icon(
                                        Icons.library_add_check_rounded,
                                        size: 35,
                                        color: Colors.blue[800],
                                      )
                                    : Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 35,
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(Pictures.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700)),
                                hasSelected_Pictures
                                    ? TextButton(
                                        onPressed: () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return AlertDialog(
                                                      content: Image.asset(
                                                          Pictures.toString()),
                                                    );
                                                  }));
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: Colors.blue[800],
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
                          InkWell(
                            onTap: () {
                              uploadFileFunc(RoadWorthiness);
                            },
                            child: Row(
                              children: [
                                hasSelected_RoadWorthiness
                                    ? Icon(
                                        Icons.library_add_check_rounded,
                                        size: 35,
                                        color: Colors.blue[800],
                                      )
                                    : Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 35,
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(RoadWorthiness.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700)),
                                hasSelected_RoadWorthiness
                                    ? TextButton(
                                        onPressed: () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return AlertDialog(
                                                      content: Image.asset(
                                                          RoadWorthiness
                                                              .toString()),
                                                    );
                                                  }));
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: Colors.blue[800],
                                        ))
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          isUploading_RoadWorthiness
                              ? LinearProgressIndicator()
                              : SizedBox(
                                  height: 10,
                                ),
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
                          onPressed: () {
                            createTruck();
                          },
                          child: Text('  U P D A T E  '))
                    ],
                  )
                ],
              );
            }));
  }

  createTruck() {
    print({
      "chassis_number": _chassisNumberCtrl.text,
      "model": _modelCtrl.text,
      "maker": _makerCtrl.text,
      "plate_number": _plateNumberCtrl.text,
      "truck_owner_id": box.read('userid'),
      "truck_type_id": trucktype_id,
      "tonnage_id": tonnage_id,
      "driver_id": driver_id,
    });

    final Map<String, dynamic> TRUCK_DATA = {
      "chassis_number": _chassisNumberCtrl.text,
      "model": _modelCtrl.text,
      "maker": _makerCtrl.text,
      "plate_number": _plateNumberCtrl.text,
      "truck_owner_id": box.read('userid'),
      "truck_type_id": trucktype_id,
      "tonnage_id": tonnage_id,
      "driver_id": driver_id,
    };

    image_TruckLicense_id != null
        ? TRUCK_DATA["license_id"] = image_TruckLicense_id
        : null;
    image_OwnershipProof_id != null
        ? TRUCK_DATA["proof_of_ownership_id"] = image_OwnershipProof_id
        : null;
    image_Insurance_id != null
        ? TRUCK_DATA["insurance_id"] = image_Insurance_id
        : null;
    image_Pictures_id != null
        ? TRUCK_DATA["picture_id"] = image_Pictures_id
        : null;
    image_RoadWorthiness_id != null
        ? TRUCK_DATA["road_worthiness_id"] = image_RoadWorthiness_id
        : null;

    print(TRUCK_DATA);

    if (_formAddTruck.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      AuthAPI.POST_WITH_TOKEN(urlendpoint: "trucks", postData: TRUCK_DATA)
          .then((value) => {
                print(value),
                if (value["success"] == true)
                  {
                    Navigator.pop(context),
                    clearFields(),
                    GetAllTrucks(),
                  },
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    // height: height * 0.185,
                    width: width * .42,
                    height: width * .42,
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
                        SizedBox(
                          child: AutoSizeText('TOTAL TRUCKS',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                          width: width * .4,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(box.read('trucks').length.toString(),
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
                              uploadImage(ImageFilePath, RESOURCE_NAME) {
                                print(ImageFilePath);
                                AuthAPI.UploadSingleFiles(
                                        filePath: ImageFilePath)
                                    .then((value) => {
                                          print('VALUE FOR UPLOAD:$value'),
                                          if (RESOURCE_NAME == TruckLicense)
                                            {
                                              if (value["success"] == true)
                                                {
                                                  notifyInfo(
                                                      content:
                                                          "TRUCK LICENSE UPLOAD SUCCESSFUL"),
                                                  setState(() {
                                                    image_TruckLicense_id =
                                                        value["result"]["file"]
                                                            ["id"];
                                                    isUploading_TruckLicense =
                                                        false;
                                                  }),
                                                }
                                              else
                                                {
                                                  notifyError(
                                                      content:
                                                          "TRUCK LICENSE NOT UPLOADED."),
                                                  setState(() {
                                                    isUploading_TruckLicense =
                                                        false;
                                                  }),
                                                }
                                            },
                                          if (RESOURCE_NAME == OwnershipProof)
                                            {
                                              if (value["success"] == true)
                                                {
                                                  notifyInfo(
                                                      content:
                                                          "PROOF OF OWNERSHIP UPLOAD SUCCESSFUL"),
                                                  setState(() {
                                                    image_OwnershipProof_id =
                                                        value["result"]["file"]
                                                            ["id"];
                                                    isUploading_OwnershipProof =
                                                        false;
                                                  }),
                                                }
                                              else
                                                {
                                                  notifyError(
                                                      content:
                                                          "PROOF OF OWNERSHIP NOT UPLOADED."),
                                                  setState(() {
                                                    isUploading_OwnershipProof =
                                                        false;
                                                  }),
                                                }
                                            },
                                          if (RESOURCE_NAME == Insurance)
                                            {
                                              if (value["success"] == true)
                                                {
                                                  notifyInfo(
                                                      content:
                                                          "INSURANCE UPLOAD SUCCESSFUL"),
                                                  setState(() {
                                                    image_Insurance_id =
                                                        value["result"]["file"]
                                                            ["id"];
                                                    isUploading_Insurance =
                                                        false;
                                                  }),
                                                }
                                              else
                                                {
                                                  notifyError(
                                                      content:
                                                          "INSURANCE NOT UPLOADED."),
                                                  setState(() {
                                                    isUploading_Insurance =
                                                        false;
                                                  }),
                                                }
                                            },
                                          if (RESOURCE_NAME == Pictures)
                                            {
                                              if (value["success"] == true)
                                                {
                                                  notifyInfo(
                                                      content:
                                                          "TRUCK PICTURES UPLOAD SUCCESSFUL"),
                                                  setState(() {
                                                    image_Pictures_id =
                                                        value["result"]["file"]
                                                            ["id"];
                                                    isUploading_Pictures =
                                                        false;
                                                  }),
                                                }
                                              else
                                                {
                                                  notifyError(
                                                      content:
                                                          "TRUCK PICTURES NOT UPLOADED."),
                                                  setState(() {
                                                    isUploading_Pictures =
                                                        false;
                                                  }),
                                                }
                                            },
                                          if (RESOURCE_NAME == RoadWorthiness)
                                            {
                                              if (value["success"] == true)
                                                {
                                                  notifyInfo(
                                                      content:
                                                          "ROAD WORTHINESS UPLOAD SUCCESSFUL"),
                                                  setState(() {
                                                    image_RoadWorthiness_id =
                                                        value["result"]["file"]
                                                            ["id"];
                                                    isUploading_RoadWorthiness =
                                                        false;
                                                  }),
                                                }
                                              else
                                                {
                                                  notifyError(
                                                      content:
                                                          "ROAD WORTHINESS NOT UPLOADED."),
                                                  setState(() {
                                                    isUploading_RoadWorthiness =
                                                        false;
                                                  }),
                                                }
                                            },
                                        })
                                    .onError((error, stackTrace) => {
                                          print(error),
                                          notifyError(
                                              content: "DOCUMENT NOT UPLOADED"),
                                          // setState(() {
                                          //   isUploading_TruckLicense = false;
                                          // }),
                                        });
                              }

                              uploadFileFunc(DOC_NAME) async {
                                if (DOC_NAME == TruckLicense) {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    // File file = File(result.files.single.path.toString());
                                    print(
                                        "...DOC_NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                                    setState(() {
                                      isUploading_TruckLicense = true;
                                      hasSelected_TruckLicense = true;
                                      TruckLicense = result.files.single.name;
                                      TruckLicensePATH =
                                          result.files.single.path.toString();
                                    });

                                    uploadImage(TruckLicensePATH, TruckLicense);
                                  }
                                }

                                if (DOC_NAME == OwnershipProof) {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    // File file = File(result.files.single.path.toString());
                                    print(
                                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                                    setState(() {
                                      isUploading_OwnershipProof = true;
                                      hasSelected_OwnershipProof = true;
                                      OwnershipProof = result.files.single.name;
                                      OwnershipProofPATH =
                                          result.files.single.path.toString();
                                    });

                                    uploadImage(
                                        OwnershipProofPATH, OwnershipProof);
                                  }
                                }

                                if (DOC_NAME == Insurance) {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    // File file = File(result.files.single.path.toString());
                                    print(
                                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                                    setState(() {
                                      isUploading_Insurance = true;
                                      hasSelected_Insurance = true;
                                      Insurance = result.files.single.name;
                                      InsurancePATH =
                                          result.files.single.path.toString();
                                    });

                                    uploadImage(InsurancePATH, Insurance);
                                  }
                                }

                                if (DOC_NAME == Pictures) {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    // File file = File(result.files.single.path.toString());
                                    print(
                                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                                    setState(() {
                                      isUploading_Pictures = true;
                                      hasSelected_Pictures = true;
                                      Pictures = result.files.single.name;
                                      PicturesPATH =
                                          result.files.single.path.toString();
                                    });

                                    uploadImage(PicturesPATH, Pictures);
                                  }
                                }

                                if (DOC_NAME == RoadWorthiness) {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    // File file = File(result.files.single.path.toString());
                                    print(
                                        "...DOC...NAME...> $DOC_NAME , ${result.files.single.path.toString()}");

                                    setState(() {
                                      isUploading_RoadWorthiness = true;
                                      hasSelected_RoadWorthiness = true;
                                      RoadWorthiness = result.files.single.name;
                                      RoadWorthinessPATH =
                                          result.files.single.path.toString();
                                    });

                                    uploadImage(
                                        RoadWorthinessPATH, RoadWorthiness);
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
                                    key: _formAddTruck,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Maker",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    width: width * .39,
                                                    child: TextFormField(
                                                      focusNode: _makerNode,
                                                      controller: _makerCtrl,
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                      cursorColor: const Color(
                                                          0xFF3D3F92),
                                                      validator: (value) =>
                                                          validateRequired(
                                                              value!,
                                                              "Maker/Brand Name"),
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        focusColor:
                                                            Colors.blue.shade50,
                                                        filled: true,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 11),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      // validator: (value) => validateEmail(value!),
                                                      onChanged:
                                                          (String value) {
                                                        // user.password = value;
                                                      },
                                                      onEditingComplete: () {
                                                        // FocusScope.of(context).requestFocus(_passwordNode);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Model",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    width: width * .39,
                                                    child: TextFormField(
                                                      focusNode: _modelNode,
                                                      controller: _modelCtrl,
                                                      validator: (value) =>
                                                          validateRequired(
                                                              value!, "Model"),
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                      cursorColor: const Color(
                                                          0xFF3D3F92),
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        focusColor: Colors
                                                            .blue.shade600,
                                                        filled: true,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2.0),
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
                                                                  .circular(5),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 11),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      // validator: validatePassword as String Function(String),
                                                      onChanged:
                                                          (String value) {
                                                        // user.password = value;
                                                      },
                                                      onEditingComplete: () {
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Tonnage",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    width: width * .39,
                                                    child: DropDownTextField(
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
                                                        fillColor: Colors.white,
                                                        focusColor:
                                                            Colors.blue.shade50,
                                                        // hintText: 'Enter your email',
                                                        filled: true,

                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
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
                                                          TextInputType.number,
                                                      dropDownList:
                                                          // box.read('tonnages'),
                                                          [
                                                        for (var tons in box
                                                            .read('tonnages'))
                                                          DropDownValueModel(
                                                              name:
                                                                  tons["name"],
                                                              value:
                                                                  tons["id"]),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Truck Type",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    width: width * .39,
                                                    child: DropDownTextField(
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
                                                        fillColor: Colors.white,
                                                        focusColor:
                                                            Colors.blue.shade50,
                                                        // hintText: 'Enter your email',
                                                        filled: true,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 11),
                                                      ),
                                                      dropDownItemCount: 6,
                                                      searchShowCursor: false,
                                                      enableSearch: true,
                                                      searchKeyboardType:
                                                          TextInputType.number,
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
                                                              value:
                                                                  truck["id"]),
                                                      ],
                                                      onChanged: (val) {
                                                        print(val
                                                            .value.runtimeType);

                                                        setState(() {
                                                          trucktype_id =
                                                              val.value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Chassis number",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    width: width * .39,
                                                    child: TextFormField(
                                                      focusNode:
                                                          _chassisNumberNode,
                                                      controller:
                                                          _chassisNumberCtrl,
                                                      validator: (value) =>
                                                          validateRequired(
                                                              value!,
                                                              "Chassis Number"),
                                                      style: const TextStyle(
                                                          fontSize: 17),
                                                      cursorColor: const Color(
                                                          0xFF3D3F92),
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        focusColor: Colors
                                                            .blue.shade600,
                                                        filled: true,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2.0),
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
                                                                  .circular(5),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 11),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      // validator: validatePassword as String Function(String),
                                                      onChanged:
                                                          (String value) {
                                                        // user.password = value;
                                                      },
                                                      onEditingComplete: () {
                                                        // FocusScope.of(context).requestFocus(_passwordNode);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Plate Number",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black45,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  SizedBox(
                                                    width: width * .39,
                                                    child: TextFormField(
                                                      focusNode:
                                                          _plateNumberNode,
                                                      controller:
                                                          _plateNumberCtrl,
                                                      validator: (value) =>
                                                          validateRequired(
                                                              value!,
                                                              "Plate Number"),
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                      cursorColor: const Color(
                                                          0xFF3D3F92),
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: Colors.white,
                                                        focusColor: Colors
                                                            .blue.shade600,
                                                        filled: true,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2.0),
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
                                                                  .circular(5),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 11),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      // validator: validatePassword as String Function(String),
                                                      onChanged:
                                                          (String value) {
                                                        // user.password = value;
                                                      },
                                                      onEditingComplete: () {
                                                        // FocusScope.of(context).requestFocus(_passwordNode);
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
                                          const Text("Driver",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            width: width * .8,
                                            child: DropDownTextField(
                                              clearOption: false,
                                              textFieldFocusNode: _driverNode,
                                              validator: (value) =>
                                                  validateRequired(
                                                      value!, "Driver"),
                                              searchFocusNode:
                                                  searchDRIVERFocusNode,
                                              textFieldDecoration:
                                                  InputDecoration(
                                                fillColor: Colors.white,
                                                focusColor: Colors.blue.shade50,
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
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
                                              dropDownItemCount: 5,
                                              searchShowCursor: false,
                                              enableSearch: true,
                                              searchKeyboardType:
                                                  TextInputType.name,
                                              dropDownList: [
                                                for (var driver
                                                    in box.read('drivers'))
                                                  DropDownValueModel(
                                                    name:
                                                        '${driver["first_name"]} ${driver["last_name"]}',
                                                    value: driver["id"],
                                                    // toolTipMsg: driver["phone_number"].toString(),
                                                  ),
                                              ],
                                              onChanged: (val) {
                                                print(val.value);

                                                setState(() {
                                                  driver_id = val.value;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              uploadFileFunc(TruckLicense);
                                            },
                                            child: Row(
                                              children: [
                                                hasSelected_TruckLicense
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
                                                Text(TruckLicense.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                hasSelected_TruckLicense
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
                                                                              TruckLicensePATH.toString()),
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
                                          isUploading_TruckLicense
                                              ? LinearProgressIndicator()
                                              : SizedBox(
                                                  height: 10,
                                                ),
                                          InkWell(
                                            onTap: () {
                                              uploadFileFunc(OwnershipProof);
                                            },
                                            child: Row(
                                              children: [
                                                hasSelected_OwnershipProof
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
                                                Text(
                                                    OwnershipProof
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                hasSelected_OwnershipProof
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
                                                                              OwnershipProofPATH.toString()),
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
                                          isUploading_OwnershipProof
                                              ? LinearProgressIndicator()
                                              : SizedBox(
                                                  height: 10,
                                                ),
                                          InkWell(
                                            onTap: () {
                                              uploadFileFunc(Insurance);
                                            },
                                            child: Row(
                                              children: [
                                                hasSelected_Insurance
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
                                                Text(Insurance.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                hasSelected_Insurance
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
                                                                              Insurance.toString()),
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
                                          isUploading_Insurance
                                              ? LinearProgressIndicator()
                                              : SizedBox(
                                                  height: 10,
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
                                                Text(Pictures.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                hasSelected_Pictures
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
                                                                              Pictures.toString()),
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
                                          isUploading_Pictures
                                              ? LinearProgressIndicator()
                                              : SizedBox(
                                                  height: 10,
                                                ),
                                          InkWell(
                                            onTap: () {
                                              uploadFileFunc(RoadWorthiness);
                                            },
                                            child: Row(
                                              children: [
                                                hasSelected_RoadWorthiness
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
                                                Text(
                                                    RoadWorthiness
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                hasSelected_RoadWorthiness
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
                                                                              RoadWorthiness.toString()),
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
                                          isUploading_RoadWorthiness
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
                                            createTruck();
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.local_shipping_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: AutoSizeText('REGISTER NEW TRUCKS',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                )),
                            width: width * .4,
                          ),
                          // Text("REGISTER",
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w400,
                          //       color: Colors.white,
                          //     )),
                          // SizedBox(
                          //   height: 3,
                          // ),
                          // Text("NEW TRUCKS",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w400,
                          //     )),
                        ],
                      )),
                ),
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
        columns: const <DataColumn>[
          DataColumn(
            label: Text('MAKER'),
          ),
          DataColumn(
            label: Text('MODEL'),
          ),
          DataColumn(
            label: Text(''),
          ),
        ],
        rows: List<DataRow>.generate(
          box.read('trucks').length,
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
              DataCell(Text('${box.read('trucks')[index]['maker']}')),
              DataCell(Text('${box.read('trucks')[index]['model']}')),
              DataCell(TextButton(
                onPressed: () {
                  showTruckDetails(box.read('trucks')[index]);
                },
                child: Text(
                  "More",
                  style: TextStyle(color: Colors.blue[900]),
                ),
              )),
            ],
            // selected: selected[index],
          ),
        ),
      ),
    );
  }
}
