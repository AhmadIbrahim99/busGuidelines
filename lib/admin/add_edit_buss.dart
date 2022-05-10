import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class AddEditBuss extends StatefulWidget {
  @override
  _AddEditBussState createState() => _AddEditBussState();
}

class _AddEditBussState extends State<AddEditBuss> {

  final _formKey=GlobalKey<FormState>();
  File _image;
 // final picker=ImagePicker();

  String imageUrl;

  TextEditingController _bussTitle=TextEditingController();
  TextEditingController _bussDescription=TextEditingController();
  TextEditingController _bussPrice=TextEditingController();
  TextEditingController _driverNumber=TextEditingController();
  String hintText="Select Company";
  String hintText1="Select Driver";
  String selectedValueCompany;
  String selectedValueDriver;
  String idDriver;
  QuerySnapshot response;

  documentSnapshot() async {
     response = await FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: selectedValueDriver).get();
     idDriver=(response.docs.first['id']);
     print(idDriver);
  }
  bool isLoading=false;

 /* Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }*/

  @override
  void dispose() {
    // TODO: implement dispose
    _bussPrice.dispose();
    _bussDescription.dispose();
    _bussTitle.dispose();
    _driverNumber.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("New Buss"),
        centerTitle: true,
      ),
      body: ( isLoading )?_loading() : _addProduct(),
    );
  }

  Widget _addProduct()=>SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _bussTitle,
              decoration: InputDecoration(
                hintText: "Buss Title",
              ),
              validator: (value){
                if(value.isEmpty){
                  return "Title Is Required";
                }
                return null;
              },
            ),
            SizedBox(height: 16,),
            TextFormField(
              controller: _bussDescription,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Buss Description",
              ),
              validator: (value){
                if(value.isEmpty){
                  return "Title Is Required";
                }
                return null;
              },
            ),
            SizedBox(height: 16,),
            TextFormField(
              controller: _bussPrice,
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: "Price",
              ),
              validator: (value){
                if(value.length>1){
                  return "Price Is Required And Less Than 2 Digits you Entered :${value.length}";
                }
                return null;
              },
            ),
            SizedBox(height: 16,),
            TextFormField(
              controller: _driverNumber,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Phone",
              ),
              validator: (value){
                  if(value.isEmpty || value.length!=10){
                    return "Phone Is Required you Entered :${value.length}";
                  }
                  return null;
              },
            ),
            SizedBox(height: 16,),
            SizedBox(
                width: double.infinity,
                child: _selectCategory()),
            SizedBox(
                width: double.infinity,
                child: _selectDriver()),
            SizedBox(height: 16,),
            (_image==null)?Text("No Image Selected",textAlign: TextAlign.center,):Image.file(_image),
            SizedBox(height: 16,),
            ElevatedButton(onPressed: (){
              /* getImage();*/
            }, child: Text("Select Image")),
            SizedBox(height: 32,),
            ElevatedButton(onPressed: (){
              if(_formKey.currentState.validate()){
                setState(() {
                  isLoading=true;
                });
                upload(_bussTitle.text);
                documentSnapshot();
                FirebaseFirestore.instance.collection("buss").doc(idDriver)
                    .set({
                  "buss_title" : _bussTitle.text,
                  "buss_description" : _bussDescription.text,
                  "buss_price" : _bussPrice.text,
                  "driver_number":_driverNumber.text,
                  "check":true,
                  "company_title" : selectedValueCompany,
                  "bus_driver" : selectedValueDriver,
                  "buss_image" : imageUrl,
                }).then((value) async {
                  setState(() {
                    isLoading=false;
                  });
                  _bussPrice.text="";
                  _bussDescription.text="";
                  _bussTitle.text="";
                  _driverNumber.text="";
                  selectedValueCompany=null;
                  selectedValueDriver=null;
                  _image=null;
                });
              }
            },
              child: Text("Save Buss",style: TextStyle(color: Colors.white),),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),),
            ),
          ],
        ),
      ),
    ),
  );



  Widget _loading() => Container(
    child: Center(child: CircularProgressIndicator()),
  );

  Widget _selectCategory() =>  StreamBuilder(
  stream: FirebaseFirestore.instance.collection('companies').snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasError) {
  return Text('Something went wrong');
  }
  if (snapshot.connectionState == ConnectionState.waiting) {
  return Text("Loading");
  }
  if(snapshot.data.docs.isEmpty){
  return Container(
  child: Center(child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Text("No Data",style: TextStyle(fontSize: 16),),
  SizedBox(width: 34,),
  Icon(Icons.hourglass_empty_outlined,size: 16,),
  ],
  ),),
  );
  }
  return DropdownButton<String>(
  value: selectedValueCompany,
  hint: Text(hintText),
  isExpanded: true,
  icon: Icon(Icons.arrow_drop_down,color: Colors.teal,),
  iconSize: 24,
  elevation: 16,
  style: const TextStyle(color: Colors.deepPurple),
  onChanged: (String newValue) {
  setState(() {
  selectedValueCompany= newValue;
  });
  },
  items:snapshot.data.docs.map((DocumentSnapshot document){
  return DropdownMenuItem<String>(
  value: document['title'],
  child:  Text(document['title']),
  );
  }).toList(),
  );

  }
  );

    Widget _selectDriver() => StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if(snapshot.data.docs.isEmpty){
            return Container(
              child: Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Data",style: TextStyle(fontSize: 16),),
                  SizedBox(width: 34,),
                  Icon(Icons.hourglass_empty_outlined,size: 16,),
                ],
              ),),
            );
          }
          return DropdownButton<String>(
            value: selectedValueDriver,
            hint: Text(hintText1),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down,color: Colors.teal,),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String newValue) {
              setState(() {
                selectedValueDriver= newValue;
                documentSnapshot();

              });
            },
            items:snapshot.data.docs.map((DocumentSnapshot document){
              return DropdownMenuItem<String>(
                value: document['name'],
                child:  Text(document['name']),
              );
            }).toList(),
          );

        }
    );

  Future upload(String name)async{
    var file=File(_image.path);
    if(_image!=null){
      var snapshot= await firebase_storage.FirebaseStorage.instance.ref().child("images/$name").putFile(file).whenComplete(() => null);

      setState(() async {
        var downloadUrl= await snapshot.ref.getDownloadURL();
        imageUrl=downloadUrl;
      });
    }else{

    }

  }

}
