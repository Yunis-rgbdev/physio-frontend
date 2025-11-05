import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:get/get.dart';

import 'dashboard_page.dart';
import 'patient_page.dart';
import 'profile_page.dart';

class OperatorMainLayout extends StatelessWidget {
  final controller = SidebarXController(selectedIndex: 0);
  
  final pages = [
    DashboardPage(),
    PatientsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Scaffold(
          appBar: AppBar(title: Text('Operator Dashboard')),
          drawer: isDesktop ? null : Drawer(child: SidebarX(controller: controller)),
          body: Row(
            children: [
              if (isDesktop)
                SidebarX(controller: controller),
              Expanded(child: Obx(() => pages[controller.selectedIndex])),
            ],
          ),
        );
      },
    );
  }
}
