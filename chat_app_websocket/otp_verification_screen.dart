import 'dart:convert';
import 'dart:io';

import 'package:chat_app_websocket/Registration/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_websocket/main.dart';
import 'package:chat_app_websocket/models/otpVerificationModel.dart';
import 'registrationScreen.dart';

class otp_verification_screen extends StatefulWidget{

  final Socket socket;

  const otp_verification_screen({Key key, this.socket}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new otp_verification_screenState();
  }

}

class otp_verification_screenState extends State<otp_verification_screen>{

  final TextEditingController otp = new TextEditingController();
//  Socket _socket;
//  void socketInitialize() async{
//    _socket = await Socket.connect('127.0.0.1', 6969);
//    print(_socket.toString());
//  }

  void register(String credential){

    otpVerificationModel otpVerificationObject = otpVerificationModel(credential);
    String otpMap = jsonEncode(otpVerificationObject);

    widget.socket.writeln(otpMap);

    widget.socket.listen((data) async {
      String recievedMessage = new String.fromCharCodes(data).trim();
      Map<String,String> response = jsonDecode(recievedMessage);
      if(response['status']=='success'){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context)=>new login_screen())
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*(1/3)),
          child: Column(
              children: <Widget>[
                TextField(
                    controller: otp,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.mail, color: Colors.black,),
                        labelText: "Enter OTP",
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0
                        )
                    ),

                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 5.0,
                        fontWeight: FontWeight.w500
                    ),

                  ),

                SizedBox(height: 20.0,),

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
                      child: Text("REGISTER",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5
                        ),),
                    ),
                  ),
                  onTap: (){
                    String cr = otp.text.toString().trim();
                    register(cr);
                  },
                )

              ],
            ),
          ),
        ),
    );
  }
}