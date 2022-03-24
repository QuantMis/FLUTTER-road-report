import 'package:flutter/material.dart';
import 'pothole_near_me.dart';

// custom theme
import 'package:awaslubang/theme/app_theme.dart';
import 'package:awaslubang/widgets/custom/navigation/custom_bottom_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;
  PageController? _pageController;

  // declare custom
  late NavigationTheme navigationTheme;
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    navigationTheme = NavigationTheme.getNavigationTheme();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            // NewsHomeScreen(),
            PotholeNearMeScreen(),
            // NewsVideoScreen(),
            PotholeNearMeScreen(),
            PotholeNearMeScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        animationDuration: Duration(milliseconds: 350),
        selectedItemOverlayColor: navigationTheme.selectedOverlayColor,
        backgroundColor: navigationTheme.backgroundColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <CustomBottomNavigationBarItem>[
          // CustomBottomNavigationBarItem(
          //     title: "Home",
          //     icon: Icon(MdiIcons.homeOutline, size: 22),
          //     activeIcon: Icon(MdiIcons.home, size: 22),
          //     activeColor: navigationTheme.selectedItemColor,
          //     inactiveColor: navigationTheme.unselectedItemColor),
          CustomBottomNavigationBarItem(
              title: "Nearby",
              icon: Icon(MdiIcons.bookmarkOutline, size: 22),
              activeIcon: Icon(MdiIcons.bookmark, size: 22),
              activeColor: navigationTheme.selectedItemColor,
              inactiveColor: navigationTheme.unselectedItemColor),
          CustomBottomNavigationBarItem(
              title: "Report",
              icon: Icon(
                MdiIcons.accountOutline,
                size: 22,
              ),
              activeIcon: Icon(
                MdiIcons.account,
                size: 22,
              ),
              activeColor: navigationTheme.selectedItemColor,
              inactiveColor: navigationTheme.unselectedItemColor),
          CustomBottomNavigationBarItem(
              title: "My Reports",
              icon: Icon(
                MdiIcons.accountOutline,
                size: 22,
              ),
              activeIcon: Icon(
                MdiIcons.account,
                size: 22,
              ),
              activeColor: navigationTheme.selectedItemColor,
              inactiveColor: navigationTheme.unselectedItemColor),
        ],
      ),
    );
  }
}
