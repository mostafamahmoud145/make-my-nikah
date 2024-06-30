

class SupportAnalysis {
  dynamic time;
  dynamic techSupportUser;

  SupportAnalysis({
    this.time,
    this.techSupportUser,


  });

  factory SupportAnalysis.fromMap(Map data) {
    
    return SupportAnalysis(
      time: data['time'],
      techSupportUser: data['price'],
    );
  }
}


