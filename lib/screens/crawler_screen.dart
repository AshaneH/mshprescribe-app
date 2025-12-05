import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mshprescribe_app/services/storage_service.dart';
import 'package:mshprescribe_app/utils/constants.dart';

class CrawlerScreen extends StatefulWidget {
  const CrawlerScreen({super.key});

  @override
  State<CrawlerScreen> createState() => _CrawlerScreenState();
}

class _CrawlerScreenState extends State<CrawlerScreen> {
  InAppWebViewController? webViewController;
  double progress = 0;
  List<String> logs = [];
  bool isCrawling = false;
  int foundCount = 0;

  @override
  void initState() {
    super.initState();
    _startCrawl();
  }

  void _log(String message) {
    setState(() {
      logs.add(
        '${DateTime.now().toString().split(' ')[1].split('.')[0]} - $message',
      );
    });
  }

  Future<void> _startCrawl() async {
    setState(() {
      isCrawling = true;
      logs.clear();
      foundCount = 0;
    });
    _log('Starting crawl...');
    _log('Waiting for WebView to initialize...');
  }

  Future<void> _runExtraction() async {
    if (webViewController == null) return;

    _log('Injecting extraction script...');

    // Pass categories to JS
    final categoriesJson = AppConstants.guidelineCategories
        .map((e) => '"$e"')
        .toList()
        .join(',');

    final jsCode =
        '''
      (function() {
        const categories = [$categoriesJson];
        const results = {};
        const links = document.querySelectorAll('a');
        let count = 0;
        
        links.forEach(a => {
          const text = a.innerText.trim();
          const href = a.href;
          
          if (categories.includes(text) && href) {
             // Clean URL: remove query params
             const cleanUrl = href.split('?')[0];
             // Also remove hash if present, unless it's a hash-only nav (unlikely for main pages)
             // User requested "part before question mark"
             
             results[text] = cleanUrl;
             count++;
          }
        });
        return results;
      })();
    ''';

    try {
      final result = await webViewController!.evaluateJavascript(
        source: jsCode,
      );

      if (result != null && result is Map) {
        _log('Found ${result.length} matching links.');

        int newFound = 0;
        for (var entry in result.entries) {
          final category = entry.key;
          final url = entry.value;

          _log('Saving: $category -> $url');
          await StorageService().saveCategoryUrl(category, url);
          newFound++;
        }
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(AppConstants.baseUrl),
                  ),
                  initialSettings: InAppWebViewSettings(
                    sharedCookiesEnabled: true,
                    javaScriptEnabled: true,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStop: (controller, url) async {
                    _log('Page loaded: $url');
                    // Wait a moment for dynamic content
                    await Future.delayed(const Duration(seconds: 2));
                    await _runExtraction();
                  },
                  onProgressChanged: (controller, p) {
                    setState(() {
                      progress = p / 100;
                    });
                  },
                ),
                // Overlay to prevent interaction but show it's working
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Scanning website...',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
  }
}
