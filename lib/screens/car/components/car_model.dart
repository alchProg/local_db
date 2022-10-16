const String tableCars = 'carTypes';

class CarFields {
  static final List<String> values = [
    id, pID, title, isGlobal,
  ];

  static const String id        = '_id'       ;
  static const String pID       = 'pID'       ;
  static const String title     = 'title'     ;
  static const String isGlobal  = 'isGlobal'  ;
}

class Car {
  final int? id         ;
  final int? pID        ;
  final String title    ;
  final bool isGlobal   ;

  Car({
    this.id,
    this.pID,
    required this.title,
    required this.isGlobal,
  });

  Car copy({
    int? id,
    int? pID,
    String? title,
    bool? isGlobal,
  }) =>
      Car(
        id        : id        ?? this.id        ,
        pID       : pID       ?? this.pID       ,
        title     : title     ?? this.title     ,
        isGlobal  : isGlobal  ?? this.isGlobal  ,
      );

  static Car fromJson(Map<String, Object?> json) =>  Car
    (
    id          : json[CarFields.id]        as int?   ,
    pID         : json[CarFields.pID]       as int?   ,
    title       : json[CarFields.title]     as String ,
    isGlobal    : json[CarFields.isGlobal] == 1       ,
  );

  Map<String, Object?> toJson() => {
    CarFields.id       : id                 ,
    CarFields.pID      : pID                ,
    CarFields.title    : title              ,
    CarFields.isGlobal : isGlobal ? 1 : 0   ,
  };
}