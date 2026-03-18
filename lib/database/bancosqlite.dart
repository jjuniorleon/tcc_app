import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoSQLite {
  BancoSQLite._();

  static final BancoSQLite instance = BancoSQLite._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'banco.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute(_raca);
    batch.execute(_classes);
    batch.execute(_personagem);
    batch.execute(_personagem_classes);
    batch.execute(_atributos);
    batch.execute(_pericias);
    batch.execute(_personagem_pericias);
    batch.execute(_talentos);
    batch.execute(_personagem_talentos);
    batch.execute(_itens);
    batch.execute(_inventario);
    batch.execute(_magias);
    batch.execute(_personagem_magias);
    batch.execute(_ataques);

    await batch.commit();

    // ---------- DADOS INICIAIS ----------

    final racaId = await db.insert('racas', {
      'nome': 'Humano',
      'descricao': 'Versátil',
      'bonus_forca': 1,
      'bonus_destreza': 1,
    });

    final classeId = await db.insert('classes', {
      'nome': 'Guerreiro',
      'descricao': 'Combate corpo-a-corpo',
    });

    final personagemId = await db.insert('personagens', {
      'nome': 'Goku',
      'pv': 100,
      'pv_max': 100,
      'pm': 50,
      'pm_max': 50,
      'raca_id': racaId,
      'classe_id': classeId,
      'jogador': 'Jeferson',
      'alinhamento': 'Neutro',
      'descricao': 'Exemplo',
    });

    await db.insert('personagem_classes', {
      'personagem_id': personagemId,
      'classe_id': classeId,
      'nivel': 5,
    });

    await db.insert('atributos', {
      'personagem_id': personagemId,
      'forca': 18,
      'destreza': 16,
      'constituicao': 17,
      'inteligencia': 12,
      'sabedoria': 14,
      'carisma': 15,
    });

    final pericia1 = await db.insert('pericias', {
      'nome': 'Atletismo',
      'atributo_base': 'forca',
    });

    final pericia2 = await db.insert('pericias', {
      'nome': 'Acrobacia',
      'atributo_base': 'destreza',
    });

    await db.insert('personagem_pericias', {
      'personagem_id': personagemId,
      'pericia_id': pericia1,
      'mod_total': 8,
      'treinado': 1,
    });

    await db.insert('personagem_pericias', {
      'personagem_id': personagemId,
      'pericia_id': pericia2,
      'mod_total': 6,
      'treinado': 1,
    });
  }

  // ---------------- TABELAS ----------------

  String get _raca => '''
    CREATE TABLE racas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      bonus_forca INTEGER DEFAULT 0,
      bonus_destreza INTEGER DEFAULT 0,
      bonus_constituicao INTEGER DEFAULT 0,
      bonus_inteligencia INTEGER DEFAULT 0,
      bonus_sabedoria INTEGER DEFAULT 0,
      bonus_carisma INTEGER DEFAULT 0
    )
  ''';

  String get _classes => '''
    CREATE TABLE classes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT
    )
  ''';

  String get _personagem => '''
    CREATE TABLE personagens (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      pv INTEGER DEFAULT 0,
      pv_max INTEGER DEFAULT 0,
      pm INTEGER DEFAULT 0,
      pm_max INTEGER DEFAULT 0,
      raca_id INTEGER,
      classe_id INTEGER,
      jogador TEXT,
      alinhamento TEXT,
      descricao TEXT,
      FOREIGN KEY (raca_id) REFERENCES racas(id),
      FOREIGN KEY (classe_id) REFERENCES classes(id)
    )
  ''';

  String get _personagem_classes => '''
    CREATE TABLE personagem_classes (
      personagem_id INTEGER,
      classe_id INTEGER,
      nivel INTEGER DEFAULT 1,
      PRIMARY KEY (personagem_id, classe_id),
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE,
      FOREIGN KEY (classe_id) REFERENCES classes(id) ON DELETE CASCADE
    )
  ''';

  String get _atributos => '''
    CREATE TABLE atributos (
      personagem_id INTEGER PRIMARY KEY,
      forca INTEGER DEFAULT 10,
      destreza INTEGER DEFAULT 10,
      constituicao INTEGER DEFAULT 10,
      inteligencia INTEGER DEFAULT 10,
      sabedoria INTEGER DEFAULT 10,
      carisma INTEGER DEFAULT 10,
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE
    )
  ''';

  String get _pericias => '''
    CREATE TABLE pericias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      atributo_base TEXT
    )
  ''';

  String get _personagem_pericias => '''
    CREATE TABLE personagem_pericias (
      personagem_id INTEGER,
      pericia_id INTEGER,
      mod_total INTEGER DEFAULT 0,
      treinado INTEGER DEFAULT 0,
      PRIMARY KEY (personagem_id, pericia_id),
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE,
      FOREIGN KEY (pericia_id) REFERENCES pericias(id) ON DELETE CASCADE
    )
  ''';

  String get _talentos => '''
    CREATE TABLE talentos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT
    )
  ''';

  String get _personagem_talentos => '''
    CREATE TABLE personagem_talentos (
      personagem_id INTEGER,
      talento_id INTEGER,
      PRIMARY KEY (personagem_id, talento_id),
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE,
      FOREIGN KEY (talento_id) REFERENCES talentos(id) ON DELETE CASCADE
    )
  ''';

  String get _itens => '''
    CREATE TABLE itens (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      peso REAL DEFAULT 0,
      valor INTEGER DEFAULT 0
    )
  ''';

  String get _inventario => '''
    CREATE TABLE inventario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      personagem_id INTEGER,
      item_id INTEGER,
      quantidade INTEGER DEFAULT 1,
      equipado INTEGER DEFAULT 0,
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE,
      FOREIGN KEY (item_id) REFERENCES itens(id)
    )
  ''';

  String get _magias => '''
    CREATE TABLE magias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      grau INTEGER DEFAULT 0,
      escola TEXT,
      descricao TEXT
    )
  ''';

  String get _personagem_magias => '''
    CREATE TABLE personagem_magias (
      personagem_id INTEGER,
      magia_id INTEGER,
      preparado INTEGER DEFAULT 0,
      usos_restantes INTEGER,
      PRIMARY KEY (personagem_id, magia_id),
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE,
      FOREIGN KEY (magia_id) REFERENCES magias(id) ON DELETE CASCADE
    )
  ''';

  String get _ataques => '''
    CREATE TABLE ataques (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      personagem_id INTEGER,
      nome TEXT,
      ataque_bonus INTEGER DEFAULT 0,
      dano TEXT,
      tipo TEXT,
      alcance TEXT,
      observacao TEXT,
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE
    )
  ''';
}