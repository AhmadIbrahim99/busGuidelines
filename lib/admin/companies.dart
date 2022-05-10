import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllCompanies extends StatefulWidget {
  @override
  _AllCompaniesState createState() => _AllCompaniesState();
}

class _AllCompaniesState extends State<AllCompanies> {
  @override
  Widget build(BuildContext context) {
    CollectionReference company = FirebaseFirestore.instance.collection('companies');

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("All companies"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _allCompanies(company),
      ),
    );
  }

  Widget _allCompanies(CollectionReference category){
    return StreamBuilder(
      stream: category.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
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
                Text("No Data",style: TextStyle(fontSize: 24),),
                SizedBox(width: 34,),
                Icon(Icons.hourglass_empty_outlined,size: 32,),
              ],
            ),),
          );
        }
        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new ListTile(
                        title: new Text("Name : " + document.data()['title']),
                        subtitle: new Text("Owned Buss : "+document.data()['numberOfBuss']),

                        trailing: IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: (){
                            category.doc(document.id).delete();
                          },
                        ),
                      ),

                    ),
                    Padding(padding: EdgeInsets.only(bottom: 8),
                      child: Text(document.data()['company_description']),
                    ),
                    Text("Address : "+document.data()['address']),
                    SizedBox(height: 8,),
                    Text("Phone : "+document.data()['phone']),
                    SizedBox(height: 16,),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
