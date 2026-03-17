import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tcc_app/modelos/posicao.dart';
import 'package:tcc_app/database/bancosqlite.dart';

class PersonagemRepositorio extends ChangeNotifier {
  late Database db;
  final List<Posicao> _personagens = [];
  List<Posicao> get personagens => _personagens;
  dynamic _nome = '';

  dynamic get nome => _nome;

  PersonagemRepositorio() {
    _initRepositorio();
  }

  Future<void> _initRepositorio() async {
    await _getNome();
  }

  Future<void> _getNome() async {
db = await bancosqlite.instance.database;
    List personagens = await db.query('personagens');
    _nome = personagens.first;
    notifyListeners();
  }



  Future<void> setNome(String nome) async {
    db = await bancosqlite.instance.database;
    await db.update(
      'personagens',
      {
        'nome': nome
      },
      where: 'id = ?',
      whereArgs: [1],
    );
    _nome = nome;
    notifyListeners();
  }

    Future<String?> ultimoNome() async {
    final db = await bancosqlite.instance.database;

    final result = await db.rawQuery(
      'SELECT nome FROM personagens ORDER BY id DESC LIMIT 1',
    );

    if (result.isNotEmpty) {
      return result.first['nome'] as String;
    }

    return null;
  }

  Future<void> insert(String table, Map<String, Object> data) async {
    final db = await bancosqlite.instance.database;
    await db.insert(table, data);
  }
}