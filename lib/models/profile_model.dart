
const String tableProfiles = "profiles";

class ProfileFields {
  static final List<String> values = [
    id, title, description, time,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'createdTime';
}

class Profile {

  final int? id;
  final String title;
  final String? description;
  final String createdTime;

  Profile({
    this.id,
    required this.title,
    this.description,
    required this.createdTime});

  Profile copy({
    int?      id,
    String?   title,
    String?   description,
    String? createdTime,
  }) =>
      Profile(
        id:           id          ?? this.id          ,
        title:        title       ?? this.title       ,
        description:  description ?? this.description ,
        createdTime:  createdTime ?? this.createdTime ,
      );

  static Profile fromJson(Map<String, Object?> json) =>  Profile
    (
    id            : json[ProfileFields.id]            as int?   ,
    title         : json[ProfileFields.title]         as String ,
    description   : json[ProfileFields.description]   as String ,
    createdTime   : json[ProfileFields.time]          as String ,
  );

  Map<String, Object?> toJson() => {
    ProfileFields.id            : id            ,
    ProfileFields.title         : title         ,
    ProfileFields.description   : description   ,
    ProfileFields.time          : createdTime   ,
  };

}

