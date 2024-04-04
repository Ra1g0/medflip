import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


abstract class DatabaseHelper extends StatefulWidget {
  const DatabaseHelper({super.key});

  static Future<Database> initializeDatabase() async {
    // Open the database and create the table
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'player_scores.db');
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS PlayerScores (PlayerID INTEGER PRIMARY KEY, PlayerName TEXT, Score INTEGER)');
    });
  }

  static Future<void> insertPlayerScore(String name, int score) async {
    final Database db = await initializeDatabase();
    await db.insert(
      'PlayerScores',
      {'PlayerName': name, 'Score': score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchTopPlayerScores() async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> scores = await db.query(
      'PlayerScores',
      orderBy: 'Score DESC',
      limit: 5,
    );
    return scores;
  }
}
