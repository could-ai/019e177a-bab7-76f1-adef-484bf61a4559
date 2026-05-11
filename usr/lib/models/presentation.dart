class Presentation {
  final String id;
  String title;
  String description;
  List<Slide> slides;
  DateTime updatedAt;

  Presentation({
    required this.id,
    required this.title,
    this.description = '',
    this.slides = const [],
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();
}

class Slide {
  final String id;
  String title;
  String content;
  SlideLayout layout;

  Slide({
    required this.id,
    this.title = 'หัวข้อสไลด์',
    this.content = '',
    this.layout = SlideLayout.titleAndBody,
  });
}

enum SlideLayout {
  titleOnly,
  titleAndBody,
  titleAndTwoColumns,
  blank,
}
