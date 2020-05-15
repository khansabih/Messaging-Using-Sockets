import 'package:flutter/material.dart';

class otpVerificationModel{
  final String credential;

  otpVerificationModel(this.credential);

  Map<String, dynamic> toJson()=>{
    "request":"verify",
    "otp":credential
  };

}
