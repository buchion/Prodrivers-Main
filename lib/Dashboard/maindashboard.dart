import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prodrivers/Authentication/prodriverssignin.dart';
import 'package:prodrivers/Dashboard/home.dart';
import 'package:prodrivers/Dashboard/profile.dart';
import 'package:prodrivers/Dashboard/request.dart';
import 'package:prodrivers/Driver/Driver.dart';
import 'package:prodrivers/Order/Order.dart';
import 'package:prodrivers/Trip/trip.dart';
import 'package:prodrivers/Truck/Truck.dart';

// import '../models/values/colors.dart';

class MainDashboard extends StatefulWidget {
  static const String routeName = '/maindashboard';

  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> with RouteAware {
  late AnimationController controller;
  Animation<double>? offsetAnimation;
  TabController? droidCtrl;
  CupertinoTabController? appleCtrl;

  int currentIndex = 0;
  int currentPlan = 0;
  int lastIndex = 0;

  final box = GetStorage();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    GET_USER_TYPE();
  }

  GET_USER_TYPE() async {
    box.write("userType", await _storage.read(key: 'userType'));
    setState(() {});
  }

  Widget get currentTab {
    switch (currentIndex) {
      case 0:
        return HomeView();
      case 1:
        return box.read("userType").toString() == "transporter"
            ? OrderView()
            : RequestView();
      case 2:
        return TripView();
      case 3:
        return box.read("userType").toString() == "transporter"
            ? Truck()
            : ProfileView();
      case 4:
        return box.read("userType").toString() == "transporter"
            ? DriverView()
            : ProfileView();
      default:
        return HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7D7D7),
      bottomNavigationBar: box.read("userType").toString() == "admin"
          ? AdminBottomTab(context)
          : box.read("userType").toString() == "transporter"
              ? TransporterBottomTab(context)
              : CargoOwnerBottomTab(context),
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: currentTab,
      ),
    );
  }

  Widget AdminBottomTab(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF263C91),
      // selectedItemColor: Color(0xFF192966),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      selectedFontSize: 15,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          activeIcon: Icon(
            Icons.dashboard_rounded,
            color: Colors.white,
            size: 40,
          ),
          icon: Icon(
            Icons.space_dashboard,
            color: Colors.blue,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: "Request",
          activeIcon: SvgPicture.asset('assets/icons/activerequest.svg'),
          icon: SvgPicture.asset(
            'assets/icons/request.svg',
            color: Colors.white,
          ),
        ),
        BottomNavigationBarItem(
          label: "Trip",
          activeIcon: SvgPicture.asset('assets/icons/activetrip.svg'),
          icon: SvgPicture.asset(
            'assets/icons/trips.svg',
            color: Colors.white,
          ),
        ),
        BottomNavigationBarItem(
          label: "Payment",
          activeIcon: SvgPicture.asset('assets/icons/activepayment.svg'),
          icon: SvgPicture.asset(
            'assets/icons/payment.svg',
            color: Colors.white,
          ),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: SvgPicture.asset(
            'assets/icons/profile.svg',
            color: Colors.white,
          ),
        ),
      ],
      onTap: onNavigate,
    );
  }

  Widget TransporterBottomTab(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF263C91),
      // selectedItemColor: Color(0xFF192966),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      // selectedFontSize: 17,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          activeIcon: Icon(
            Icons.dashboard_rounded,
            color: Colors.white,
            size: 40,
          ),
          icon: Icon(
            Icons.space_dashboard,
            color: Colors.blue,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: "Orders",
          activeIcon: Icon(
            Icons.format_list_numbered_rtl_rounded,
            color: Colors.white,
            size: 40,
          ),
          icon: Icon(
            Icons.library_books_rounded,
            color: Colors.blue,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: "Trip",
          activeIcon: Icon(
            Icons.add_location_alt_sharp,
            color: Colors.white,
            size: 40,
          ),
          icon: Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: "Truck",
          activeIcon: Icon(
            Icons.local_shipping_rounded,
            color: Colors.white,
            size: 40,
          ),
          icon: Icon(
            Icons.fire_truck_rounded,
            color: Colors.blue,
            size: 30,
          ),
        ),

        BottomNavigationBarItem(
          label: "Driver",
          activeIcon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 40,
          ),
          icon: Icon(
            Icons.person_pin,
            color: Colors.blue,
            size: 30,
          ),
        ),

        // BottomNavigationBarItem(
        //   label: "Profile",
        //   activeIcon: Icon(
        //     Icons.person_pin_rounded,
        //     color: Colors.white,
        //     size: 40,
        //   ),
        //   icon: Icon(
        //     Icons.person,
        //     color: Colors.blue,
        //     size: 30,
        //   ),
        // ),
      ],
      onTap: onNavigate,
    );
  }

  Widget CargoOwnerBottomTab(BuildContext context) {
    return   
      BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF263C91),
      // selectedItemColor: Color(0xFF192966),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      selectedFontSize: 14,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          activeIcon: Icon(
            Icons.dashboard_rounded,
            color: Colors.white,
            size: 30,
          ),
          icon: Icon(
            Icons.space_dashboard,
            color: Colors.blue,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: "Request",
          activeIcon: Icon(
            Icons.add_location,
            color: Colors.white,
            size: 30,
          ),
          icon: Icon(
            Icons.share_location_outlined,
            color: Colors.blue,
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: "Trip",
          activeIcon: Icon(
            Icons.add_location_alt_sharp,
            color: Colors.white,
            size: 30,
          ),
          icon: Icon(
            Icons.wifi_protected_setup_sharp,
            color: Colors.blue,
            size: 30,
          ),
        ),

        BottomNavigationBarItem(
          label: "Profile",
          activeIcon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 30,
          ),
          icon: Icon(
            Icons.person,
            color: Colors.blue,
            size: 30,
          ),
        ),
      ],
      onTap: onNavigate,
    );


  
  }

  onNavigate(int index) async {
    if (index == 5) {
      lastIndex = currentIndex;
      appleCtrl?.index = currentIndex;
    } else {
      if (index == 1 && currentIndex != 1) {
      } else if (index == 2 && currentIndex != 2) {}
      setState(
        () {
          if (appleCtrl?.index != currentIndex) {
            lastIndex = currentIndex;
          }
          appleCtrl?.index = index;
          currentIndex = index;
        },
      );
    }
  }
}
