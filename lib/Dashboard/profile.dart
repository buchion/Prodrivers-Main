import 'dart:io';
import 'dart:ui';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prodrivers/Dashboard/Guarantor/createGuarantor.dart';
import 'package:prodrivers/Dashboard/Guarantor/gurans.dart';
import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/notification.dart';
import 'package:prodrivers/components/utils.dart';
// import 'package:prodrivers/Authentication/prodriverssignup.dart';
// import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

bool isUploadingCAC = false;
bool hasSelectedCAC = false;
String CACImageName = "UPLOAD CAC DOCUMENT ";
String CACImagePath = "";
dynamic cac_picture_id = null;

bool isUploadingGIT = false;
bool hasSelectedGIT = false;
String GITImageName = "GOODS-IN-TRANSIT INSURANCE ";
String GITImagePath = "";
dynamic git_picture_id = null;

bool isUploadingFidelity = false;
bool hasSelectedFidelity = false;
String FidelityImageName = "UPLOAD FIDELITY INSURANCE ";
String FidelityImagePath = "";
dynamic Fidelity_picture_id = null;

class _ProfileViewState extends State<ProfileView> with RouteAware {
  String dropdownvalue = 'personal';

  final _firstNameNode = FocusNode();
  final _firstNameCtrl = TextEditingController();

  final _lastNameNode = FocusNode();
  final _lastNameCtrl = TextEditingController();

  final _middleNameNode = FocusNode();
  final _middleNameCtrl = TextEditingController();

  final _emailNode = FocusNode();
  final _emailCtrl = TextEditingController();

  final _phoneNode = FocusNode();
  final _phoneCtrl = TextEditingController();

  String Gender = '';
  String MarriedStatus = '';
  int bank_id = 0;

  final _workaddressNode = FocusNode();
  final _workaddressCtrl = TextEditingController();

  final _homeaddNode = FocusNode();
  final _homeaddCtrl = TextEditingController();

  // final _guarantorNode = FocusNode();
  // final _guarantorCtrl = TextEditingController();

  final _companyEmailNode = FocusNode();
  final _companyEmailCtrl = TextEditingController();

  final _companyNameNode = FocusNode();
  final _companyNameCtrl = TextEditingController();

  final _companyPhoneNode = FocusNode();
  final _companyPhoneCtrl = TextEditingController();

  final _rcnumberNode = FocusNode();
  final _rcnumberCtrl = TextEditingController();

  final _nokNameNode = FocusNode();
  final _nokNameCtrl = TextEditingController();

  final _nokEmailNode = FocusNode();
  final _nokEmailCtrl = TextEditingController();

  final _nokPhoneNode = FocusNode();
  final _nokPhoneCtrl = TextEditingController();

  final _nokOccupationNode = FocusNode();
  final _nokOccupationCtrl = TextEditingController();

  final _guarantorLastNameNode = FocusNode();
  final _guarantorLastNameCtrl = TextEditingController();

  final _guarantorFirstNameNode = FocusNode();
  final _guarantorFirstNameCtrl = TextEditingController();

  final _guarantorMiddleNameNode = FocusNode();
  final _guarantorMiddleNameCtrl = TextEditingController();

  final _guarantorEmailNode = FocusNode();
  final _guarantorEmailCtrl = TextEditingController();

  final _guarantorPhoneNode = FocusNode();
  final _guarantorPhoneCtrl = TextEditingController();

  final _guarantorOccupationNode = FocusNode();
  final _guarantorOccupationCtrl = TextEditingController();

  final _guarantorHomeAddressNode = FocusNode();
  final _guarantorHomeAddressCtrl = TextEditingController();

  final _guarantorWorkAddressNode = FocusNode();
  final _guarantorWorkAddressCtrl = TextEditingController();

  final _guarantorGenderCtrl = TextEditingController();

  final _guarantorRelationshipCtrl = TextEditingController();

  final _accountNumberNode = FocusNode();
  final _accountNumberCtrl = TextEditingController();

  final _accountNameNode = FocusNode();
  final _accountNameCtrl = TextEditingController();

  String relationship = '';

  int Guarantor_ID_Card = 0;

  final box = GetStorage();

  uploadCACDocument(ImageFilePath) {
    setState(() {
      isUploadingCAC = true;
    });
    AuthAPI.UploadSingleFiles(filePath: ImageFilePath).then((value) => {
          print('VALUE FOR LICENSE UPLOAD:$value'),
          if (value["success"] == true)
            {
              print(value["result"]["file"]["id"]),
              notifyInfo(content: "CAC UPLOAD SUCCESSFUL"),
              setState(() {
                cac_picture_id = value["result"]["file"]["id"];
                isUploadingCAC = false;
              }),
              updateCompanyDocs("cac_document", value["result"]["file"]["id"])
            }
          else
            {
              notifyError(content: "LICENSE NOT UPLOADED"),
              setState(() {
                isUploadingCAC = false;
              }),
            }
          //     })
          // .onError((error, stackTrace) => {
          //       notifyError(content: "LICENSE NOT UPLOADED"),
          //       setState(() {
          //         isUploadingCAC = false;
          //       }),
        });
  }

