import 'package:flutter/material.dart';

class registrationModel{
  final String userName;
  final String emailID;
  final String password;

  registrationModel(this.userName, this.emailID, this.password);

  Map<String, dynamic> toJson()=>{
    "request":"registration",
    "details": {
      "email":emailID,
      "password":password,
      "username":userName
    }
  };

}