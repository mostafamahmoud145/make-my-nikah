import 'order.dart';

/// Room model
class Room {
   String roomId;
   String title;
   List<UserDetails>? users;
   int? speakerCount;
   String utcTime;
  Room({
    required this.title,
    this.users,
    this.speakerCount,
    required this.utcTime,
    required this.roomId
  });

  factory Room.fromJson(json) {
    return Room(
      title: json['title'],
      users: json['users'].map<UserDetails>((users) {
        return users(
            name: users['name'],
            uid: users['uid'],
            image: users['image'],
            phone:users['phone'],
            countryCode: users['countryCode'],
            countryISOCode:users['countryISOCode']
        );
      }).toList(),
      speakerCount: json['speakerCount'],
      utcTime: json['utcTime'],
      roomId: json['roomId'],
    );
  }
}

/// users model
