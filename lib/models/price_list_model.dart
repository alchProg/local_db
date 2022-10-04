const String tablePriceLists = 'price_lists';

int priceOfList = 0;

class PriceListFields {
  static final List<String> values = [
    id, pTitle, carType, title,
    price, desc, time,
  ];

  static const String id        = '_id'         ;
  static const String pTitle    = 'pTitle'      ;
  static const String carType   = 'car_type'    ;
  static const String title     = 'title'       ;
  static const String price     = 'price'       ;
  static const String desc      = 'desc'        ;
  static const String time      = 'createdTime' ;
}

class PriceList {
  final int? id           ;
  final String? pTitle    ;
  late  String? carType   ;
  late  String title      ;
  late  int? price        ;
  final String? desc      ;
  final String createdTime;

  PriceList({
    this.id,
    this.pTitle,
    required this.carType,
    required this.title,
    required this.price,
    this.desc,
    required this.createdTime,
  });

  PriceList copy({
    int? id,
    String? pTitle,
    String? carType,
    String? title,
    int? price,
    String? desc,
    String? createdTime,
  }) =>
      PriceList(
        id          : id          ?? this.id            ,
        pTitle      : pTitle      ?? this.pTitle        ,
        carType     : carType     ?? this.carType       ,
        title       : title       ?? this.title         ,
        price       : price       ?? this.price         ,
        desc        : desc        ?? this.desc          ,
        createdTime : createdTime ?? this.createdTime   ,
      );

  static PriceList fromJson(Map<String, Object?> json) =>  PriceList
    (
    id          : json[PriceListFields.id]      as int?     ,
    pTitle      : json[PriceListFields.pTitle]  as String   ,
    carType     : json[PriceListFields.carType] as String   ,
    title       : json[PriceListFields.title]   as String   ,
    price       : json[PriceListFields.price]   as int      ,
    desc        : json[PriceListFields.desc]    as String   ,
    createdTime : json[PriceListFields.time]    as String   ,
  );

  Map<String, Object?> toJson() => {
    PriceListFields.id        : id            ,
    PriceListFields.pTitle    : pTitle        ,
    PriceListFields.carType   : carType       ,
    PriceListFields.title     : title         ,
    PriceListFields.price     : price         ,
    PriceListFields.desc      : desc          ,
    PriceListFields.time      : createdTime   ,
  };

}