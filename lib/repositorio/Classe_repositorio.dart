// lib/repositorios/Classe_repositorio.dart
import 'package:flutter/material.dart';
import 'package:tcc_app/database/bancosqlite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tcc_app/modelos/Classe.dart';

class ClasseRepositorio extends ChangeNotifier {
  // não usamos `late Database db;` para evitar LateInitializationError.
  // Pegamos o database quando precisamos (BancoSQLite.instance.database).

  ClasseRepositorio();

  Future<List<Classe>> getAll() async {
    final Database db = await BancoSQLite.instance.database;
    final List<Map<String, dynamic>> rows = await db.query('Classes', orderBy: 'id ASC');
    return rows.map((r) => Classe.fromMap(r)).toList();
  }

  Future<Classe?> getClasseById(int id) async {
    final db = await BancoSQLite.instance.database;
    final rows = await db.query('Classes', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return Classe.fromMap(rows.first);
  }

  Future<int> insertClasse(Classe Classe) async {
    final db = await BancoSQLite.instance.database;
    final id = await db.insert('Classes', Classe.toMap());
    notifyListeners();
    return id;
  }

  Future<int> updateClasse(Classe Classe) async {
    if (Classe.id == null) return 0;
    final db = await BancoSQLite.instance.database;
    final rows = await db.update('Classes', Classe.toMap(), where: 'id = ?', whereArgs: [Classe.id]);
    notifyListeners();
    return rows;
  }

  Future<int> deleteClasse(int id) async {
    final db = await BancoSQLite.instance.database;
    final rows = await db.delete('Classes', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
    return rows;
  }
}