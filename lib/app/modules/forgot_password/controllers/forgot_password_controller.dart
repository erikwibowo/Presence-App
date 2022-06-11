import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendEmail() async {
    if (emailC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil",
            "Kami telah mengirimkan email untuk mereset password anda. Silahkan oeriksa inbox/spam email anda",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            snackStyle: SnackStyle.FLOATING);
        // Get.back();
      } on FirebaseAuthException catch (e) {
        // print(e.code);
        if (e.code == 'user-not-found') {
          Get.snackbar(
              "Terjadi kesalahan", "Email yang anda masukkan tidak terdaftar",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        } else {
          Get.snackbar("Terjadi kesalahan",
              "Terjadi kesalahan, silahkan coba lagi ${e.code}",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan",
            "Tidak dapat mengirim email reset password, silahkan coba lagi",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            snackStyle: SnackStyle.FLOATING);
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email tidak boleh kosong",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
    }
  }
}
