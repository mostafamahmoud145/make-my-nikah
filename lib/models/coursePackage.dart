class CoursePackage {
  String id;
  dynamic price;
  dynamic discount;
  bool active;

  CoursePackage({
    required this.id,
    this.price,
    this.discount,
    required this.active,
  });
  factory CoursePackage.fromMap(Map data) {
    return CoursePackage(
      id: data['Id'],
      price: data['price'],
      discount: data['discount'],
      active: data['active'],
    );
  }
  factory CoursePackage.fromHashMap(Map<String, dynamic> review) {
    return CoursePackage(
      id: review['Id'],
      discount: review['discount'],
      price: review['price'],
      active: review['active'],
    );
  }
}
