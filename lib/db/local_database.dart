import 'package:local_db/models/normal_parts_lib.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/car_model.dart';
import '../models/price_list_items_model.dart';
import '../models/price_list_model.dart';
import '../models/profile_model.dart';
import '../models/part_model.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();

  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('localDB.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const pIDType = 'INTEGER';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableProfiles(
  ${ProfileFields.id} $idType, 
  ${ProfileFields.title} $textType,
  ${ProfileFields.description} $textType,
  ${ProfileFields.time} $textType
  )
''');

    await db.execute('''
CREATE TABLE $tableCars(
  ${CarFields.id} $idType, 
  ${CarFields.pID} $pIDType,
  ${CarFields.title} $textType,
  ${CarFields.isGlobal} $boolType
  )
''');

    await db.execute('''
CREATE TABLE $tableCarParts(
  ${PartFields.id} $idType,
  ${PartFields.pID} $pIDType,
  ${PartFields.carType} $textType,
  ${PartFields.side} $textType,
  ${PartFields.title} $textType,
  ${PartFields.desc1} $textType,
  ${PartFields.desc2} $textType,
  ${PartFields.desc3} $textType,
  ${PartFields.desc4} $textType,
  ${PartFields.price1} $integerType,
  ${PartFields.price2} $integerType,
  ${PartFields.price3} $integerType,
  ${PartFields.price4} $integerType
  )
''');

    await db.execute('''
CREATE TABLE $tablePriceLists(
  ${PriceListFields.id} $idType,
  ${PriceListFields.pTitle} $textType,
  ${PriceListFields.carType} $textType,
  ${PriceListFields.title} $textType,
  ${PriceListFields.desc} $textType,
  ${PriceListFields.price} $integerType,
  ${PriceListFields.time} $textType
  )
''');

    await db.execute('''
CREATE TABLE $tablePriceListItems(
  ${PriceListItemFields.id} $idType,
  ${PriceListItemFields.lID} $integerType,
  ${PriceListItemFields.title} $textType,
  ${PriceListItemFields.desc} $textType,
  ${PriceListItemFields.price} $integerType
  )
