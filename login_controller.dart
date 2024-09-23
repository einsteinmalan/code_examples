import 'package:muslimconnect/screens/login_dashboard/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslimconnect/core/app_binding.dart';
import 'package:muslimconnect/core/my_pref.dart';
import 'package:muslimconnect/screens/login_dashboard/login_password_screen.dart';
import 'package:muslimconnect/screens/register/register_screen.dart';
import 'package:muslimconnect/screens/starting_profile/starting_profile_screen.dart';
import 'package:muslimconnect/utils/app_res.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find<LoginController>();
  final MyPref myPref = MyPref.to;

  final TextEditingController emailController = TextEditingController(
    text: '',
  );

  final FocusNode emailFocus = FocusNode();
  final emailError = "".obs;

  void onContinueTap() {
    bool validation = isValid();
    update();

    emailFocus.unfocus();
    if (validation) {
      String email = emailController.text.trim();
      myPref.pEmail.val = email;
      Get.to(() => LoginPasswordScreen());
    }
  }

  bool isValid() {
    if (emailController.text == "") {
      emailError.value = AppRes.enterEmail;
      update();
      return false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailController.clear();
      emailError.value = AppRes.validEmail;
      update();
      return false;
    } else {
      emailError.value = "";
      update();
      return true;
    }
  }

  void onPhoneTap() {
    debugPrint("onPhoneTap clicked...");

    Get.to(() => AuthPage(), binding: AppBinding());
  }

  void onGoogleTap() {
    debugPrint("onGoogleTap clicked...");
  }

  void onFacebookTap() {
    debugPrint("onFacebookTap clicked...");
  }

  void onAppleTap() {
    debugPrint("onAppleTap clicked...");
  }

  void onSignUpTap() {
    update();
    Get.to(() => RegisterScreen(), binding: AppBinding());
    emailFocus.unfocus();
  }

  void onForgotPwdTap() {
    debugPrint("onForgotPwdTap clicked...");
  }

  // password screen
  TextEditingController pwdController = TextEditingController();
  FocusNode pwdFocus = FocusNode();
  final pwdError = "".obs;
  final showPwd = false.obs;

  void onViewBtnTap() {
    showPwd.value = !showPwd.value;
    update();
  }

  Future<void> onContinueTapPassword() async {
    bool validation = inValid();
    update();
    pwdFocus.unfocus();
    if (validation) {
      myPref.pLogin.val = true;
      Get.offAll(() => const StartingProfileScreen(), binding: AppBinding());
    }
  }

  bool inValid() {
    if (pwdController.text == "") {
      pwdError.value = AppRes.enterPassword;
      return false;
    } else {
      return true;
    }
  }

  void onForgotPwdTapPassword() {
    debugPrint("onForgotPwdTapPassword clicked...");
  }
}
