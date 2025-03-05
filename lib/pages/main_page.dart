import 'package:flutter/material.dart';
import 'package:wanandroidflutter/pages/tab_page/home_page.dart';
import 'package:wanandroidflutter/pages/tab_page/mine_page.dart';
import 'package:wanandroidflutter/pages/tab_page/plaza_page.dart';
import 'package:wanandroidflutter/pages/tab_page/project_page.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({super.key, required this.title});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;

  String _currentTitle = "首页";

  final PageController _pageController = PageController(initialPage: 0);

  final List<String> _titles = ["首页", "项目", "广场", "我的"];
  final List<Widget> _navIcons = [
    const Icon(Icons.home),
    const Icon(Icons.ac_unit),
    const Icon(Icons.animation),
    const Icon(Icons.verified_user_rounded),
  ];

  final List<Widget> _pages = [
    const HomePage(),
    const ProjectPage(),
    const PlazaPage(),
    const MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(_currentTitle, style: const TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Wanlog.i("跳转搜索");
            },
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: '搜索',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _generateBottomNavList(),
        iconSize: 24,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedItemIndex,
        onTap: _onNavItemTapped,
      ),
      body: PageView.builder(
        itemBuilder: (context, index) {
          return _pages[index];
        },
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChanged,
        controller: _pageController,
      ),
    );
  }

  List<BottomNavigationBarItem> _generateBottomNavList() {
    return List.generate(_titles.length, (index) {
      return BottomNavigationBarItem(
        icon: _navIcons[index],
        label: _titles[index],
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedItemIndex = index;
      _currentTitle = _titles[index];
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
  }
}
