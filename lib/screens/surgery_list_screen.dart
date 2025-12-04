import 'package:flutter/material.dart';
import 'package:mshprescribe_app/screens/webview_screen.dart';
import 'package:mshprescribe_app/utils/constants.dart';

class SurgeryListScreen extends StatelessWidget {
  const SurgeryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drug Use in Surgery'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: AppConstants.surgerySections.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final section = AppConstants.surgerySections[index];
          final title = section['title']!;
          final urlSuffix = section['url']!;
          final isNew = section['isNew'] == 'true';

          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                if (isNew)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              final url = '${AppConstants.baseUrl}$urlSuffix';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(url: url, title: title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
