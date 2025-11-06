import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'dashboard_page.dart';
import 'patient_page.dart';
import 'appointments_page.dart';
import 'statistics_page.dart';
import 'messages_page.dart';
import 'management_page.dart';
import 'tools_page.dart';
import 'settings_page.dart';

class ResponsiveHelper {
  final double screenWidth;
  ResponsiveHelper(this.screenWidth);

  bool get isDesktop => screenWidth > 800;
  double get headerSize => (screenWidth * 0.06).clamp(16.0, 48.0);
  double get header2Size => (screenWidth * 0.05).clamp(12.0, 32.0);
  double get commentSize => (screenWidth * 0.03).clamp(12.0, 24.0);
  double get paragraphSize => (screenWidth * 0.02).clamp(14.0, 18.0);
  double get inputSize => (screenWidth * 0.3).clamp(350.0, 400.0);
  double get buttonSize => (screenWidth * 0.3).clamp(350.0, 400.0);
}

class OperatorMainLayout extends StatelessWidget {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  final RxInt currentIndex = 0.obs;
  
  

  final pages = [
    DashboardPage(),
    PatientsPage(),
    AppointmentsPage(),
    StatisticsPage(),
    MessagesPage(),
    ManagementPage(),
    ToolsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    
    // Listen to controller changes
    _controller.addListener(() {
      currentIndex.value = _controller.selectedIndex;
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _key,
        appBar: _buildAppBar(context),
        drawer: MediaQuery.of(context).size.width < 1024 
            ? Drawer(child: _buildSidebar()) 
            : null,
        body: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 1024) _buildSidebar(),
            Expanded(
              child: Container(
                color: Color(0xFFF5F7FA),
                child: Obx(() => pages[currentIndex.value]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop;
    if (screenWidth > 720) {
      isDesktop = true;
    } else {
      isDesktop = false;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: MediaQuery.of(context).size.width < 1024
          ? IconButton(
              icon: Icon(Icons.menu, color: Colors.black87),
              onPressed: () => _key.currentState?.openDrawer(),
            )
          : null,
      automaticallyImplyLeading: MediaQuery.of(context).size.width < 1024,
      title: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 1024)
            Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF3E68FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              if (isDesktop) ...[
                SizedBox(width: 12),
                Text(
                  'SCAIL HEALTH',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 18.0),
        SizedBox(
                  // height: 65,
                  // width: isDesktop ? 200 : 100,
                    child: TextFormField(
                        // onChanged: (value) => loginController.nationalCode.value = value,
                        // validator: loginController.validateNationalCode,
                        // controller: loginController.nationalCodeController,
                        decoration: InputDecoration(
                          // labelText: 'جستجو',
                          constraints: BoxConstraints.expand(height: isDesktop ? 40 : 40, width: isDesktop ? 250 : 170),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          floatingLabelStyle: PersianFonts.Shabnam.copyWith(
                            color: Color.fromRGBO(62, 104, 255, 1), 
                            fontWeight: FontWeight.bold, 
                            fontSize: 18,
                          ),
                          hintText: 'جستجو',
                          hintStyle: PersianFonts.Shabnam.copyWith(color: Colors.black26, fontSize: 16),
                          labelStyle: PersianFonts.Shabnam.copyWith(color: Colors.black26),
                          contentPadding: EdgeInsets.symmetric( horizontal: 16),
                          suffixIcon: Icon(Icons.search),
                          suffixIconColor: Colors.black26,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                          focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                          
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.red, width: 1)
                        ),
                        errorStyle: PersianFonts.Shabnam.copyWith(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color.fromRGBO(62, 104, 255, 1), width: 1)
                        ),
                      ),
                  ),
                ),
            
            
        ],
      ),
      actions: [
        isDesktop ?
        Align(
          alignment: Alignment.center,
          child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.black87, size: 18),
                    SizedBox(width: 8),
                    Text('${Jalali.now().year}/${Jalali.now().month}/${Jalali.now().day}', style: TextStyle(fontSize: 14, color: Colors.black87),),
                    // Text(
                    //   'شنبه، ۲۲ ژانویه ۲۰۲۲ ۱۹:۱۶',
                    //   style: PersianFonts.Vazir.copyWith(
                    //     fontSize: 14,
                    //     color: Colors.black54,
                    //   ),
                    // ),
                  ],
                ),
              ),
        ) : SizedBox(),
        
        SizedBox(width: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'لوکاس دیویدسون',
                    style: PersianFonts.Vazir.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.person, color: Colors.blue[700]),
              ),
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: () {
                  
                },
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: PersianFonts.Vazir.copyWith(
          color: Colors.black54,
          fontSize: 14,
        ),
        selectedTextStyle: PersianFonts.Vazir.copyWith(
          color: Color(0xFF3E68FF),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        itemTextPadding: EdgeInsets.only(right: 20),
        selectedItemTextPadding: EdgeInsets.only(right: 20),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.transparent),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF3E68FF).withOpacity(0.1),
        ),
        iconTheme: IconThemeData(
          color: Colors.black54,
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: Color(0xFF3E68FF),
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 240,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
      // headerBuilder: (context, extended) {
      //   return ;
      // },
      items: [
        SidebarXItem(
          icon: Icons.dashboard_outlined,
          label: 'داشبورد',
          onTap: () {
            _controller.selectIndex(0);
            currentIndex.value = 0;
          },
        ),
        SidebarXItem(
          icon: Icons.people_outline,
          label: 'لیست بیماران',
          onTap: () {
            _controller.selectIndex(1);
            currentIndex.value = 1;
          },
        ),
        SidebarXItem(
          icon: Icons.calendar_today_outlined,
          label: 'نوبت‌ها',
          onTap: () {
            _controller.selectIndex(2);
            currentIndex.value = 2;
          },
        ),
        SidebarXItem(
          icon: Icons.bar_chart_outlined,
          label: 'آمار',
          onTap: () {
            _controller.selectIndex(3);
            currentIndex.value = 3;
          },
        ),
        SidebarXItem(
          icon: Icons.mail_outline,
          label: 'پیام‌ها',
          onTap: () {
            _controller.selectIndex(4);
            currentIndex.value = 4;
          },
        ),
        SidebarXItem(
          icon: Icons.admin_panel_settings_outlined,
          label: 'مدیریت',
          onTap: () {
            _controller.selectIndex(5);
            currentIndex.value = 5;
          },
        ),
        SidebarXItem(
          icon: Icons.build_outlined,
          label: 'ابزارها',
          onTap: () {
            _controller.selectIndex(6);
            currentIndex.value = 6;
          },
        ),
        SidebarXItem(
          icon: Icons.settings_outlined,
          label: 'تنظیمات',
          onTap: () {
            _controller.selectIndex(7);
            currentIndex.value = 7;
          },
        ),
      ],
      footerBuilder: (context, extended) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Divider(),
              SizedBox(height: 8),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.black54, size: 20),
                    if (extended) ...[
                      SizedBox(width: 20),
                      Text(
                        'راهنما',
                        style: PersianFonts.Vazir.copyWith(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // SizedBox(height: 16),
              // Container(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Color(0xFF3E68FF),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       padding: EdgeInsets.symmetric(vertical: 12),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.arrow_back, size: 16),
              //         if (extended) SizedBox(width: 8),
              //         if (extended)
              //           Text(
              //             'بستن',
              //             style: PersianFonts.Vazir.copyWith(fontSize: 14),
              //           ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}