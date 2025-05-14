import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:prodrivers/api/auth.dart';
import 'package:prodrivers/components/notification.dart';

class CreateGuaarantor extends StatefulWidget {
  static const String routeName = '/gurans';

  const CreateGuaarantor({
    super.key,
  });

  @override
  _CreateGuaarantorState createState() => _CreateGuaarantorState();
}

class _CreateGuaarantorState extends State<CreateGuaarantor> with RouteAware {
  final box = GetStorage();

    GetUpdatedProfile() {
    AuthAPI.GET_WITH_TOKEN(urlendpoint: 'auth/user').then((value) => {
      print(value),
      box.write('userdetails', value["result"]),
      setState(() {
        
      })
    });
  }

  createGuarantor() {
    showLoading();
    Map guarantorData = {
      "first_name": _guarantorFirstNameCtrl.text,
      "middle_name": _guarantorMiddleNameCtrl.text,
      "last_name": _guarantorLastNameCtrl.text,
      "email": _guarantorEmailCtrl.text,
      "home_address": _guarantorHomeAddressCtrl.text,
      "work_address": _guarantorWorkAddressCtrl.text,
      "phone_number": _guarantorPhoneCtrl.text,
      "gender": _guarantorGenderCtrl.text,
      "relationship": _guarantorRelationshipCtrl.text,
      "occupation": _guarantorOccupationCtrl.text,
      // "id_card_id": Guarantor_ID_Card,
    };

    print(guarantorData);

    AuthAPI.POST_WITH_TOKEN(
            urlendpoint: "store/guarantor", postData: guarantorData)
        .then((value) => {
          hideLoading(),
              print(value),
              GetUpdatedProfile(),
            }).onError((error, stackTrace) => {
              hideLoading()
            });
  }

  Widget showText(String text) {
    return Text(text,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500));
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: width * .15,
              ),
              const Text('CREATE GUARANTOR',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
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
              hintText: '',
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
              hintText: '',
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
              hintText: '',
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
              hintText: '',
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
              hintText: '',
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
              hintText: '',
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
                _guarantorGenderCtrl.text = val.value.toString().toLowerCase();
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
              hintText: '',
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
              hintText: '',
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
              hintText: '',
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
              hintText: '',
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
                  createGuarantor();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(width, 54),
                  backgroundColor: Color(0xFF0263C91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "CREATE GUARANTOR",
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                )),
          ),
          SizedBox(
            height: 200,
          )
        ]),
      ),
    ));
  }
}