  uploadGIT_Insurance(ImageFilePath) {
    setState(() {
      isUploadingGIT = true;
    });
    AuthAPI.UploadSingleFiles(filePath: ImageFilePath).then((value) => {
          print('VALUE FOR LICENSE UPLOAD:${value['success']}'),
          print('VALUE FOR LICENSE UPLOAD:${value['success'].runtimeType}'),
          if (value["success"] != null)
            {
              notifyInfo(content: "INSURANCE UPLOAD SUCCESSFUL"),
              setState(() {
                git_picture_id = value["result"]["file"]["id"];
                isUploadingGIT = false;
              }),
              updateCompanyDocs(
                  "goods_in_transit_insurance", value["result"]["file"]["id"])
            }
          else
            {
              notifyError(content: "Goods in Transit INSURANCE NOT UPLOADED"),
              setState(() {
                isUploadingGIT = false;
              }),
            }
        });
    // .onError((error, stackTrace) => {
    //       notifyError(content: "INSURANCE NOT UPLOADED"),
    //       setState(() {
    //         isUploadingGIT = false;
    //       }),
    //     });
  }

  uploadFidelityInsurance(ImageFilePath) {
    setState(() {
      isUploadingFidelity = true;
    });
    AuthAPI.UploadSingleFiles(filePath: ImageFilePath).then((value) => {
          print('VALUE FOR LICENSE UPLOAD:$value'),
          if (value["success"] == true)
            {
              notifyInfo(content: "INSURANCE UPLOAD SUCCESSFUL"),
              setState(() {
                Fidelity_picture_id = value["result"]["file"]["id"];
                isUploadingFidelity = false;
              }),
              updateCompanyDocs(
                  "fidelity_insurance", value["result"]["file"]["id"])
            }
          else
            {
              notifyError(content: "INSURANCE NOT UPLOADED"),
              setState(() {
                isUploadingFidelity = false;
              }),
            }
          //     })
          // .onError((error, stackTrace) => {
          //       notifyError(content: "INSURANCE NOT UPLOADED"),
          //       setState(() {
          //         isUploadingFidelity = false;
          //       }),
        });
  }