''');
  }

  ///Profiles methods
  Future <Profile> createProfile (Profile profile) async {
    final db = await instance.database;
    final id = await db.insert(tableProfiles, profile.toJson());
    return profile.copy(id: id);
  }
  Future <void> createProfileParts (int pID, String type) async {
    for (NormalPart part in parts) {
      final newPart = Part(
          pID: pID,
          title: part.title,
          price1: 9000,
          desc1: "Новая(2 стороны)",
          price2: 8500,
          desc2: "Ремонтная(1 сторона)",
          price3: 11500,
          desc3: "Ремонтная(2 стороны)",
          price4: 0,
          desc4: '',
          carType: type,
          side: part.side
      );
      await createPart(newPart);
    }
  }
  Future<Profile>  readTitleProfile(String title) async {
    final db = await instance.database;

    final maps = await db.query(
      tableProfiles,
      columns: ProfileFields.values,
      where: '${ProfileFields.title} = ?',
      whereArgs: [title],
    );

    if (maps.isNotEmpty) {
      return Profile.fromJson(maps.first);
    } else {
      throw Exception('Profile $title not found');
    }
  }
  Future<Profile>  readIDProfile(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableProfiles,
      columns: ProfileFields.values,
      where: '${ProfileFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Profile.fromJson(maps.first);
    } else {
      throw Exception('Profile $id not found');
    }
  }
  Future<List<Profile>> readAllProfiles() async {
    final db = await instance.database;
    const orderBy = '${ProfileFields.title} ASC'; //соритировка по id в прямом порядке (ASC)

    final result = await db.query(tableProfiles, orderBy: orderBy);
    return result.map((json) => Profile.fromJson(json)).toList();
  }
  Future<int> updateProfile(Profile profile) async {
    final db = await instance.database;

    return db.update(
      tableProfiles,
      profile.toJson(),
      where: '${ProfileFields.id} = ?',
      whereArgs: [profile.id],
    );
  }
  Future<int> deleteProfile(int id) async {
    final db = await instance.database;
    deleteProfileParts(id);
    return await db.delete(
      tableProfiles,
      where: '${ProfileFields.id} = ?',
      whereArgs: [id],
    );
  }

  ///CarTypes methods
  Future <Car> createCar (Car car) async {
    final db = await instance.database;
    final id = await db.insert(tableCars, car.toJson());
    return car.copy(id: id);
  }
  Future <Car> readCar(String title) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCars,
      columns: CarFields.values,
      where: '${CarFields.title} = ?',
      whereArgs: [title],
    );

    if (maps.isNotEmpty) {
      return Car.fromJson(maps.first);
    } else {
      throw Exception('Type $title not found');
    }
  }
  Future <List<Car>> readGlobalCars() async {
    final db = await instance.database;

    final result = await db.query(
        tableCars,
        columns: CarFields.values,
        where: "${CarFields.isGlobal} = '1'"
    );
    return result.map((json) => Car.fromJson(json)).toList();
  }
  Future <List<Car>> readProfileCars(int pID) async {
    final db = await instance.database;

    final result = await db.query(
      tableCars,
      columns: CarFields.values,
      where: "${CarFields.pID} = ? OR ${CarFields.isGlobal} = '1' ",
      whereArgs: [pID],
      orderBy: '${CarFields.id} ASC'
    );
    return result.map((json) => Car.fromJson(json)).toList();
  }
  Future<List<Car>> readAllCars() async {
    final db = await instance.database;
    const orderBy = '${CarFields.title} ASC'; //соритировка по id в прямом порядке (ASC)

    final result = await db.query(tableCars, orderBy: orderBy);
    return result.map((json) => Car.fromJson(json)).toList();
  }
  Future<int> updateCar(Car car) async {
    final db = await instance.database;

    return db.update(
      tableCars,
      car.toJson(),
      where: '${CarFields.id} = ?',
      whereArgs: [car.id],
    );
  }
  Future<int> deleteCar(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableCars,
      where: '${CarFields.id} = ?',
      whereArgs: [id],
    );
  }


  ///Parts methods
  Future<Part> createPart(Part part) async {
    final db = await instance.database;
    final id = await db.insert(tableCarParts, part.toJson());
    return part.copy(id: id);
  }
  Future<Part> testReadParts(int pID) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCarParts,
      columns: PartFields.values,
      where: '${PartFields.pID} = ?',
      whereArgs: [pID],
    );

    if (maps.isNotEmpty) {
      return Part.fromJson(maps.first);
    } else {
      throw Exception('parts with $pID not found');
    }
  }
  Future<Part> readPart(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCarParts,
      columns: PartFields.values,
      where: '${PartFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Part.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<Part> readPTTPart(String title, int pID, String carType) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCarParts,
      columns: PartFields.values,
      where: '${PartFields.title} = ? AND ${PartFields.pID} = ? AND ${PartFields.carType} = ?',
      whereArgs: [title, pID, carType],
    );

    if (maps.isNotEmpty) {
      return Part.fromJson(maps.first);
    } else {
      throw Exception('Part $title not found');
    }
  }
  Future<List<Part>> readTypeParts(String carType) async {
    final db = await instance.database;

    final result = await db.query(
      tableCarParts,
      where: '${PartFields.carType} = ?',
      whereArgs: [carType]
    );
    return result.map((json) => Part.fromJson(json)).toList();
  }
  Future<List<Part>> readProfileParts(String carType, int pID, String? side) async {
    final db = await instance.database;
    const orderBy = '${PartFields.title} ASC'; //соритировка по title в прямом порядке (ASC)

    final result = await db.query(
      tableCarParts,
      orderBy: orderBy,
      where: side != null
          ? '${PartFields.carType} = ? AND ${PartFields.pID} = ? AND ${PartFields.side} = ?'
          : '${PartFields.carType} = ? AND ${PartFields.pID} = ?',
      whereArgs: side != null
        ? [carType, pID, side]
        : [carType, pID],
    );
    return result.map((json) => Part.fromJson(json)).toList();
  }
  Future<List<Part>> readAllParts() async {
    final db = await instance.database;
    const orderBy = '${PartFields.id} ASC'; //соритировка по id в прямом порядке (ASC)

    final result = await db.query(tableCarParts, orderBy: orderBy);
    return result.map((json) => Part.fromJson(json)).toList();
  }
  Future<int> updatePart(Part part) async {
    final db = await instance.database;

    return db.update(
      tableCarParts,
      part.toJson(),
      where: '${PartFields.id} = ?',
      whereArgs: [part.id],
    );
  }
  Future<int> deletePart(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableCarParts,
      where: '${PartFields.id} = ?',
      whereArgs: [id],
    );
  }
  Future<int> deleteTypeParts(int pID, String type, bool isGlobal) async {
    final db = await instance.database;
    return await db.delete(
      tableCarParts,
      where: isGlobal
          ? '${PartFields.carType} = ?'
          : '${PartFields.pID} = ? AND ${PartFields.carType} = ?',
      whereArgs: isGlobal
          ? [type]
          : [pID, type],
    );
  }
  Future<int> deleteProfileParts(int pID) async {
    final db = await instance.database;
    return await db.delete(
      tableCarParts,
      where: '${PartFields.pID} = ?',
      whereArgs: [pID],
    );
  }


  ///PriceLists methods
  Future <PriceList> createPriceList (PriceList priceList) async {
    final db = await instance.database;
    final id = await db.insert(tablePriceLists, priceList.toJson());
    return priceList.copy(id: id);
  }
  Future<PriceList>  readPriceList(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePriceLists,
      columns: PriceListFields.values,
      where: '${PriceListFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PriceList.fromJson(maps.first);
    } else {
      throw Exception('Price List $id not found');
    }
  }
  Future<List<PriceList>> readAllPriceLists() async {
    final db = await instance.database;
    const orderBy = '${PriceListFields.title} ASC'; //соритировка по id в прямом порядке (ASC)

    final result = await db.query(tablePriceLists, orderBy: orderBy);
    return result.map((json) => PriceList.fromJson(json)).toList();
  }
  Future<int> updatePriceList(PriceList priceList) async {
    final db = await instance.database;

    return db.update(
      tableProfiles,
      priceList.toJson(),
      where: '${PriceListFields.id} = ?',
      whereArgs: [priceList.id],
    );
  }
  Future<int> deletePriceList(int id) async {
    final db = await instance.database;
    deletePriceListItems(id);
    return await db.delete(
      tablePriceLists,
      where: '${PriceListFields.id} = ?',
      whereArgs: [id],
    );
  }


  ///PriceListItems methods
  Future <PriceListItem> createPriceListItem (PriceListItem priceListItem) async {
    final db = await instance.database;
    final id = await db.insert(tablePriceListItems, priceListItem.toJson());
    return priceListItem.copy(id: id);
  }
  Future <void> createPriceListItems (int pID, List<PriceListItem> items) async {
    for (PriceListItem item in items) {
      await createPriceListItem(item);
    }
  }
  Future<PriceListItem>  readPriceListItem(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePriceListItems,
      columns: PriceListItemFields.values,
      where: '${PriceListItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PriceListItem.fromJson(maps.first);
    } else {
      throw Exception('Price List $id not found');
    }
  }
  Future<List<PriceListItem>> readAllPriceListItems() async {
    final db = await instance.database;
    const orderBy = '${PriceListItemFields.title} ASC'; //соритировка по id в прямом порядке (ASC)

    final result = await db.query(tablePriceListItems, orderBy: orderBy);
    return result.map((json) => PriceListItem.fromJson(json)).toList();
  }
  Future<int> updatePriceListItem(PriceListItem priceListItem) async {
    final db = await instance.database;

    return db.update(
      tablePriceListItems,
      priceListItem.toJson(),
      where: '${PriceListItemFields.id} = ?',
      whereArgs: [priceListItem.id],
    );
  }
  Future<int> deletePriceListItems(int lID) async {
    final db = await instance.database;
    return await db.delete(
      tablePriceListItems,
      where: '${PriceListItemFields.lID} = ?',
      whereArgs: [lID],
    );
  }
  Future<int> deletePriceListItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      tablePriceListItems,
      where: '${PriceListItemFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
