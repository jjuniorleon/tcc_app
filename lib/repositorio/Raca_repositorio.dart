// lib/repositorios/raca_repositorio.dart
import 'package:flutter/material.dart';
import 'package:tcc_app/database/bancosqlite.dart';
import 'package:tcc_app/modelos/raca.dart';
import 'package:sqflite/sqflite.dart';

class RacaRepositorio extends ChangeNotifier {
  // não usamos `late Database db;` para evitar LateInitializationError.
  // Pegamos o database quando precisamos (BancoSQLite.instance.database).

  RacaRepositorio();

  Future<List<Raca>> getAll() async {
    final Database db = await BancoSQLite.instance.database;
    final List<Map<String, dynamic>> rows = await db.query('racas', orderBy: 'id ASC');
    return rows.map((r) => Raca.fromMap(r)).toList();
  }

  Future<Raca?> getRacaById(int id) async {
    final db = await BancoSQLite.instance.database;
    final rows = await db.query('racas', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return Raca.fromMap(rows.first);
  }

  Future<int> insertRaca(Raca raca) async {
    final db = await BancoSQLite.instance.database;
    final id = await db.insert('racas', raca.toMap());
    notifyListeners();
    return id;
  }

  Future<int> updateRaca(Raca raca) async {
    if (raca.id == null) return 0;
    final db = await BancoSQLite.instance.database;
    final rows = await db.update('racas', raca.toMap(), where: 'id = ?', whereArgs: [raca.id]);
    notifyListeners();
    return rows;
  }

  Future<int> deleteRaca(int id) async {
    final db = await BancoSQLite.instance.database;
    final rows = await db.delete('racas', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
    return rows;
  }
}