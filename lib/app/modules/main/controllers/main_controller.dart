import 'package:get/get.dart';

class MainController extends GetxController {
  var pageIndex = 0;

  void chanePage(int i) async {
    switch (i) {
      case 0:
        pageIndex = i;
        break;
      case 1:
        print("Absen");
        break;
      default:
        pageIndex = i;
    }
    update();
  }
}
