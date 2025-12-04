import 'dart:async';
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

        setState(() {
          foundCount = newFound;
          isCrawling = false;
        });
        _log('Crawl complete. Updated $newFound categories.');
      } else {
        _log('No links found or invalid result.');
        setState(() {
          isCrawling = false;
        });
      }
    } catch (e) {
      _log('Error executing script: $e');
      setState(() {
        isCrawling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Crawler'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black12,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Text(
                    logs[index],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 3,
            child: Stack(
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
    );
  }
}
