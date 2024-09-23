

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muslimconnect/models/signup_model.dart';
import '../common/widgets/custom_alert.dart';
import '../core/my_pref.dart';
import '../models/userProfile.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'color_res.dart';
import 'font_res.dart';


class FunctionRes{

  final MyPref myPref = MyPref.to;

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

  // Save object to _box (GetX)
   Future<void> saveUserProfile(SignupModel? object) async {
      //final MyPref myPref = MyPref.to;
      final jsonString = jsonEncode(object?.toJson());
      debugPrint("Saved Stringify data +++ \n $jsonString");
      myPref.pSigningUpData.val = jsonString;
  }

  // Retrieve object from _box (GetX)
   Future<SignupModel?> getUserProfile() async {
     final MyPref myPref = MyPref.to;
    final jsonString = myPref.pSigningUpData.val;
    if (jsonString.isNotEmpty && jsonString != '') {
      final jsonMap = jsonDecode(jsonString);
      return SignupModel.fromJson(jsonMap);
    }

    return null;
  }

  Future<Map<String, dynamic>> fetchDataFromAPI(String url, {Map<String, dynamic>? data, bool isPost = false, bool isReg = false}) async {
    try {
      debugPrint("Loading...");
      http.Response response;

      if (isPost) {
        response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': myPref.pTokenFCM.val ?? ""
          },
          body: jsonEncode(data),
        );
      } else {
        response = await http.get(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': myPref.pTokenFCM.val ?? ""
          },
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }else if (response.statusCode == 404 || response.statusCode == 401 || response.statusCode == 500) {
        Map<String, dynamic> responseData = json.decode(response.body);
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return CustomAlertDialog(
              title: 'An error occurred!',
              showIcon: true,
              type: 'error',
              description: Text("Check your connection and try again",
                style: AppFont.regularMetro.copyWith(
                    fontSize: 14,
                    color: ColorRes.goldLight
                ),

              ),
              onTap: (){
                Navigator.of(context).pop();
              },
            );
          },
        );
        return responseData;
      }

      else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }




  Future<Map<String, dynamic>> sendPut(String url, {Map<String, dynamic>? data}) async {
    try {
      debugPrint("Loading...");
      http.Response response;

      response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': myPref.pTokenFCM.val ?? ""
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }else if (response.statusCode == 404 || response.statusCode == 401 || response.statusCode == 500) {
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }

      else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }


}