  Widget showText(String text) {
    return Text(text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400));
  }

  Widget HSpace() {
    return SizedBox(
      height: 20,
    );
  }

  Widget HSpacsm() {
    return SizedBox(
      height: 10,
    );
  }

  updateProfile() {
    AuthAPI.PATCH_WITH_TOKEN(urlendpoint: "update/profile", postData: {
      "email": _emailCtrl.text.isEmpty
          ? box.read('userdetails')["email"]
          : _emailCtrl.text,
      "first_name": _firstNameCtrl.text.isEmpty
          ? box.read('userdetails')["first_name"]
          : _firstNameCtrl.text,
      "gender": Gender.isEmpty
          ? box.read('userdetails')["gender"]
          : Gender.toLowerCase(),
      "home_address": _homeaddCtrl.text.isEmpty
          ? box.read('userdetails')["home_address"]
          : _homeaddCtrl.text,
      "work_address": _workaddressCtrl.text.isEmpty
          ? box.read('userdetails')["work_address"]
          : _workaddressCtrl.text,
      "last_name": _lastNameCtrl.text.isEmpty
          ? box.read('userdetails')["last_name"]
          : _lastNameCtrl.text,
      "marital_status": MarriedStatus.isEmpty
          ? box.read('userdetails')["marital_status"]
          : MarriedStatus.toLowerCase(),
      "phone_number": _phoneCtrl.text.isEmpty
          ? box.read('userdetails')["phone_number"]
          : _phoneCtrl.text,
    }).then((value) => {
          print(value),
          if (value['success'] == true)
            {
              box.write('userdetails', value["result"]),
            },
          setState(() {}),
        });
  }

  updateCompanyDocs(doc_title, document_id) {
    AuthAPI.PATCH_WITH_TOKEN(
        urlendpoint: "update/company/${box.read('companydetails')['id']} ",
        postData: {
          "email": _companyEmailCtrl.text.isEmpty
              ? box.read('userdetails')["company"]['email']
              : _companyEmailCtrl.text,
          "name": _companyNameCtrl.text.isEmpty
              ? box.read('userdetails')['company']["name"]
              : _companyNameCtrl.text,
          "rc_number": _rcnumberCtrl.text.isEmpty
              ? box.read('userdetails')["company"]['rc_number']
              : _rcnumberCtrl.text,
          "phone_number": _companyPhoneCtrl.text.isEmpty
              ? box.read('userdetails')["company"]['phone_number']
              : _companyPhoneCtrl.text,
          doc_title: document_id
        }).then((value) => {
          print(value),
          if (value['success'] == true)
            {
              box.write('companydetails', value["result"]),
            },
          setState(() {}),
        });
  }

  updateCompany() {
    AuthAPI.PATCH_WITH_TOKEN(
        urlendpoint: "update/company/${box.read('companydetails')['id']}",
        postData: {
          "email": _companyEmailCtrl.text.isEmpty
              ? box.read('userdetails')["company"]['email']
              : _companyEmailCtrl.text,
          "name": _companyNameCtrl.text.isEmpty
              ? box.read('userdetails')['company']["name"]
              : _companyNameCtrl.text,
          "rc_number": _rcnumberCtrl.text.isEmpty
              ? box.read('userdetails')["company"]['rc_number']
              : _rcnumberCtrl.text,
          "phone_number": _companyPhoneCtrl.text.isEmpty
              ? box.read('userdetails')["company"]['phone_number']
              : _companyPhoneCtrl.text,
        }).then((value) => {
          print(value),
          if (value['success'] == true)
            {
              box.write('companydetails', value["result"]),
            },
          GetUpdatedProfile(),
          setState(() {}),
        });
  }

  createCompany() {
    AuthAPI.POST_WITH_TOKEN(urlendpoint: "store/company", postData: {
      "email": _companyEmailCtrl.text.isEmpty
          ? box.read('userdetails')["company"]['email']
          : _companyEmailCtrl.text,
      "name": _companyNameCtrl.text.isEmpty
          ? box.read('userdetails')['company']["name"]
          : _companyNameCtrl.text,
      "rc_number": _rcnumberCtrl.text.isEmpty
          ? box.read('userdetails')["company"]['rc_number']
          : _rcnumberCtrl.text,
      "phone_number": _companyPhoneCtrl.text.isEmpty
          ? box.read('userdetails')["company"]['phone_number']
          : _companyPhoneCtrl.text,
    }).then((value) => {
          print(value),
          if (value['success'] == true)
            {
              box.write('companydetails', value["result"]),
            },
          GetUpdatedProfile(),
          setState(() {}),
        });
  }

  updateBank() {
    AuthAPI.PATCH_WITH_TOKEN(
        urlendpoint: "update/banks/${box.read('bankdetails')['id']}",
        postData: {
          "account_name": _accountNameCtrl.text.isEmpty
              ? box.read('bankdetails')['account_name']
              : _accountNameCtrl.text,
          "account_number": _accountNumberCtrl.text.isEmpty
              ? box.read('bankdetails')["account_number"]
              : _accountNumberCtrl.text,
          "bank_id":
              bank_id == 0 ? box.read('bankdetails')['bank_id'] : bank_id,
        }).then((value) => {
          print(value),
          if (value['success'] == true)
            {
              box.write('bankdetails', value["result"]),
            },
          GetUpdatedProfile(),
          setState(() {}),
        });
  }

  createBank() {
    showLoading();


    AuthAPI.POST_WITH_TOKEN(urlendpoint: "store/banks", postData: {
      "account_name": _accountNameCtrl.text.isEmpty
          ? box.read('bankdetails')['account_name']
          : _accountNameCtrl.text,
      "account_number": _accountNumberCtrl.text.isEmpty
          ? box.read('bankdetails')["account_number"]
          : _accountNumberCtrl.text,
      "bank_id": bank_id == 0 ? box.read('bankdetails')['bank_id'] : bank_id,
    })
        .then((value) => {
              hideLoading(),
              if (value['success'] == true)
                {
                  box.write('bankdetails', value["result"]),
                  GetUpdatedProfile(),
                },
              setState(() {}),
            })
        .onError((error, stackTrace) => {hideLoading()});
  }

  updateGuarantor() {
    Map guarantorData = {
      "first_name": _guarantorFirstNameCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['first_name']
          : _guarantorFirstNameCtrl.text,
      "middle_name": _guarantorMiddleNameCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['middle_name']
          : _guarantorMiddleNameCtrl.text,
      "last_name": _guarantorLastNameCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['last_name']
          : _guarantorLastNameCtrl.text,
      "email": _guarantorEmailCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['email']
          : _guarantorEmailCtrl.text,
      "home_address": _guarantorHomeAddressCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['home_address']
          : _guarantorHomeAddressCtrl.text,
      "work_address": _guarantorWorkAddressCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['work_address']
          : _guarantorWorkAddressCtrl.text,
      "phone_number": _guarantorPhoneCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['phone_number']
          : _guarantorPhoneCtrl.text,
      "gender": _guarantorGenderCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['gender']
          : _guarantorGenderCtrl.text,
      "relationship": _guarantorRelationshipCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['relationship']
          : _guarantorRelationshipCtrl.text,
      "occupation": _guarantorOccupationCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['occupation']
          : _guarantorOccupationCtrl.text,
      // "id_card_id": Guarantor_ID_Card,
    };

    AuthAPI.PATCH_WITH_TOKEN(
            urlendpoint: "update/profile", postData: guarantorData)
        .then((value) => {
              print(value),
            });
  }

  createGuarantor() {
    Map guarantorData = {
      "first_name": _guarantorFirstNameCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['first_name']
          : _guarantorFirstNameCtrl.text,
      "middle_name": _guarantorMiddleNameCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['middle_name']
          : _guarantorMiddleNameCtrl.text,
      "last_name": _guarantorLastNameCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['last_name']
          : _guarantorLastNameCtrl.text,
      "email": _guarantorEmailCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['email']
          : _guarantorEmailCtrl.text,
      "home_address": _guarantorHomeAddressCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['home_address']
          : _guarantorHomeAddressCtrl.text,
      "work_address": _guarantorWorkAddressCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['work_address']
          : _guarantorWorkAddressCtrl.text,
      "phone_number": _guarantorPhoneCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['phone_number']
          : _guarantorPhoneCtrl.text,
      "gender": _guarantorGenderCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['gender']
          : _guarantorGenderCtrl.text,
      "relationship": _guarantorRelationshipCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['relationship']
          : _guarantorRelationshipCtrl.text,
      "occupation": _guarantorOccupationCtrl.text.isEmpty
          ? box.read('userdetails')["guarantor"]['occupation']
          : _guarantorOccupationCtrl.text,
      // "id_card_id": Guarantor_ID_Card,
    };

    print(guarantorData);

    AuthAPI.POST_WITH_TOKEN(
            urlendpoint: "store/guarantor", postData: guarantorData)
        .then((value) => {
              print(value),
            });
  }

  updateNext_of_Kin() {
    print({
      "next_of_kin_name": _nokNameCtrl.text.isEmpty
          ? box.read('userdetails')["next_of_kin"]['next_of_kin_name']
          : _nokNameCtrl.text,
      "next_of_kin_email_address": _nokEmailCtrl.text.isEmpty
          ? box.read('userdetails')['next_of_kin']["next_of_kin_email_address"]
          : _nokEmailCtrl.text,
      "next_of_kin_phone_number": _nokPhoneCtrl.text.isEmpty
          ? box.read('userdetails')["next_of_kin"]['next_of_kin_phone_number']
          : _nokNameCtrl.text,
      "next_of_kin_relationship": relationship.isEmpty
          ? box.read('userdetails')['next_of_kin']["next_of_kin_relationship"]
          : relationship,
      "next_of_kin_occupation": _nokOccupationCtrl.text.isEmpty
          ? box.read('userdetails')['next_of_kin']["next_of_kin_occupation"]
          : _nokOccupationCtrl.text,
    });

    AuthAPI.PATCH_WITH_TOKEN(urlendpoint: "update/profile", postData: {
      "next_of_kin_name": _nokNameCtrl.text.isEmpty
          ? box.read('userdetails')["next_of_kin"]['next_of_kin_name']
          : _nokNameCtrl.text,
      "next_of_kin_email_address": _nokEmailCtrl.text.isEmpty
          ? box.read('userdetails')['next_of_kin']["next_of_kin_email_address"]
          : _nokEmailCtrl.text,
      "next_of_kin_phone_number": _nokPhoneCtrl.text.isEmpty
          ? box.read('userdetails')["next_of_kin"]['next_of_kin_phone_number']
          : _nokNameCtrl.text,
      "next_of_kin_relationship": relationship.isEmpty
          ? box.read('userdetails')['next_of_kin']["next_of_kin_relationship"]
          : relationship,
      "next_of_kin_occupation": _nokOccupationCtrl.text.isEmpty
          ? box.read('userdetails')['next_of_kin']["next_of_kin_occupation"]
          : _nokOccupationCtrl.text,
    }).then((value) => {
          print(value),
        });
  }

  GetUpdatedProfile() {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: 'auth/user').then((value) => {
          print(value),
          box.write('userdetails', value["result"]),
        });
  }

  @override
  void initState() {
    super.initState();

    GetUpdatedProfile();

    if (box.read('userdetails')['company'] != null) {
      box.write('companydetails', box.read('userdetails')['company']);
    }

    if (box.read('userdetails')['guarantor'] != null) {
      box.write('guarantordetails', box.read('userdetails')['guarantor']);
    }

    if (box.read('userdetails')['bank_account'] != null) {
      box.write('bankdetails', box.read('userdetails')['bank_account']);
    }

    print('${box.read('bankdetails')}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 60,
        ),
        if (box.read('userType') == 'cargo-owner') ...[
          cargoOwnerTabSection(context)
        ],
        if (box.read('userType') == 'transporter') ...[
          transporterTabSection(context)
        ],
      ]),
    ));
  }

  Widget personal(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Image.asset(
          //       'assets/images/bigavatar.png',
          //       height: 150,
          //       width: 150,
          //     ),
          //   ],
          // ),

          SizedBox(
            height: 20,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showText("FIRST NAME"),
              HSpacsm(),
              TextFormField(
                focusNode: _firstNameNode,
                controller: _firstNameCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["first_name"] ?? '',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("LAST NAME"),
              HSpacsm(),
              TextFormField(
                focusNode: _lastNameNode,
                controller: _lastNameCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["last_name"] ?? '',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("MIDDLE NAME"),
              HSpacsm(),
              TextFormField(
                focusNode: _middleNameNode,
                controller: _middleNameCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["middle_name"] ?? 'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("EMAIL ADDRESS"),
              HSpacsm(),
              TextFormField(
                focusNode: _emailNode,
                controller: _emailCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["email"] ?? 'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("PHONE NUMBER"),
              HSpacsm(),
              TextFormField(
                focusNode: _phoneNode,
                controller: _phoneCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["phone_number"] ?? 'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("GENDER"),
              HSpacsm(),
              DropDownTextField(
                clearOption: false,
                // validator: (value) => validateRequired(value!, "Tonnage"),
                // textFieldFocusNode: _tonnageNode,
                // searchFocusNode: searchTONFocusNode,
                // searchAutofocus: true,
                textFieldDecoration: InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["gender"] ?? 'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                dropDownItemCount: 5,
                searchShowCursor: false,
                dropDownList: [
                  DropDownValueModel(name: "MALE", value: "Male"),
                  DropDownValueModel(name: "FEMALE", value: "Female"),
                ],
                onChanged: (val) {
                  print(val.value);
                  setState(() {
                    Gender = val.value.toString();
                  });
                },
              ),
              HSpace(),
              showText("MARITAL STATUS"),
              HSpacsm(),
              DropDownTextField(
                clearOption: false,
                // validator: (value) => validateRequired(value!, "Tonnage"),
                // textFieldFocusNode: _tonnageNode,
                // searchFocusNode: searchTONFocusNode,
                // searchAutofocus: true,
                textFieldDecoration: InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["marital_status"] ?? 'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                dropDownItemCount: 5,
                searchShowCursor: false,
                dropDownList: [
                  DropDownValueModel(name: "SINGLE", value: "Single"),
                  DropDownValueModel(name: "MARRIED", value: "Married"),
                  DropDownValueModel(name: "DIVORCED", value: "Divorced"),
                ],
                onChanged: (val) {
                  print(val.value);
                  setState(() {
                    MarriedStatus = val.value.toString();
                  });
                },
              ),
              HSpace(),
              showText("WORK ADDRESS"),
              HSpacsm(),
              TextFormField(
                focusNode: _workaddressNode,
                controller: _workaddressCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["work_address"] ?? 'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("HOME ADDRESS"),
              HSpacsm(),
              TextField(
                focusNode: _homeaddNode,
                controller: _homeaddCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["home_address"] ?? 'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              HSpace(),
              SizedBox(
                width: 428,
                height: 48,
                child: TextButton(
                    onPressed: () {
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width, 54),
                      backgroundColor: Color(0xFF0263C91),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'UPDATE PROFILE',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 200,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget next_of_kin(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showText("NEXT OF KIN FULL NAME"),
              HSpacsm(),
              TextFormField(
                focusNode: _nokNameNode,
                controller: _nokNameCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["first_name"] ?? '',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("NEXT OF KIN EMAIL ADDRESS"),
              HSpacsm(),
              TextFormField(
                focusNode: _nokEmailNode,
                controller: _nokEmailCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')['next_of_kin'] == null
                      ? 'N/A'
                      : box.read('userdetails')['next_of_kin']
                              ['next_of_kin_email_address'] ??
                          'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("NEXT OF KIN PHONE NUMBER"),
              HSpacsm(),
              TextFormField(
                focusNode: _nokPhoneNode,
                controller: _nokPhoneCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')['next_of_kin'] == null
                      ? 'N/A'
                      : box.read('userdetails')['next_of_kin']
                              ['next_of_kin_phone_number'] ??
                          'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("NEXT OF KIN OCCUPATION"),
              HSpacsm(),
              TextFormField(
                focusNode: _nokOccupationNode,
                controller: _nokOccupationCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')['next_of_kin'] == null
                      ? 'N/A'
                      : box.read('userdetails')['next_of_kin']
                              ['next_of_kin_occupation'] ??
                          'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("NEXT OF KIN RELATIONSHIP"),
              HSpacsm(),
              DropDownTextField(
                clearOption: false,
                searchAutofocus: true,
                enableSearch: true,
                searchKeyboardType: TextInputType.name,
                textFieldDecoration: InputDecoration(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')['next_of_kin'] == null
                      ? 'N/A'
                      : box
                              .read('userdetails')['next_of_kin']
                                  ['next_of_kin_relationship']
                              .toUpperCase() ??
                          'N/A',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                dropDownItemCount: 5,
                searchShowCursor: false,
                dropDownList: [
                  DropDownValueModel(name: "Aunt", value: "Aunt"),
                  DropDownValueModel(name: "Brother", value: "Brother"),
                  DropDownValueModel(name: "Cousin", value: "Cousin"),
                  DropDownValueModel(name: "Daughter", value: "Daughter"),
                  DropDownValueModel(name: "Father", value: "Father"),
                  DropDownValueModel(name: "Nephew", value: "Nephew"),
                  DropDownValueModel(name: "Niece", value: "Niece"),
                  DropDownValueModel(name: "Other", value: "Other"),
                  DropDownValueModel(name: "Son", value: "Son"),
                  DropDownValueModel(name: "Spouse", value: "Spouse"),
                  DropDownValueModel(name: "Sibling", value: "Sibling"),
                  DropDownValueModel(name: "Sister", value: "Sister"),
                  DropDownValueModel(name: "Uncle", value: "Uncle"),
                ],
                onChanged: (val) {
                  print(val.value);
                  setState(() {
                    relationship = val.value.toString();
                  });
                },
              ),
              HSpace(),
              HSpace(),
              HSpace(),
              SizedBox(
                width: 428,
                height: 48,
                child: TextButton(
                    onPressed: () {
                      updateNext_of_Kin();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width, 54),
                      backgroundColor: Color(0xFF0263C91),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "UPDATE NEXT OF KIN",
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 200,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget company(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showText("COMPANY NAME"),
              HSpacsm(),
              TextFormField(
                focusNode: _companyNameNode,
                controller: _companyNameCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["company"] != null
                      ? box.read('userdetails')["company"]["name"] ?? ''
                      : '',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("COMPANY EMAIL"),
              HSpacsm(),
              TextFormField(
                focusNode: _companyEmailNode,
                controller: _companyEmailCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["company"] != null
                      ? box.read('userdetails')["company"]["email"] ?? ''
                      : '',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("COMPANY PHONE"),
              HSpacsm(),
              TextFormField(
                focusNode: _companyPhoneNode,
                controller: _companyPhoneCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["company"] != null
                      ? box.read('userdetails')["company"]["phone_number"] ?? ''
                      : '',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("RC NUMBER"),
              HSpacsm(),
              TextFormField(
                focusNode: _rcnumberNode,
                controller: _rcnumberCtrl,
                style: const TextStyle(fontSize: 20),
                cursorColor: const Color(0xFF3D3F92),
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: box.read('userdetails')["company"] != null
                      ? box.read('userdetails')["company"]["rc_number"] ?? ''
                      : '',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                // onChanged: (String value) {
                //   // user.password = value;
                // },
                // onEditingComplete: () {
                //   // FocusScope.of(context).requestFocus(_passwordNode);
                // },
              ),
              HSpace(),
              showText("CAC Document"),
              HSpacsm(),
              InkWell(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path.toString());

                    setState(() {
                      isUploadingCAC = true;
                      CACImagePath = result.files.single.path.toString();
                      CACImageName = result.files.single.name;
                      hasSelectedCAC = true;
                    });
                    uploadCACDocument(CACImagePath);
                  } else {
                    // User canceled the picker
                  }
                },
                child: Row(
                  children: [
                    // Icon(Icons.add_a_photo_outlined, size: 35,),
                    hasSelectedCAC
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
                    Text(CACImageName,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.w400)),

                    hasSelectedCAC
                        ? TextButton(
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          content: Image.asset(CACImagePath),
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
              isUploadingCAC ? LinearProgressIndicator() : SizedBox(),
              HSpace(),
              showText("Goods-in-Transit Insurance"),
              HSpacsm(),
              InkWell(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path.toString());

                    setState(() {
                      isUploadingGIT = true;
                      GITImagePath = result.files.single.path.toString();
                      GITImageName = result.files.single.name;
                      hasSelectedGIT = true;
                    });
                    uploadGIT_Insurance(GITImagePath);
                  } else {}
                },
                child: Row(
                  children: [
                    hasSelectedGIT
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
                    Text(GITImageName,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.w400)),
                    hasSelectedGIT
                        ? TextButton(
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          content: Image.asset(GITImagePath),
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
              isUploadingGIT ? LinearProgressIndicator() : SizedBox(),
              HSpace(),
              showText("Fidelity Document"),
              HSpacsm(),
              InkWell(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path.toString());

                    setState(() {
                      isUploadingFidelity = true;
                      FidelityImagePath = result.files.single.path.toString();
                      FidelityImageName = result.files.single.name;
                      hasSelectedFidelity = true;
                    });
                    uploadFidelityInsurance(FidelityImagePath);
                  } else {}
                },
                child: Row(
                  children: [
                    hasSelectedFidelity
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
                    Text(FidelityImageName,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.w400)),
                    hasSelectedFidelity
                        ? TextButton(
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          content:
                                              Image.asset(FidelityImagePath),
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
              isUploadingFidelity ? LinearProgressIndicator() : SizedBox(),
              SizedBox(height: 50),
              SizedBox(
                width: 428,
                height: 48,
                child: TextButton(
                    onPressed: () {
                      box.read('userdetails')['company'] == null
                          ? createCompany()
                          : updateCompany();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width, 54),
                      backgroundColor: Color(0xFF0263C91),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      box.read('userdetails')['company'] == null
                          ? 'CREATE COMPANY'
                          : "UPDATE COMPANY",
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 200,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget guarantor(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 30),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            showText("GUARANTOR PHONE NUMBER"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorPhoneNode,
              controller: _guarantorPhoneCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantors"] != null
                    ? box.read('userdetails')["guarantors"][0]
                            ["phone_number"] ??
                        ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_guarantorFirstNameNode);
              },
            ),
            HSpace(),
            showText("GUARANTOR FIRST NAME"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorFirstNameNode,
              controller: _guarantorFirstNameCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantor"] != null
                    ? box.read('userdetails')["guarantor"]["first_name"] ?? ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_guarantorMiddleNameNode);
              },
            ),
            HSpace(),
            showText("GUARANTOR MIDDLE NAME"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorMiddleNameNode,
              controller: _guarantorMiddleNameCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantor"] != null
                    ? box.read('userdetails')["guarantor"]["middle_name"] ?? ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_guarantorLastNameNode);
              },
            ),
            HSpace(),
            showText("GUARANTOR LAST NAME"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorLastNameNode,
              controller: _guarantorLastNameCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantor"] != null
                    ? box.read('userdetails')["guarantor"]["last_name"] ?? ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
            ),
            HSpace(),
            showText("GUARANTOR RELATIONSHIP"),
            HSpacsm(),
            DropDownTextField(
              clearOption: false,
              searchAutofocus: true,
              enableSearch: true,
              searchKeyboardType: TextInputType.name,
              textFieldDecoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')['guarantor'] == null
                    ? 'N/A'
                    : box
                            .read('userdetails')['guarantor']['relationship']
                            .toUpperCase() ??
                        'N/A',
                hintStyle: TextStyle(color: Colors.black),
              ),
              dropDownItemCount: 5,
              searchShowCursor: false,
              dropDownList: [
                DropDownValueModel(name: "Aunt", value: "Aunt"),
                DropDownValueModel(name: "Brother", value: "Brother"),
                DropDownValueModel(name: "Cousin", value: "Cousin"),
                DropDownValueModel(name: "Daughter", value: "Daughter"),
                DropDownValueModel(name: "Father", value: "Father"),
                DropDownValueModel(name: "Nephew", value: "Nephew"),
                DropDownValueModel(name: "Niece", value: "Niece"),
                DropDownValueModel(name: "Other", value: "Other"),
                DropDownValueModel(name: "Son", value: "Son"),
                DropDownValueModel(name: "Spouse", value: "Spouse"),
                DropDownValueModel(name: "Sibling", value: "Sibling"),
                DropDownValueModel(name: "Sister", value: "Sister"),
                DropDownValueModel(name: "Uncle", value: "Uncle"),
              ],
              onChanged: (val) {
                print(val.value);
                setState(() {
                  _guarantorRelationshipCtrl.text = val.value.toString();
                });
              },
            ),
            HSpace(),
            showText("GUARANTOR GENDER"),
            HSpacsm(),
            DropDownTextField(
              clearOption: false,
              searchAutofocus: false,
              enableSearch: false,
              searchKeyboardType: TextInputType.name,
              textFieldDecoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')['guarantor'] == null
                    ? 'N/A'
                    : box
                            .read('userdetails')['guarantor']['gender']
                            .toUpperCase() ??
                        'N/A',
                hintStyle: TextStyle(color: Colors.black),
              ),
              dropDownItemCount: 5,
              searchShowCursor: false,
              dropDownList: [
                DropDownValueModel(name: "Male", value: "Male"),
                DropDownValueModel(name: "Female", value: "Female"),
              ],
              onChanged: (val) {
                setState(() {
                  _guarantorGenderCtrl.text =
                      val.value.toString().toLowerCase();
                });
              },
            ),
            HSpace(),
            showText("GUARANTOR HOME ADDRESS"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorHomeAddressNode,
              controller: _guarantorHomeAddressCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantor"] != null
                    ? box.read('userdetails')["guarantor"]["home_address"] ?? ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_guarantorWorkAddressNode);
              },
            ),
            HSpace(),
            showText("GUARANTOR WORK ADDRESS"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorWorkAddressNode,
              controller: _guarantorWorkAddressCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantor"] != null
                    ? box.read('userdetails')["guarantor"]["work_address"] ?? ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_guarantorEmailNode);
              },
            ),
            HSpace(),
            showText("GUARANTOR EMAIL"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorEmailNode,
              controller: _guarantorEmailCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantor"] != null
                    ? box.read('userdetails')["guarantor"]["email"] ?? ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_guarantorOccupationNode);
              },
            ),
            HSpace(),
            showText("GUARANTOR OCCUPATION"),
            HSpacsm(),
            TextFormField(
              focusNode: _guarantorOccupationNode,
              controller: _guarantorOccupationCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["guarantor"] != null
                    ? box.read('userdetails')["guarantor"]["occupation"] ?? ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                // FocusScope.of(context).requestFocus(_passwordNode);
                FocusScope.of(context).unfocus();
              },
            ),
            HSpace(),
            SizedBox(
              width: width * .83,
              height: 48,
              child: TextButton(
                  onPressed: () {
                    box.read('userdetails')['guarantor'] != null
                        ? updateGuarantor()
                        : createGuarantor();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width, 54),
                    backgroundColor: Color(0xFF0263C91),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    box.read('userdetails')['guarantor'] != null
                        ? "UPDATE GUARANTOR"
                        : "CREATE GUARANTOR",
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  )),
            ),
            SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }

  Widget bank(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(children: [
      Container(
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showText("BANK NAME"),
            HSpacsm(),
            SizedBox(
              width: width * .9,
              child: DropDownTextField(
                clearOption: false,
                validator: (value) => validateRequired(value!, "BANK NAME"),
                // textFieldFocusNode: _truckTypeNode,
                // searchFocusNode: searchTruckFocusNode,
                // searchAutofocus: true,
                textFieldDecoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.blue.shade50,
                  hintText: box.read('userdetails')["bank_account"] != null
                      ? box.read('bankdetails')["bank"]['name'] ?? ''
                      : '',
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                ),
                dropDownItemCount: 6,
                searchShowCursor: false,
                enableSearch: true,
                searchKeyboardType: TextInputType.number,
                dropDownList:
                    // box.read('tonnages'),
                    [
                  for (var bank in box.read('allBanks'))
                    DropDownValueModel(
                        name: bank["name"].toString().toUpperCase(),
                        value: bank["id"]),
                ],
                onChanged: (val) {
                  print(val.value.runtimeType);

                  setState(() {
                    bank_id = val.value;
                  });
                },
              ),
            ),
            HSpace(),
            showText("ACCOUNT NUMBER "),
            HSpacsm(),
            TextFormField(
              focusNode: _accountNumberNode,
              controller: _accountNumberCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["bank_account"] != null
                    ? box.read('userdetails')["bank_account"]
                            ["account_number"] ??
                        ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              // onChanged: (String value) {
              //   // user.password = value;
              // },
              // onEditingComplete: () {
              //   // FocusScope.of(context).requestFocus(_passwordNode);
              // },
            ),
            HSpace(),
            showText("ACCOUNT NAME"),
            HSpacsm(),
            TextFormField(
              focusNode: _accountNameNode,
              controller: _accountNameCtrl,
              style: const TextStyle(fontSize: 20),
              cursorColor: const Color(0xFF3D3F92),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: box.read('userdetails')["bank_account"] != null
                    ? box.read('userdetails')["bank_account"]["account_name"] ??
                        ''
                    : '',
                hintStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              // onChanged: (String value) {
              //   // user.password = value;
              // },
              // onEditingComplete: () {
              //   // FocusScope.of(context).requestFocus(_passwordNode);
              // },
            ),
            HSpace(),
            HSpace(),
            SizedBox(
              width: 428,
              height: 48,
              child: TextButton(
                  onPressed: () {
                    box.read('userdetails')['bank_account'] != null
                        ? updateBank()
                        : createBank();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width, 54),
                    backgroundColor: Color(0xFF0263C91),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    box.read('userdetails')['bank_account'] != null
                        ? "UPDATE BANK"
                        : "CREATE BANK",
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  )),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget transporterTabSection(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: width * .9,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[50],
            ),
            child: TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                unselectedLabelColor: Colors.blue[700],
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // Creates border
                  color: Colors.blue[800],
                ),
                tabs: const [
                  Tab(
                    text: "PERSONAL",
                  ),
                  Tab(text: "COMPANY"),
                  Tab(text: "GUARANTOR"),
                  Tab(text: "BANK"),
                ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              personal(context),
              company(context),
              // guarantor(context),
              GuarantorList(context),
              bank(context),
            ]),
          ),
        ],
      ),
    );
  }

  Widget cargoOwnerTabSection(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: width * .9,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[50],
            ),
            child: TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                unselectedLabelColor: Colors.blue[700],
                // isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // Creates border
                  color: Colors.blue[800],
                ),
                tabs: const [
                  Tab(
                    text: "PERSONAL",
                  ),
                  Tab(text: "COMPANY"),
                  Tab(text: "NEXT OF KIN"),
                ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              personal(context),
              company(context),
              next_of_kin(context),
            ]),
          ),
        ],
      ),
    );
  }

  Widget GuarantorList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          for (var guarans in box.read('userdetails')["guarantors"])
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset('assets/images/guarantor.png'),
                    title: Text(
                        "${guarans['last_name']} ${guarans['first_name']}"),
                    subtitle: Text("${guarans['phone_number']} "),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('EDIT'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Guarans(
                                guarans: guarans,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('VIEW'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Guarans(
                                guarans: guarans,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 100,
          ),
          SizedBox(
            width: 300,
            height: 48,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateGuaarantor(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 54),
                  backgroundColor: Color(0xFF0263C91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "ADD NEW GUARANTOR",
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                )),
          ),
        ],
      ),
    );
  }
}
