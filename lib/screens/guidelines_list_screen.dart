import 'package:flutter/material.dart';
import 'package:mshprescribe_app/screens/webview_screen.dart';
import 'package:mshprescribe_app/services/storage_service.dart';
import 'package:mshprescribe_app/utils/constants.dart';

class GuidelinesListScreen extends StatelessWidget {
  const GuidelinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guidelines'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: AppConstants.guidelineCategories.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final category = AppConstants.guidelineCategories[index];
          return ListTile(
            title: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () async {
              // 1. Check for user-defined override
              String? url = await StorageService().getCategoryUrl(category);

              // 2. If no override, use default logic (Search Fallback)
              if (url == null) {
                if (category == 'Calculators') {
                  url = '${AppConstants.baseUrl}/calculators';
                } else if (category == 'Useful links') {
                  url = '${AppConstants.baseUrl}/useful-links';
                } else {
                  // Search Fallback: /#search/[Category Name]
                  final query = Uri.encodeComponent(category);
                  url = '${AppConstants.baseUrl}/#search/$query';
                }
              }

              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebViewScreen(url: url!, title: category),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
