import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class loginModel{
  final String mail;
  final String password;

  loginModel(this.mail, this.password);

  loginModel.fromJson(Map<String, dynamic> json, this.password)
      : mail = json['mail'];

  Map<String, dynamic> toJson() =>
  {
    "request" : "login",
    "details" : {
      "username": "$mail",
      "password" : "$password",
      "email":""
    }
  };

}
