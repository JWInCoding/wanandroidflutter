import 'package:flutter/material.dart';
import 'package:wanandroidflutter/module/home/home_page.dart';
import 'package:wanandroidflutter/module/mine/mine_page.dart';
import 'package:wanandroidflutter/module/project/project_page.dart';
import 'package:wanandroidflutter/module/tree/tree_page.dart';

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({super.key, required this.title});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  final List<String> _titles = ["首页", "项目", "体系", "我的"];
  final List<Widget> _navIcons = [
    const Icon(Icons.home),
    const Icon(Icons.category),
    const Icon(Icons.account_tree),
    const Icon(Icons.verified_user_rounded),
  ];

  final List<Widget> _pages = [
    const HomePage(),
    const ProjectPage(),
    const TreePage(),
    const MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // 获取当前主题色
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _generateBottomNavList(),
        iconSize: 24,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedItemIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
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
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
  }
}
