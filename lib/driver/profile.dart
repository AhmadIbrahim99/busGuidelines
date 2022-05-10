import 'package:flutter/material.dart';
import 'package:stalker/admin/buss.dart';
import 'package:stalker/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stalker/widgets/dialog.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String id=UserProvider.userModel.id;
  String company;
  String number;
  CollectionReference buss = FirebaseFirestore.instance.collection('buss');


  getData(){
    buss.doc(id).get().then((value){
      company=value.data()['company_title'];
      number=value.data()['driver_number'];
    });
  }


  @override
  Widget build(BuildContext context) {

    setState(() {
      getData();
    });
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Column(
            children: [
              ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Ink.image(
                    image: NetworkImage(
                        "https://api.ferrarinetwork.ferrari.com/v2/network-content/medias//resize/6022aca7db71fa7bf1b360e0-ferrari-driver-academy-profile-2021-armstrong-tile?apikey=9QscUiwr5n0NhOuQb463QEKghPrVlpaF&width=750&height=0"),
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              (UserProvider.userModel.name !=null)? Text(UserProvider.userModel.name,style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 24),):Text('No Data'),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(Icons.email,color: Colors.white,),
                  SizedBox(width: 16.0,),
                  (UserProvider.userModel.name !=null)?Text(UserProvider.userModel.email??"No Data", style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic,),):Text('No Data'),
                ],),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(Icons.business_sharp,color: Colors.white,),
                  SizedBox(width: 16.0,),
                  (UserProvider.userModel.name !=null)?Text("Company Name : "+company??"No Data", style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic,),):Text('No Data'),
                ],),
              SizedBox(
                height: 16,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              Icon(Icons.phone,color: Colors.white,),
              SizedBox(width: 16.0,),
              (UserProvider.userModel.name !=null)?Text("Driver Number : "+number??"No Data", style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic,),):Text('No Data'),

            ],)
            ],
          ),
        ),
    floatingActionButton: Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: FloatingActionButton(
          onPressed: (){
            return updateUser(context);
          },
          child: Icon(Icons.update),
        ),
      ),
    ),
    );
  }

}
