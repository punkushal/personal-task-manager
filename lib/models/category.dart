class Category {
  final String? id;
  final String name;

  Category({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map, String documentId) {
    return Category(
      id: documentId,
      name: map['name'],
    );
  }
}
