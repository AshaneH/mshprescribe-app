import 'package:flutter/material.dart';
import 'package:mshprescribe_app/screens/webview_screen.dart';
import 'package:mshprescribe_app/utils/constants.dart';

class WebSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Navigate to WebView with search query
    // Using the hash-based search format provided by user
    final searchUrl = '${AppConstants.baseUrl}/#search/$query';

    // Use Future.microtask to navigate after the build phase
    Future.microtask(() {
      if (context.mounted) {
        close(context, null);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WebViewScreen(url: searchUrl, title: 'Search: $query'),
          ),
        );
      }
    });

    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // No suggestions for now
  }
}
