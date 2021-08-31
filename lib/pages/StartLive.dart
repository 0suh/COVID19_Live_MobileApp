import 'package:flutter/material.dart';
import 'package:pa3/pages/LoginComplete.dart';
import 'package:pa3/pages/CasesDeath.dart';
import 'package:pa3/pages/Vaccine.dart';

class StartLive extends StatelessWidget{
  TextEditingController usrid;
  String page;

  StartLive({Key key, @required this.usrid, @required this.page}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              leading:Icon(Icons.coronavirus_outlined),
              title:Text("Cases/Deaths"),
              onTap:(){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context)=>CasesDeath(usrid: usrid,)),
                );
              },
            ),
            ListTile(
                leading:Icon(Icons.local_hospital),
                title:Text("Vaccine"),
                onTap:(){
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context)=>Vaccine(usrid: usrid,)),
                  );
                },
            ),
            Container(
              margin: EdgeInsets.only(top:240.0) ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome! "+usrid.text,
                    style: TextStyle(color:Colors.black38,fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Previous: "+page,
                    style: TextStyle(color:Colors.blueGrey,fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}