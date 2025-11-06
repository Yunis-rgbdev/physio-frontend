import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telewehab/utils/page_routing_controller.dart';
import 'package:telewehab/pages/auth/login_page.dart';
import 'package:telewehab/pages/auth/password_page.dart';
import 'package:telewehab/pages/auth/signup_page.dart';
import 'package:telewehab/pages/home.dart';
import 'package:telewehab/pages/operator/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // ✅ Initialize persistent storage
  runApp(PhiysioConnect());
}


class PhiysioConnect extends StatelessWidget {
  const PhiysioConnect({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhysioConnect',
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/login/password', page: () => PasswordView()),
        GetPage(name: '/auth/register', page: () => SignupView()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/operator', page: () => OperatorMainLayout()),
        // GetPage(name: "/fourth", page: () => Fourth()),
      ],
    );
  }   
}

class Home extends StatelessWidget {
  final controller = Get.put(RoutingController());

  final pages = [
    HomeView(),
    LoginView(),
    SignupView(),
    OperatorMainLayout()
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PhiysioConnect'),
        ),
        body: Obx( () => pages[controller.selectedIndex.value]),
      ),
    );
  }
}