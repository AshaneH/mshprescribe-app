import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mshprescribe_app/models/bookmark.dart';
import 'package:mshprescribe_app/services/storage_service.dart';
import 'package:mshprescribe_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  double progress = 0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<bool>(
            future: StorageService().isBookmarked(widget.url),
            builder: (context, snapshot) {
              final isBookmarked = snapshot.data ?? false;
              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (isBookmarked) {
                    await StorageService().removeBookmarkByUrl(widget.url);
                  } else {
                    await StorageService().addBookmark(
                      Bookmark(
                        title: widget.title,
                        url: widget.url,
                        dateAdded: DateTime.now(),
                      ),
                    );
                  }
                  setState(() {}); // Rebuild to update icon
                },
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'link_category') {
                _showLinkCategoryDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'link_category',
                  child: Row(
                    children: [
                      Icon(Icons.link, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Link Page to Category'),
                    ],
                  ),
                ),
              ];
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              sharedCookiesEnabled: true, // Critical for SSO
              javaScriptEnabled: true,
              domStorageEnabled: true,
              useShouldOverrideUrlLoading: true,
              cacheEnabled: true,
              cacheMode: CacheMode.LOAD_DEFAULT,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
            onProgressChanged: (controller, p) {
              setState(() {
                progress = p / 100;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;

              // Allow internal links
              if (uri.host.contains('mshprescribe.com') ||
                  uri.host.contains('health.qld.gov.au') || // Auth
                  uri.host.contains('microsoftonline.com')) {
                // Auth
                return NavigationActionPolicy.ALLOW;
              }

              // Launch external links in system browser
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (progress < 1.0)
            LinearProgressIndicator(
              value: progress,
              color: AppConstants.accentColor,
              backgroundColor: Colors.transparent,
            ),
        ],
      ),
    );
  }

  void _showLinkCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Link to Category'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppConstants.guidelineCategories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.guidelineCategories[index];
                return ListTile(
                  title: Text(category),
                  onTap: () async {
                    // Save current URL as the definitive link for this category
                    final currentUrl = (await webViewController?.getUrl())
                        ?.toString();
                    if (currentUrl != null) {
                      // Validation: Don't allow linking search pages
                      // Check for both standard and hash-based search patterns
                      if (currentUrl.contains('/#search/') ||
                          currentUrl.contains('?s=') ||
                          currentUrl.contains('/search/')) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Invalid Link'),
                              content: const Text(
                                'This looks like a search result page.\n\n'
                                'Please tap on the correct guideline to open it first, then try linking again.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                        return;
                      }

                      await StorageService().saveCategoryUrl(
                        category,
                        currentUrl,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Linked "$category" to this page'),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
