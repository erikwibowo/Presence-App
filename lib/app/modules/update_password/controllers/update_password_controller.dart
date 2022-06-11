import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currentPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updatePassword() async {
    if (currentPasswordC.text.isNotEmpty &&
        newPasswordC.text.isNotEmpty &&
        confirmPasswordC.text.isNotEmpty) {
      if (newPasswordC.text == confirmPasswordC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currentPasswordC.text);

          await auth.currentUser!.updatePassword(newPasswordC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: newPasswordC.text);
          Get.back();
          Get.snackbar(
            "Berhasil",
            "Berhasil mengupdate password",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 2),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar(
              "Terjadi Kesalahan",
              "Password lama salah",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 2),
            );
          } else {
            Get.snackbar(
              "Terjadi Kesalahan",
              "Gagal mengupdate password. ${e.message}",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 2),
            );
          }
        } catch (e) {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Gagal mengupdate password. ${e}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 2),
          );
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
            'Error', 'New Password and Confirm Password does not match',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            borderColor: Colors.red,
            borderWidth: 2);
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Gagal mengupdate password. Mohon isi semua field",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    }
  }
}
