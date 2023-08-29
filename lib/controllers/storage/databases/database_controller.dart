import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseController {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'toolbox.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE ruler_measurements(id TEXT PRIMARY KEY, value TEXT, description TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DatabaseController.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> update(String table, String id, String description) async {
    final db = await DatabaseController.database();
    db.update(table, {'description': description}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DatabaseController.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DatabaseController.database();
    return db.query(table);
  }
}
