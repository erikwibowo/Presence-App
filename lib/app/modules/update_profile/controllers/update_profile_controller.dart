import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image!.name);
      print(image!.name.split(".").last);
      print(image!.path);
    } else {
      print(image);
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          'nip': nipC.text,
        };
        if (image != null) {
          //proses upload image ke storage
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          await storage.ref("$uid/profile.$ext").putFile(file);
          String urlImage =
              await storage.ref("$uid/profile.$ext").getDownloadURL();

          data.addAll({
            "profile": urlImage,
          });
        }
        await firestore.collection("pegawai").doc(uid).update(data);
        Get.back();
        Get.snackbar(
          "Berhasil",
          "Berhasil mengupdate profile",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      } on FirebaseException catch (e) {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Gagal mengupdate profile. ${e.message}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      } catch (e) {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Gagal mengupdate profile. ${e}",
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
        "Terjadi Kesalahan",
        "Mohon isi data dengan lengkap",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    }
  }
}
