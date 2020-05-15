import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chat_app_websocket/models/registrationModel.dart';
import 'dart:convert';
import 'otp_verification_screen.dart';

class registrationSceen extends StatefulWidget{

  final Socket socket;

  const registrationSceen({Key key, this.socket}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new registrationScreenState();
  }

}

class registrationScreenState extends State<registrationSceen>{

  //Initialize the socket
//  Socket socket;
//  void socketInitialize() async{
//    socket = await Socket.connect('127.0.0.1', 6969);
//    print(socket.toString());
//  }

  final TextEditingController registerMail = new TextEditingController();
  final TextEditingController registerPassword = new TextEditingController();
  final TextEditingController registerUserName = new TextEditingController();
  //For password visibility
  int vis = 0;

  void onDataHandler(data){

  }

  void onErrorHandler(){

  }

  void onDoneHandler(){

  }

  void signUp(){
    String username = registerUserName.text.toString().trim();
    String usermail = registerMail.text.toString().trim();
    String userpassword = registerPassword.text.toString().trim();

    registrationModel user = registrationModel(
      '${username}',
      '${usermail}',
      '${userpassword}'
    );
    String userMap = jsonEncode(user);
    widget.socket.writeln(userMap);
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context)=>otp_verification_screen(
        socket: widget.socket,
      ))
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*(1/4)
            ),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[

                TextField(
                  controller: registerUserName,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.mail, color: Colors.black,),
                      labelText: "Make a username",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0
                      )
                  ),

                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500
                  ),

                ),

                SizedBox(height: 20.0,),

                TextField(
                  controller: registerMail,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.mail, color: Colors.black,),
                      labelText: "Email",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0
                      )
                  ),

                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500
                  ),

                ),

                SizedBox(height: 20.0,),

                //Another textfield to get the password

                TextField(
                  controller: registerPassword,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      suffixIcon: (vis==0)?IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: (){setState(() {
                            vis = 1;
                          });},
                      ):IconButton(
                          icon : Icon(Icons.visibility),
                          onPressed: (){
                            setState(() {
                              vis = 0;
                            });
                          },
                      ),
                      icon: Icon(Icons.lock, color: Colors.black,),
                      labelText: "Password",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0
                      )
                  ),

                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),

                  obscureText: (vis==0)?true:false,

                ),

                SizedBox(height: 50.0,),

                //SIGN UP button
                GestureDetector(
                  child: Container(
                    height:65.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                            color: Colors.black54,
                            width: 2.0
                        )
                    ),
                    child: Center(
                      child: Text("SIGN UP",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5
                        ),),
                    ),
                  ),
                  onTap: (){
                    signUp();

                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}