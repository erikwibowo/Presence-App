import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified) {
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: "Verifikasi Email",
                middleText:
                    "Email anda belum terverifikasi. Silahkan verifikasi email anda terlebih dahulu",
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text("CANCEL"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await userCredential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar("Berhasil",
                            "Email verifikasi berhasil dikirim. Silahkan periksa email anda",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            borderRadius: 10,
                            margin: EdgeInsets.all(10),
                            snackStyle: SnackStyle.FLOATING);
                      } catch (e) {
                        Get.snackbar("Terjadi Kesalahan",
                            "Email verifikasi gagal dikirim. Hubungi admin/customer service",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            borderRadius: 10,
                            margin: EdgeInsets.all(10),
                            snackStyle: SnackStyle.FLOATING);
                      }
                    },
                    child: Text("KIRIM ULANG"),
                  ),
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password yang anda masukkan salah",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        } else if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai dengan email yang anda masukkan tidak terdaftar",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        }
      } catch (e) {
        Get.snackbar(
            "Terjadi Kesalahan", "Tidak dapat login, silahkan coba lagi",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            snackStyle: SnackStyle.FLOATING);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password tidak boleh kosong",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
    }
  }
}
