class Bookmark {
  final int? id;
  final String title;
  final String url;
  final DateTime dateAdded;

  Bookmark({
    this.id,
    required this.title,
    required this.url,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      title: map['title'],
      url: map['url'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }
}
