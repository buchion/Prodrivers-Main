import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prodrivers/api/auth.dart';

class Guarans extends StatefulWidget {
  static const String routeName = '/gurans';

  final Map guarans;

  const Guarans({super.key, required this.guarans});

  // const Guarans({super.key});

  @override
  _GuaransState createState() => _GuaransState();
}

class _GuaransState extends State<Guarans> with RouteAware {
  final box = GetStorage();

  updateGuarantor() {
    Map guarantorData = {
      "first_name": _guarantorFirstNameCtrl.text.isEmpty
          ? widget.guarans['first_name']
          : _guarantorFirstNameCtrl.text,
      // "middle_name": _guarantorMiddleNameCtrl.text.isEmpty
      //     ? widget.guarans['middle_name']
      //     : _guarantorMiddleNameCtrl.text,
      "last_name": _guarantorLastNameCtrl.text.isEmpty
          ? widget.guarans['last_name']
          : _guarantorLastNameCtrl.text,
      "email": _guarantorEmailCtrl.text.isEmpty
          ? widget.guarans['email']
          : _guarantorEmailCtrl.text,
      "home_address": _guarantorHomeAddressCtrl.text.isEmpty
          ? widget.guarans['home_address']
          : _guarantorHomeAddressCtrl.text,
      "work_address": _guarantorWorkAddressCtrl.text.isEmpty
          ? widget.guarans['work_address']
          : _guarantorWorkAddressCtrl.text,
      "phone_number": _guarantorPhoneCtrl.text.isEmpty
          ? widget.guarans['phone_number']
          : _guarantorPhoneCtrl.text,
      "gender": _guarantorGenderCtrl.text.isEmpty
          ? widget.guarans['gender']
          : _guarantorGenderCtrl.text,
      "relationship": _guarantorRelationshipCtrl.text.isEmpty
          ? widget.guarans['relationship']
          : _guarantorRelationshipCtrl.text,
      "occupation": _guarantorOccupationCtrl.text.isEmpty
          ? widget.guarans['occupation']
          : _guarantorOccupationCtrl.text,
      // "id_card_id": Guarantor_ID_Card,
    };

    AuthAPI.PATCH_WITH_TOKEN(
            urlendpoint: "update/guarantor/${widget.guarans['id']}", postData: guarantorData)
        .then((value) => {
              print(value),
            });
  }

  createGuarantor() {
    Map guarantorData = {
      "first_name": _guarantorFirstNameCtrl.text.isEmpty
          ? widget.guarans['first_name']
          : _guarantorFirstNameCtrl.text,
      "middle_name": _guarantorMiddleNameCtrl.text.isEmpty
          ? widget.guarans['middle_name']
          : _guarantorMiddleNameCtrl.text,
      "last_name": _guarantorLastNameCtrl.text.isEmpty
          ? widget.guarans['last_name']
          : _guarantorLastNameCtrl.text,
      "email": _guarantorEmailCtrl.text.isEmpty
          ? widget.guarans['email']
          : _guarantorEmailCtrl.text,
      "home_address": _guarantorHomeAddressCtrl.text.isEmpty
          ? widget.guarans['home_address']
          : _guarantorHomeAddressCtrl.text,
      "work_address": _guarantorWorkAddressCtrl.text.isEmpty
          ? widget.guarans['work_address']
          : _guarantorWorkAddressCtrl.text,
      "phone_number": _guarantorPhoneCtrl.text.isEmpty
          ? widget.guarans['phone_number']
          : _guarantorPhoneCtrl.text,
      "gender": _guarantorGenderCtrl.text.isEmpty
          ? widget.guarans['gender']
          : _guarantorGenderCtrl.text,
      "relationship": _guarantorRelationshipCtrl.text.isEmpty
          ? widget.guarans['relationship']
          : _guarantorRelationshipCtrl.text,
      "occupation": _guarantorOccupationCtrl.text.isEmpty
          ? widget.guarans['occupation']
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
      child: Column(children: [
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
              width: width * .2,
            ),
            const Text('Edit Guarantors',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
        editGuarantor(context, widget.guarans)
      ]),
    ));
  }

  Widget editGuarantor(BuildContext context, guarans) {
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
                hintText: guarans != null ? guarans["phone_number"] ?? '' : '',
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
                hintText: guarans != null ? guarans["first_name"] ?? '' : '',
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
                hintText: guarans != null ? guarans["middle_name"] ?? '' : '',
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
                hintText: guarans != null ? guarans["last_name"] ?? '' : '',
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
                hintText: guarans == null
                    ? 'N/A'
                    : guarans['relationship'].toUpperCase() ?? 'N/A',
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
                hintText: guarans == null
                    ? 'N/A'
                    : guarans['gender'].toUpperCase() ?? 'N/A',
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
                hintText: guarans != null ? guarans["home_address"] ?? '' : '',
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
                hintText: guarans != null ? guarans["work_address"] ?? '' : '',
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
                hintText: guarans != null ? guarans["email"] ?? '' : '',
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
                hintText: guarans != null ? guarans["occupation"] ?? '' : '',
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
                    guarans != null ? updateGuarantor() : createGuarantor();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width, 54),
                    backgroundColor: Color(0xFF0263C91),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    guarans != null ? "UPDATE GUARANTOR" : "CREATE GUARANTOR",
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
}
