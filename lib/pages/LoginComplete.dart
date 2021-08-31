import 'package:flutter/material.dart';
import 'package:pa3/pages/StartLive.dart';

class LoginComplete extends StatelessWidget{
  TextEditingController id;
  final String page = "Login Page";

  LoginComplete({Key key, @required this.id}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('2018312257 YoungsuhChin'),
        ),
        body:Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "CORONA LIVE",
                  style: TextStyle(color: Colors.blueGrey,fontSize: 40),
                ),
                Text(
                    "Login Success. Hello "+id.text+"!!",
                  style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child:Image.asset("assets/images/img1.jpg"),
                ),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context)=>StartLive(usrid:id,page: page,)),
                  );
                }, child: Text("Start CORONA LIVE"))
              ],
            )
        )
    );
  }
}