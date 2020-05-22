import 'dart:io';

import 'package:path/path.dart';
import 'package:qrscan/models/scan_model.dart';
export 'package:qrscan/models/scan_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory document = await getApplicationDocumentsDirectory();

    final path = join(document.path, 'ScannDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('create table Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

//METODOS PARA CREAR REGISTROS

  nuevoScanRow(ScanModel scan) async {
    final db = await database;

    final result = await db.rawInsert("INSERT INTO Scans (id,tipo,valor) "
        "values (${scan.id},'${scan.tipo}','${scan.valor}')");

    return result;
  }

  nuevoSacn(ScanModel scan) async {
    final db = await database;
    final result = await db.insert("Scans", scan.toJson());
    return result;
  }

  //select informacion
  Future<ScanModel> getScanID(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScan() async {
    final db = await database;
    final res = await db.query('Scans');
    List<ScanModel> list =
        res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];

    return list;
  }

  Future<List<ScanModel>> getScanTipo(String tipo) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipo=?', whereArgs: [tipo]);
    List<ScanModel> list =
        res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];

    return list;
  }

  //actualizar
  Future<int> updateScan(ScanModel scan) async {
    final db = await database;
    final res = await db
        .update("Scans", scan.toJson(), where: 'id=?', whereArgs: [scan.id]);
    return res;
  }

  //Delete
  Future<int> delteScan(int id) async {
    final db = await database;
    final res = await db.delete("Scans", where: 'id=?', whereArgs: [id]);
    return res;
  }

  Future<int> delteAllScan() async {
    final db = await database;
    final res = await db.rawDelete("Delete from Scans");
    return res;
  }
}
