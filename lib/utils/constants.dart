import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'MSHPrescribe';
  static const String baseUrl = 'https://mshprescribe.com';
  
  // Colors
  static const Color primaryColor = Color(0xFF005EB8); // QH Blue roughly
  static const Color accentColor = Color(0xFF009688);
  
  // Guideline Categories
  static const List<String> guidelineCategories = [
    'Calculators', // Special handling
    'Useful links', // Special handling
    'COVID-19 Therapeutics',
    'Medical Emergencies',
    'Children\'s Health Queensland Clinical Documents & Guidelines',
    'Queensland Health Maternity and Neonatal Clinical Guidelines',
    'Qld Health Patient Safety Alerts and Advisories',
    'Guidelines for safe and effective prescribing',
    'Administration & legislative information',
    'Analgesia',
    'Antimicrobial Prescribing',
    'Blood and blood products',
    'Cardiovascular System',
    'Central Nervous System',
    'Clinical Pharmacology',
    'Endocrine System',
    'Eye, Ear, Nose & Throat Disorders',
    'Gastrointestinal System',
    'General Medicine',
    'Haematology and anticoagulation',
    'Immune System',
    'Mental Health',
    'Musculoskeletal and Joint Disease',
    'Palliative Care',
    'Respiratory',
    'Toxicology',
  ];

  // Drug Use in Surgery Sub-sections
  static const List<Map<String, String>> surgerySections = [
    {
      'title': 'Introduction to Drug Use in Surgery',
      'url': '/drug-use-in-surgery/introduction', // Verify URL pattern
      'isNew': 'true',
    },
    {
      'title': 'Perioperative Medication Guidelines',
      'url': '/drug-use-in-surgery/perioperative-medication-guidelines',
    },
    {
      'title': 'Procedure Specific Guidelines',
      'url': '/drug-use-in-surgery/procedure-specific-guidelines',
    },
    {
      'title': 'Postoperative Guidelines',
      'url': '/drug-use-in-surgery/postoperative-guidelines',
    },
  ];
  
  // Helper to get URL for category
  static String getUrlForCategory(String category) {
    if (category == 'Calculators') {
      return '$baseUrl/calculators'; // Verify URL
    } else if (category == 'Useful links') {
      return '$baseUrl/useful-links'; // Verify URL
    }
    // Standard pattern: /condition/[slug]
    // Need to convert "Cardiovascular System" to "cardiovascular-system"
    String slug = category.toLowerCase()
        .replaceAll(' & ', '-')
        .replaceAll(' ', '-')
        .replaceAll(',', '')
        .replaceAll("'", "");
    return '$baseUrl/condition/$slug';
  }
}
