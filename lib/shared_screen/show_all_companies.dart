import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stalker/widgets/dialog.dart';

class ShowCompanies extends StatefulWidget {
  @override
  _ShowCompaniesState createState() => _ShowCompaniesState();
}

class _ShowCompaniesState extends State<ShowCompanies> {
  @override
  Widget build(BuildContext context) {
    CollectionReference company = FirebaseFirestore.instance.collection('companies');
    return Scaffold(
      body: _drawDataTable(company),
    );
  }
}

Widget _drawDataTable(CollectionReference company) {
  return StreamBuilder<QuerySnapshot>(
    stream: company.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.hasData) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: DataTable(
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Name',overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Describe',overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Owned Buss',overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: snapshot.data.docs.map((DocumentSnapshot document) {
                  return DataRow(
                      cells: [
                        DataCell(Text(document.data()['title'],overflow: TextOverflow.ellipsis,),onTap: (){showMyDialog(context,document.data()['title'],"This Is the Company Name : "+document.data()['title'],document.data()['address'],document.data()['phone']);}),
                        DataCell(Text("إضغط هنا",overflow: TextOverflow.ellipsis,),onTap: (){showMyDialog(context,document.data()['title'],document.data()['company_description'],document.data()['address'],document.data()['phone']);}),
                        DataCell(Text(document.data()['numberOfBuss'],overflow: TextOverflow.ellipsis,),onTap: (){showMyDialog(context,document.data()['title'],"The Number Of owned buss for this company is : "+document.data()['numberOfBuss'],document.data()['address'],document.data()['phone']);}),
                      ]
                  );
                } ).toList()
            ),
          ),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading");
      }

      return Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Data",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                width: 34,
              ),
              Icon(
                Icons.hourglass_empty_outlined,
                size: 32,
              ),
            ],
          ),
        ),
      );
    },
  );
}
