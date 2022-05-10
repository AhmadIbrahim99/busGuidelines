import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stalker/widgets/dialog.dart';

class ShowBuss extends StatefulWidget {
  @override
  _ShowBussState createState() => _ShowBussState();
}

class _ShowBussState extends State<ShowBuss> {
  CollectionReference buss = FirebaseFirestore.instance.collection('buss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _drawDataTable(buss),
    );
  }

  Widget _drawDataTable(CollectionReference buss) {
    return StreamBuilder<QuerySnapshot>(
      stream: buss.snapshots(),
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
                      'Name',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Company',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Price',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: snapshot.data.docs.map((DocumentSnapshot document) {
                  return DataRow(
                    cells: [
                      DataCell(Text(document.data()['buss_title']),onTap: (){showDiverDialog(context,document.data()['buss_title'],document.data()['buss_description'],document.data()['driver_number'],document.data()['name']);}),
                      DataCell(Text(document.data()['company_title']),onTap: (){showDiverDialog(context,document.data()['company_title'],"اسم الباص : "+document.data()['buss_title']+"\n"+document.data()['buss_description'],document.data()['driver_number'],document.data()['name']);}),
                      DataCell(Text(document.data()['buss_price']),onTap: (){showDiverDialog(context,document.data()['buss_title'],"The Price From Rafah To Gaza : "+document.data()['buss_price']+"\$",document.data()['driver_number'],document.data()['name']);}),
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
}

