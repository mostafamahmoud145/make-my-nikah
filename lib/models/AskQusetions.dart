


class AskQuestions {
  String id;
  String arQuestion;
  String enQuestion;
  String arAnswer;
  String enAnswer;
  int order;
  String? link;
  bool status;
  List<dynamic> searchIndexAr;
  List<dynamic> searchIndexEn;

  AskQuestions({
    required this.id,
    required this.arQuestion,
    required this.enQuestion,
    required this.arAnswer,
    required this.enAnswer,
    required this.order,
    required this.status,
    this.link,
    required this.searchIndexAr,
    required this.searchIndexEn,
  });

  factory AskQuestions.fromMap(Map  data) {

    return AskQuestions(
      id: data['id'],
      arQuestion: data['arQuestion'],
      enQuestion: data['enQuestion'],
      arAnswer: data['arAnswer'],
      enAnswer: data['enAnswer'],
      order: data['order'],
      status:data['status'],
      link:data['link'],
      searchIndexEn:data['searchIndexEn'],
      searchIndexAr:data['searchIndexAr'],
      
    );
  }
}


