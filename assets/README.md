# Category URL Mappings

This directory contains discovered URL mappings for guideline categories.

## How to Use

### First-Time Setup
1. Run the app and use the crawler: Menu → "Developer: Crawl Site"
2. Copy the JSON output from the console/logs
3. Save it to `assets/category_urls.json`
4. Rebuild the app - URLs will load automatically

### Manual Updates
If a URL changes:
1. Run crawler again, OR
2. Manually edit `category_urls.json`
3. Rebuild app

## Format

```json
{
  "crawled_at": "2025-12-04T13:40:00.000Z",
  "categories": {
    "Analgesia": "https://mshprescribe.com/analgesia",
    "Antimicrobials": "https://mshprescribe.com/antimicrobials",
    ...
  }
}
```

## Notes

- This file is checked into Git
- Future builds won't need to run crawler
- Users can still manually link categories if needed
