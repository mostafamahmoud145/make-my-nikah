class CategoryQuestion {
  final String id;
  final String titleEn;
  final String titleAr;

  CategoryQuestion({
    required this.id,
    required this.titleEn,
    required this.titleAr,
  });

  factory CategoryQuestion.fromMap(Map<String, dynamic> map) {
    return CategoryQuestion(
      id: map['id'] ?? '',
      titleEn: map['titleEn'] ?? '',
      titleAr: map['titleAr'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleAr': titleAr,
    };
  }
}
