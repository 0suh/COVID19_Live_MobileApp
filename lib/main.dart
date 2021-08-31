import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pa3/pages/LoginComplete.dart';
import 'package:pa3/pages/StartLive.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2018312257 YoungsuhChin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginFirst(),
    );
  }
}

class LoginFirst extends StatelessWidget{
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar:AppBar(
          title:Text('2018312257 YoungsuhChin'),
        ),
        body: Center(
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children : <Widget>[
                  Text(
                    "CORONA LIVE",
                    style: TextStyle(color: Colors.blueGrey,fontSize: 40),
                  ),
                  Text(
                    "Login Please...",
                    style: TextStyle(color:Colors.black38,fontSize: 20),
                  ),
                  Container(
                      margin: EdgeInsets.only(top:50.0) ,
                      width:300,
                      height: 180,
                      decoration: BoxDecoration(
                        shape:BoxShape.rectangle,
                        borderRadius:BorderRadius.circular(15.0),
                        border: Border.all(
                            color:Colors.black38,
                            width: 3
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("ID:", style:TextStyle(fontSize: 20)),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    controller: idController,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("PW:", style:TextStyle(fontSize: 20)),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    controller: passwordController,
                                  ),
                                ),
                              ],
                            ),

                            ElevatedButton(
                                onPressed: (){
                                  if(idController.text == "skku" && passwordController.text == "1234")
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder:(context)=>LoginComplete(id:idController)),
                                    );
                                  },
                                child:Text("Login") )
                          ]
                      )
                  ),

                ]
            )
        )
    );
  }
}
