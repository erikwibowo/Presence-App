import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddPegawaiView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AddPegawaiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
