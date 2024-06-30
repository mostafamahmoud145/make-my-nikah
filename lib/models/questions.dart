class Questions {
  String id;
  String arQuestion;
  String enQuestion;
  int order;
  String link;
  bool status;
  List<dynamic>?categoryQuestionListIds;


  Questions({
    required this.id,
    required this.arQuestion,
    required this.enQuestion,
    this.categoryQuestionListIds,
    required this.order,
    required this.status,
    required this.link,
  });

  factory Questions.fromMap(Map  data){

    return Questions(
      id: data['id'],
      arQuestion: data['arQuestion'],
      enQuestion: data['enQuestion'],
      order: data['order'],
      status:data['status'],
      link:data['link'],
      categoryQuestionListIds:data['categoryQuestionListIds']??[],

    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'arQuestion': arQuestion,
      'enQuestion': enQuestion,
      'order': order,
      'status': status,
      'link': link,
      'categoryQuestionListIds': categoryQuestionListIds ?? [],
    };
  }
}


