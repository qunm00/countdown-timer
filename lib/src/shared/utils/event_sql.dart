import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/event.dart';

class EventSQLite {
  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE events (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        happenOn TEXT NOT NULL,
        remind TEXT
      );
    """);
  }

  static Future<Database> db() async {
    return openDatabase(
      version: 1,
      join(await getDatabasesPath(), 'events_database.db'),
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String title, DateTime on, DateTime? remind) async {
    final db = await EventSQLite.db();

    final data = {
      'title': title,
      'happenOn': on.toString(),
      'remind': remind.toString()
    };
    final id =
        db.insert('events', data, conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await EventSQLite.db();
    return db.query('events', orderBy: "happenOn");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await EventSQLite.db();
    return db.query('events', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, DateTime on, DateTime? remind) async {
    final db = await EventSQLite.db();
    final data = {
      'title': title,
      'happenOn': on.toString(),
      'remind': remind.toString()
    };
    return db.update('events', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteItem(int id) async {
    final db = await EventSQLite.db();

    try {
      await db.delete('events', where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      debugPrint('Something went wrong when trying to delete $id: $error');
    }
  }
}
