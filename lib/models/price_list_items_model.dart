const String tablePriceListItems = 'price_list_items';

Map<String, PriceListItem> userPriceItemsList = {};
Map<String, PriceListItem> standartPriceItemsList = {};

class PriceListItemFields {
  static final List<String> values = [
    id,
    lID,
    title,
    price,
    desc,
  ];

  static const String id = '_id';
  static const String lID = 'lID';
  static const String title = 'title';
  static const String price = 'price';
  static const String desc = 'desc';
}

class PriceListItem {
  final int? id;
  final int? lID;
  late String title;
  late int? price;
  late String? desc;

  PriceListItem({
    this.id,
    this.lID,
    required this.title,
    required this.price,
    required this.desc,
  });

  PriceListItem copy({
    int? id,
    int? lID,
    String? title,
    int? price,
    String? desc,
  }) =>
      PriceListItem(
        id: id ?? this.id,
        lID: lID ?? this.lID,
        title: title ?? this.title,
        price: price ?? this.price,
        desc: desc ?? this.desc,
      );

  static PriceListItem fromJson(Map<String, Object?> json) => PriceListItem(
        id: json[PriceListItemFields.id] as int?,
        lID: json[PriceListItemFields.lID] as int?,
        title: json[PriceListItemFields.title] as String,
        price: json[PriceListItemFields.price] as int,
        desc: json[PriceListItemFields.desc] as String,
      );

  Map<String, Object?> toJson() => {
        PriceListItemFields.id: id,
        PriceListItemFields.lID: lID,
        PriceListItemFields.title: title,
        PriceListItemFields.price: price,
        PriceListItemFields.desc: desc,
      };
}
