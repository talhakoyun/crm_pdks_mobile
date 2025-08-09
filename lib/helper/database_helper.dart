import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database?> initializeDatabase() async =>
      await openDatabase(join(await getDatabasesPath(), "pdks.db"),
          version: 3,
          onCreate: (Database db, int version) => onCreate(db, version));

  onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE UserInAndOut('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'inTime TEXT,'
      'outTime TEXT,'
      'lateReason TEXT,'
      'earlyReason TEXT,'
      'isOutSide TEXT,'
      'latitude REAL,'
      'longitude REAL,'
      'isUpload INTEGER'
      ');',
    );

    await db.execute("""
  CREATE TABLE "UserQrProcess" (
    "id"	INTEGER NOT NULL,
    "processTime"	TEXT,
    "latitude"	REAL,
    "longitude"	REAL,
    "zone"	INTEGER,
    "isQRUpload"	INTEGER,
    PRIMARY KEY("id" AUTOINCREMENT)
    );
      """);
  }

  Future<List<Map<String, dynamic>>> getUserOldEvent() async {
    final db = await initializeDatabase();

    return await db!.query(
      "UserInAndOut",
      orderBy: "id DESC",
    );
  }

  Future<List<Map<String, dynamic>>> getUserInEvent() async {
    final db = await initializeDatabase();

    return await db!.query(
      "UserInAndOut",
      where: "outTime=0 AND isUpload=0 ",
      orderBy: "id DESC",
    );
  }

  Future<List<Map<String, dynamic>>> getUserOutEvent() async {
    final db = await initializeDatabase();

    return await db!.query(
      "UserInAndOut",
      where: "inTime=0 AND isUpload=0 ",
      orderBy: "id DESC",
    );
  }

  Future<void> insertData(Map<String, Object?> data) async {
    final db = await initializeDatabase();
    await db!.insert("UserInAndOut", data);
  }

  Future<List<Map<String, dynamic>>> getEventCount() async {
    final db = await initializeDatabase();

    return await db!.rawQuery('SELECT COUNT (*) from UserInAndOut');
  }

  Future<void> updateData(Map<String, Object?> data, int id) async {
    final db = await initializeDatabase();
    await db!.update("UserInAndOut", data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteMyDatabase() async {
    String path = join(await getDatabasesPath(), 'pdks.db');
    await deleteDatabase(path);
  }

//region QR
  Future<List<Map<String, dynamic>>> getQrOldEvent() async {
    final db = await initializeDatabase();
    return await db!.query("UserQrProcess", orderBy: "id DESC");
  }

  Future<List<Map<String, dynamic>>> getQRProcessEvent() async {
    final db = await initializeDatabase();
    return await db!.query(
      "UserQrProcess",
      where: "isQRUpload=0",
      orderBy: "id DESC",
    );
  }

  Future<void> insertQrData(Map<String, Object?> data) async {
    final db = await initializeDatabase();
    await db!.insert("UserQrProcess", data);
    print(data);
  }

  Future<List<Map<String, dynamic>>> getQrEventCount() async {
    final db = await initializeDatabase();

    return await db!.rawQuery('SELECT COUNT (*) from UserQrProcess');
  }

  Future<void> updateQrData(Map<String, Object?> data, int id) async {
    final db = await initializeDatabase();
    await db!.update("UserQrProcess", data, where: 'id = ?', whereArgs: [id]);
  }

//endregion
}
