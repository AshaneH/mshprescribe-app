import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mshprescribe_app/screens/bookmarks_screen.dart';
import 'package:mshprescribe_app/screens/crawler_screen.dart';
import 'package:mshprescribe_app/screens/guidelines_list_screen.dart';
import 'package:mshprescribe_app/screens/surgery_list_screen.dart';
import 'package:mshprescribe_app/screens/web_search_delegate.dart';
import 'package:mshprescribe_app/screens/webview_screen.dart';
import 'package:mshprescribe_app/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const GuidelinesListScreen(),
    const SurgeryListScreen(),
    // Updates - loads webview directly
    const WebViewScreen(
      url: '${AppConstants.baseUrl}/updates',
      title: 'Updates',
    ),
    // Feedback - loads webview directly
    const WebViewScreen(
      url: '${AppConstants.baseUrl}/feedback',
      title: 'Feedback',
    ),
    // Bookmarks - native screen
    const BookmarksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: WebSearchDelegate());
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                final cookieManager = CookieManager.instance();
                await cookieManager.deleteAllCookies();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out. Please sign in again.'),
                    ),
                  );
                }
              } else if (value == 'crawl') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CrawlerScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout / Clear Cache'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'crawl',
                  child: Text('Developer: Crawl Site'),
                ),
              ];
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Guidelines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Surgery',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Updates'),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
