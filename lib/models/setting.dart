
class Setting {
  String settingId;
  String firstTitleAr;
  String firstTitleEn;
  
 dynamic androidVersion;
 dynamic androidBuildNumber;
  dynamic iosVersion;
  dynamic iosBuildNumber;
  dynamic taxes;
  dynamic coachTaxes;
  bool inAppleReview;
  String authType;
  bool consultSignupWithEmail;
  bool userSignupPop;

  Setting({
    required this.settingId,
    required this.firstTitleAr,
    required this.firstTitleEn,
    required this.authType,
    this.androidVersion,
    this.androidBuildNumber,
    this.iosVersion,
    this.iosBuildNumber,
    this.taxes,
    this.coachTaxes,
    required this.inAppleReview,
    required this.userSignupPop,
    required this.consultSignupWithEmail


  });

  factory Setting.fromMap(Map data) {
    
    return Setting(
      settingId: data['settingId'],
      firstTitleAr: data['firstTitleAr'],
      firstTitleEn: data['firstTitleEn'],
      androidVersion: data['androidVersion'],
      androidBuildNumber: data['androidBuildNumber'],
      iosVersion: data['iosVersion'],
      iosBuildNumber: data['iosBuildNumber'],
      taxes: data['taxes'],
      coachTaxes:data['coachTaxes'],
      inAppleReview:data["inAppleReview"],
      authType: data['authType'],
      userSignupPop: data['userSignupPop'],
      consultSignupWithEmail: data['consultSignupWithEmail']
    );
  }
}


