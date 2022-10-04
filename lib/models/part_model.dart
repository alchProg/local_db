const String tableCarParts = 'parts';

Map<String,Part> selectedPartsList = {};

class PartFields {
  static final List<String> values = [
    id, pID, side, carType, title,
    price1, price2, price3, price4,
    desc1, desc2, desc3, desc4,
  ];

  static const String id        = '_id'       ;
  static const String pID       = 'pID'       ;
  static const String carType   = 'car_type'  ;
  static const String side      = 'side'      ;
  static const String title     = 'title'     ;
  static const String price1    = 'price1'    ;
  static const String price2    = 'price2'    ;
  static const String price3    = 'price3'    ;
  static const String price4    = 'price4'    ;
  static const String desc1     = 'desc1'     ;
  static const String desc2     = 'desc2'     ;
  static const String desc3     = 'desc3'     ;
  static const String desc4     = 'desc4'     ;
}

class Part {
  final int? id          ;
  final int? pID         ;
  late  String? carType  ;
  final String? side     ;
  late  String title     ;
  final int? price1      ;
  final int? price2      ;
  final int? price3      ;
  final int? price4      ;
  final String? desc1    ;
  final String? desc2    ;
  final String? desc3    ;
  final String? desc4    ;

  Part({
    this.id,
    this.pID,
    this.carType,
    this.side,
    required this.title,
    this.price1,
    this.price2,
    this.price3,
    this.price4,
    this.desc1,
    this.desc2,
    this.desc3,
    this.desc4,
  });

  Part copy({
    int? id,
    int? pID,
    String? carType,
    String? side,
    String? title,
    int? price1,
    int? price2,
    int? price3,
    int? price4,
    String? desc1,
    String? desc2,
    String? desc3,
    String? desc4,
  }) =>
      Part(
        id      : id        ?? this.id        ,
        pID     : pID       ?? this.pID       ,
        carType : carType   ?? this.carType   ,
        side    : side      ?? this.side      ,
        title   : title     ?? this.title     ,
        price1  : price1    ?? this.price1    ,
        price2  : price2    ?? this.price2    ,
        price3  : price3    ?? this.price3    ,
        price4  : price4    ?? this.price4    ,
        desc1   : desc1     ?? this.desc1     ,
        desc2   : desc2     ?? this.desc2     ,
        desc3   : desc3     ?? this.desc3     ,
        desc4   : desc4     ?? this.desc4     ,
      );

  static Part fromJson(Map<String, Object?> json) =>  Part
    (
    id      : json[PartFields.id]       as int?   ,
    pID     : json[PartFields.pID]      as int?   ,
    carType : json[PartFields.carType]  as String ,
    side    : json[PartFields.side]     as String ,
    title   : json[PartFields.title]    as String ,
    price1  : json[PartFields.price1]   as int    ,
    price2  : json[PartFields.price2]   as int    ,
    price3  : json[PartFields.price3]   as int    ,
    price4  : json[PartFields.price4]   as int    ,
    desc1   : json[PartFields.desc1]    as String ,
    desc2   : json[PartFields.desc2]    as String ,
    desc3   : json[PartFields.desc3]    as String ,
    desc4   : json[PartFields.desc4]    as String ,
  );

  Map<String, Object?> toJson() => {
    PartFields.id       : id        ,
    PartFields.pID      : pID       ,
    PartFields.carType  : carType   ,
    PartFields.side     : side      ,
    PartFields.title    : title     ,
    PartFields.price1   : price1    ,
    PartFields.price2   : price2    ,
    PartFields.price3   : price3    ,
    PartFields.price4   : price4    ,
    PartFields.desc1    : desc1     ,
    PartFields.desc2    : desc2     ,
    PartFields.desc3    : desc3     ,
    PartFields.desc4    : desc4     ,
  };
}
