class FontNote {
  final int? id;
  final String name;
  final String usage;
  final String? tags;
  final String date;
  final bool isFavorite;

  FontNote({
    this.id,
    required this.name,
    required this.usage,
    this.tags,
    required this.date,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'usage': usage,
      'tags': tags,
      'date': date,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory FontNote.fromMap(Map<String, dynamic> map) {
    return FontNote(
      id: map['id'],
      name: map['name'],
      usage: map['usage'],
      tags: map['tags'],
      date: map['date'],
      isFavorite: (map['isFavorite'] ?? 0) == 1,
    );
  }
}
