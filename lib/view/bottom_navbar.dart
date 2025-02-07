import 'package:dio_contact/view/screen/home.dart';
import 'package:dio_contact/view/screen/home_page.dart';
import 'package:dio_contact/view/screen/add_fish.dart';
import 'package:dio_contact/view/screen/list_betta.dart';
import 'package:flutter/material.dart';

class DynamicBottomNavbar extends StatefulWidget {
  const DynamicBottomNavbar({Key? key}) : super(key: key);

  @override
  State<DynamicBottomNavbar> createState() => _DynamicBottomNavbarState();
}

class _DynamicBottomNavbarState extends State<DynamicBottomNavbar> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    const MyHome(),
    const FishFormScreen(),
    FishListScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPageIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Input Fish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'List Fish',
          ),
        ],
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
