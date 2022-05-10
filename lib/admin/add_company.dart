import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCompany extends StatefulWidget {
  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  TextEditingController _companyTitle = TextEditingController();
  TextEditingController _companyDesc = TextEditingController();
  TextEditingController _numberOfBuss = TextEditingController();
  TextEditingController _companyAddress = TextEditingController();
  TextEditingController _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _companyTitle.dispose();
    _companyAddress.dispose();
    _phone.dispose();
    _numberOfBuss.dispose();
    _companyAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Company"),
        centerTitle: true,
      ),
      body: (isLoading) ? _loading() : _categoryForm(),
    );
  }


  Widget _categoryForm() => SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _companyTitle,
              decoration: InputDecoration(
                hintText: "Company Title",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Title Is Required";
                }
                return null;
              },
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
              controller: _companyDesc,
              decoration: InputDecoration(
                hintText: "Company Description",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Description Is Required";
                }
                return null;
              },
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
              controller: _companyAddress,
              decoration: InputDecoration(
                hintText: "Company Address",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Description Is Required";
                }
                return null;
              },
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _numberOfBuss,
              decoration: InputDecoration(
                hintText: "Company Owned buss",
              ),
              validator: (value) {
                if (value.length>2 || value.isEmpty) {
                  return "Required And Less Than 2 digits you Entered :${value.length}";
                }
                return null;
              },
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _phone,
              decoration: InputDecoration(
                hintText: "Company Phone Number",
              ),
              validator: (value) {
                if (value.length!=10 || value.isEmpty) {
                  return "Required And Equal 10 you Entered :${value.length} degits";
                }
                return null;
              },
            ),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  //search value
                  var response = await FirebaseFirestore.instance
                      .collection("companies")
                      .where('title', isEqualTo: _companyTitle.text.trim())
                      .snapshots()
                      .first;

                  if (response.docs.length >= 1) {
                    Fluttertoast.showToast(
                        msg: "This company Is Already Exist",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    FirebaseFirestore.instance.collection("companies").doc()
                        .set({
                      "title": _companyTitle.text,
                      "company_description":_companyDesc.text,
                      "numberOfBuss":_numberOfBuss.text,
                      "phone":_phone.text,
                      "address":_companyAddress.text,
                    }).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      _companyTitle.text = "";
                      _companyDesc.text="";
                      _numberOfBuss.text="";
                      _companyAddress.text="";
                      _phone.text="";
                    });
                  }
                }
              },
              child: Text(
                "Save Company",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.teal),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _loading() => Container(
    child: Center(child: CircularProgressIndicator()),
  );
}
