import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslimconnect/screens/login_dashboard/login_controller.dart';
import 'package:muslimconnect/screens/login_dashboard/widgets/auth_card.dart';
import 'package:muslimconnect/utils/app_res.dart';
import 'package:muslimconnect/utils/asset_res.dart';
import 'package:muslimconnect/utils/color_res.dart';

class LoginDashboardScreen extends StatelessWidget {
  const LoginDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = LoginController.to;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Image.asset(
              AssetRes.login_arab_lady,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height / 8),
                  Image.asset(
                    AssetRes.themeLabelWhite,
                    height: 61,
                    width: 286,
                  ),
                  const Text(
                    AppRes.loginToContinue,
                    style: TextStyle(
                      color: ColorRes.white,
                      fontSize: 13,
                      fontFamily: 'gilroy_bold',
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: Get.height / 13),
                  Obx(
                    () => AuthCard(
                      emailController: loginController.emailController,
                      emailFocus: loginController.emailFocus,
                      emailError: loginController.emailError.value,
                      onPhoneTap: loginController.onPhoneTap,
                      onContinueTap: loginController.onContinueTap,
                      onGoogleTap: loginController.onGoogleTap,
                      onFacebookTap: loginController.onFacebookTap,
                      onAppleTap: loginController.onAppleTap,
                      onSignUpTap: loginController.onSignUpTap,
                      onForgotPwdTap: loginController.onForgotPwdTap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
