import 'package:get/get.dart';

class RoutingController extends GetxController {
  var selectedIndex = 0.obs;

  final List<String> routes = [
    'login',
    'home',
  ];

  void changePage(int index) {
    selectedIndex.value = index;
    Get.offNamed(routes[index]);
  }
}