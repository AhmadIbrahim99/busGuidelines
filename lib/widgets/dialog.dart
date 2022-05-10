import 'package:flutter/material.dart';

Future<void> showMyDialog(context,String name,String describe, String address, String phone) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue[200
        ],
        scrollable: true,
        title: Text(name),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Divider(thickness: 2,color: Colors.blue,),
              Text(describe),
              Divider(thickness: 2,color: Colors.blue,),
              Text("Address : "+address),
              Divider(thickness: 2,color: Colors.blue,),
              Text("Phone : "+phone),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showDiverDialog(context,String name,String describe, String driverNumber, String driverName) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue[200
        ],
        scrollable: true,
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://api.ferrarinetwork.ferrari.com/v2/network-content/medias//resize/6022aca7db71fa7bf1b360e0-ferrari-driver-academy-profile-2021-armstrong-tile?apikey=9QscUiwr5n0NhOuQb463QEKghPrVlpaF&width=750&height=0"
                    ),),
                ],
              ),
              Divider(thickness: 2,color: Colors.blue,),
              Text(name,style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.black),),
              Divider(thickness: 2,color: Colors.blue,),
              Text(describe, textDirection: TextDirection.rtl,),
              Divider(thickness: 2,color: Colors.blue,),
              Text("Phone : "+driverNumber,),
              Divider(thickness: 2,color: Colors.blue,),
              Text("Driver Name : "+driverName,),
            ],
          ),
        ),
        actions: <Widget>[
      FloatingActionButton(onPressed: (){},child: Icon(Icons.phone),)
      ,TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


Future<void> updateUser(context) async {
  TextEditingController _name=TextEditingController();
  TextEditingController _number=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update"),
        content: Container(
          height: MediaQuery.of(context).size.height*0.5,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  validator: (value){
                    if(value.isEmpty || value.length<4){
                      return "required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _number,
                  decoration: InputDecoration(
                    hintText: "Phone",
                  ),
                  validator: (value){
                    if(value.isEmpty || value.length!=10){
                      return "required 10 digits You Entered ${value.length}";
                    }
                    return null;
                  },
                ),
              ],),),
            ],
          ),
        ),
        actions: [
          FloatingActionButton(onPressed: ()async{
            if(_formKey.currentState.validate()){

            }
            },child: Icon(Icons.send),),
          SizedBox(width: 16,),
          FloatingActionButton(onPressed: (){Navigator.pop(context);},child: Icon(Icons.cancel),),
        ],
      );
    },
  );
}
