class OnBoardingModel {
  String title;
  String body;
  String image;
  OnBoardingModel({
    required this.title,
    required this.body,
    required this.image,
  });

  OnBoardingModel.fromJson(Map<String, dynamic> data)
      : title = data['title'],
        body = data['body'],
        image = data['image'];
}
