import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firesotre = FirebaseFirestore.instance;

  Future<void> proses() async {
    isLoading.value = true;
    isLoadingAddPegawai.value = true;
    if (passwordAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;
        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passwordAdminC.text,
        );
        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;
          await firesotre.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "role": "pegawai",
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });
          await pegawaiCredential.user!.sendEmailVerification();
          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passwordAdminC.text,
          );

          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Pegawai berhasil ditambahkan",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang anda masukkan terlalu lemah",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "Pegawai dengan email yang anda masukkan sudah terdaftar",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password yang anda masukkan salah",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        } else {
          Get.snackbar("Terjadi Kesalahan", "${e.code}",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackStyle: SnackStyle.FLOATING);
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan",
            "Tidak dapat menambahkan pegawai, silahkan coba lagi",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            snackStyle: SnackStyle.FLOATING);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password tidak boleh kosong",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
    }
    isLoading.value = false;
    isLoadingAddPegawai.value = false;
  }

  Future<void> addPegawai() async {
    if (nipC.text.isNotEmpty ||
        nameC.text.isNotEmpty ||
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
        titlePadding: EdgeInsets.only(top: 20),
        contentPadding: EdgeInsets.all(20),
        title: "Validasi Admin",
        content: Column(
          children: [
            Text("Ketikkan password admin untuk melanjutkan"),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              autocorrect: false,
              controller: passwordAdminC,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: Text("CANCEL"),
          ),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddPegawai.isFalse) {
                    await proses();
                  }
                },
                child: Text(
                    isLoadingAddPegawai.isFalse ? "CONTINUE" : "LOADING..."),
              )),
        ],
      );
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, Name, Email tidak boleh kosong",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING);
    }
  }
}
