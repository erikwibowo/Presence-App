import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPasswordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPasswordC.text.isNotEmpty) {
      if (newPasswordC.text != "password") {
        try {
          await auth.currentUser!.updatePassword(newPasswordC.text);
          String email = auth.currentUser!.email!;
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: newPasswordC.text);
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          print(e.code);
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan",
                "Password terlalu lemah. Setidaknya 6 karakter",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 10,
                margin: EdgeInsets.all(10),
                snackStyle: SnackStyle.FLOATING);
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan",
              "Tidak mengubah password, silahkan hubungi admin/customer service",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        }
      } else {
        Get.snackbar("Terjadi Kesalahan",
            "Password tidak boleh sama dengan password lama",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            snackStyle: SnackStyle.FLOATING);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password baru harus diisi",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
    }
  }
}
