const String tablePriceLists = 'price_lists';

class PriceListFields {
  static final List<String> values = [
    id,
    carType,
    title,
    price,
    desc,
    time,
    clientFullName,
    clientPhoneNumber,
    deadLineTime,
    isCompleted,
    isPaid,
  ];

  static const String id = '_id';
  static const String carType = 'car_type';
  static const String title = 'title';
  static const String price = 'price';
  static const String desc = 'desc';
  static const String time = 'createdTime';
  static const String clientFullName = 'clientFullName';
  static const String clientPhoneNumber = 'clientPhoneNumber';
  static const String deadLineTime = 'deadLineTime';
  static const String isCompleted = 'isCompleted';
  static const String isPaid = 'isPaid';
}

class PriceList {
  final int? id;
  late String? carType;
  late String title;
  late int? price;
  final String? desc;
  final String createdTime;
  final String? clientFullName;
  final String? clientPhoneNumber;
  final String? deadLineTime;
  final bool isCompleted;
  final bool isPaid;

  PriceList({
    this.clientFullName,
    this.clientPhoneNumber,
    this.deadLineTime,
    this.id,
    this.desc,
    required this.isCompleted,
    required this.isPaid,
    required this.carType,
    required this.title,
    required this.price,
    required this.createdTime,
  });

  PriceList copy({
    int? id,
    String? carType,
    String? title,
    int? price,
    String? desc,
    String? createdTime,
    String? clientFullName,
    String? clientPhoneNumber,
    String? deadLineTime,
    bool? isCompleted,
    bool? isPaid,
  }) =>
      PriceList(
        id: id ?? this.id,
        carType: carType ?? this.carType,
        title: title ?? this.title,
        price: price ?? this.price,
        desc: desc ?? this.desc,
        createdTime: createdTime ?? this.createdTime,
        clientFullName: clientFullName ?? this.clientFullName,
        clientPhoneNumber: clientPhoneNumber ?? this.clientPhoneNumber,
        deadLineTime: deadLineTime ?? this.deadLineTime,
        isCompleted: isCompleted ?? this.isCompleted,
        isPaid: isPaid ?? this.isPaid,
      );

  static PriceList fromJson(Map<String, Object?> json) => PriceList(
        id: json[PriceListFields.id] as int?,
        carType: json[PriceListFields.carType] as String,
        title: json[PriceListFields.title] as String,
        price: json[PriceListFields.price] as int,
        desc: json[PriceListFields.desc] as String,
        createdTime: json[PriceListFields.time] as String,
        clientFullName: json[PriceListFields.clientFullName] as String,
        clientPhoneNumber: json[PriceListFields.clientPhoneNumber] as String,
        deadLineTime: json[PriceListFields.deadLineTime] as String,
        isCompleted: json[PriceListFields.isCompleted] == 1,
        isPaid: json[PriceListFields.isPaid] == 1,
      );

  Map<String, Object?> toJson() => {
        PriceListFields.id: id,
        PriceListFields.carType: carType,
        PriceListFields.title: title,
        PriceListFields.price: price,
        PriceListFields.desc: desc,
        PriceListFields.time: createdTime,
        PriceListFields.clientFullName: clientFullName,
        PriceListFields.clientPhoneNumber: clientPhoneNumber,
        PriceListFields.deadLineTime: deadLineTime,
        PriceListFields.isCompleted: isCompleted ? 1 : 0,
        PriceListFields.isPaid: isPaid ? 1 : 0,
      };
}
