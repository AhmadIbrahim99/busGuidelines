import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllBuss extends StatefulWidget {
  @override
  _AllBussState createState() => _AllBussState();
}

class _AllBussState extends State<AllBuss> {

  @override
  Widget build(BuildContext context) {
    CollectionReference buss = FirebaseFirestore.instance.collection('buss');

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("All buss"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
             // _drawSearch(),
              _drawCard(buss),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawCard(CollectionReference buss){
    return StreamBuilder<QuerySnapshot>(
      stream: buss.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if(snapshot.hasData){
          return new ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration:(document.data()['check'])?BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(1.0),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ):BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(1.0),
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
                          title: new Text(document.data()['buss_title'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                          subtitle: new Text(document.data()['buss_price']+" \$",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,color: Colors.red,),
                            onPressed: (){
                              buss.doc(document.id).delete();
                            },
                          ),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8,right: 16.0,left: 8.0),
                        child: new Text(document.data()['buss_description'],textDirection: TextDirection.rtl,maxLines: 2,overflow: TextOverflow.ellipsis,),
                      ),
                      new Text("Driver Name : "+document.data()['bus_driver'],),
                      Padding(
                        padding: const EdgeInsets.only(top:16.0),
                        child: new Text("Company Name : "+document.data()['company_title']),
                      ),
                      SizedBox(height: 16,),
                      //Image.network(document.data()['buss_image'].toString()),
                    ],
                  ),

                ),
              );
            }).toList(),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

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

      },
    );
  }

  Widget _drawSearch() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search..',
        prefix: Icon(Icons.search),
      ),
      onChanged: (val){
        setState(() {

        });
      },
    ),
  );

}
