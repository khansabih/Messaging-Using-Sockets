import 'dart:convert';
import 'dart:io';
import 'package:chat_app_websocket/Home/homeScreen.dart';
import 'package:chat_app_websocket/models/loginModel.dart';
import 'package:flutter/material.dart';
import 'registrationScreen.dart';

class login_screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new login_screenState();
  }

}

class login_screenState extends State<login_screen>{

  Socket socket;
  void socketInitialize() async{
    socket = await Socket.connect('127.0.0.1', 6969);
    print(socket.toString());
  }

  String userMail,userName;
  final TextEditingController user_mail = new TextEditingController();
  final TextEditingController user_password = new TextEditingController();

  void sign_in_user(String mail, String password){
    loginModel userDetails = new loginModel(mail, password);
    socket.writeln(userDetails);
    socket.listen((data) async{
      String recievedMessage = new String.fromCharCodes(data).trim();
      Map<String,String> response = jsonDecode(recievedMessage);
      if(response['status']=='success'){
        setState(() {
          userMail = response['email'];
          userName = response['username'];
        });
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context)=>new homeScreen(
            email: userMail,
            name: userName,
          ))
        );
      }else{
        print(response['message'].toString());
      }
    });
  }


  @override
  void initState() {
    socketInitialize();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[

              //The images
              Container(
                height: MediaQuery.of(context).size.height*(1/2),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/register_bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(210.0)
                    )
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height-(MediaQuery.of(context).size.height*(1/2)),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[

                    TextField(
                      controller: user_mail,
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
                      controller: user_password,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
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

                      obscureText: true,

                    ),

                    SizedBox(height: 50.0,),

                    //Buttons for sign up and sign in

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        //Sign in button
                        GestureDetector(
                          child: Container(
                            height:65.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3.0,
                                      color: Colors.black54
                                  )
                                ]
                            ),
                            child: Center(
                              child: Text("SIGN IN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5
                                ),),
                            ),
                          ),
                          onTap: (){
                            sign_in_user(user_mail.text.toString().trim(), user_password.text.toString().trim());
                          },
                        ),

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
                            Navigator.of(context).push(
                              new MaterialPageRoute(builder: (BuildContext context)=> registrationSceen(
                                socket: socket,
                              ))
                            );
                          },
                        )

                      ],
                    )




                  ],
                ),
              )

            ],
          ),
        )
    );
  }
}