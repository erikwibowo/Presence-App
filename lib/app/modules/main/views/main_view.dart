import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/modules/home/views/home_view.dart';
import 'package:presence_app/app/modules/profile/views/profile_view.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.pageIndex,
            children: [
              HomeView(),
              Center(),
              ProfileView(),
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
            style: TabStyle.fixedCircle,
            items: [
              TabItem(icon: Icons.home, title: 'Home'),
              TabItem(icon: Icons.fingerprint, title: 'Add'),
              TabItem(icon: Icons.people, title: 'Profile'),
            ],
            initialActiveIndex: controller.pageIndex, //optional, default as 0
            onTap: (int i) => controller.chanePage(i),
          ),
        );
      },
    );
  }
}
