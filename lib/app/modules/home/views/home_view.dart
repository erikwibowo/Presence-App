import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }
                String role = snapshot.data!.data()!["role"];
                if (role == "admin") {
                  // ini admin
                  return IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                controller.isLoading.value = true;
                FirebaseAuth.instance.signOut();
                Get.offAllNamed(Routes.LOGIN);
                controller.isLoading.value = false;
              }
            },
            child: controller.isLoading.isFalse
                ? Icon(Icons.logout)
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          )),
    );
  }
}
