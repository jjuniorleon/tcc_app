import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class bancosqlite {
  // construtor com acesso privado
  bancosqlite._();

  // instância única (singleton)
  static final bancosqlite instance = bancosqlite._();

  // instância do SQLite
  static Database? _database;

  // getter para o database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'bancosqlite.db');

    return await openDatabase(
      path,
      version: 1,
      // onConfigure é chamado antes de onCreate — ideal para ativar foreign keys
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      // se quiser evoluir o schema depois, implemente onUpgrade aqui
    );
  }

  // Callback onCreate: cria todas as tabelas usando batch para performance
  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    // execute criação das tabelas (ordem considerada para FK)
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
    batch.execute(_indices);

    await batch.commit(noResult: true);

    // ---------- inserts de exemplo (usando IDs retornados) ----------
    // Inserir raça e guardar id
    final int racaId = await db.insert('racas', {
      'nome': 'Humano',
      'descricao': 'Versátil',
      'bonus_forca': 1,
      'bonus_destreza': 1
    });

    // Inserir classe e guardar id
    final int classeId = await db.insert('classes', {
      'nome': 'Guerreiro',
      'descricao': 'Combate corpo-a-corpo'
    });

    // Inserir personagem (usa classe_id e raca_id)
    final int personagemId = await db.insert('personagens', {
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

    // Associação personagem <-> classe (muitos-para-muitos)
    await db.insert('personagem_classes', {
      'personagem_id': personagemId,
      'classe_id': classeId,
      'nivel': 5
    });

    // ATRIBUTOS vinculados ao personagem
    await db.insert('atributos', {
      'personagem_id': personagemId,
      'forca': 18,
      'destreza': 16,
      'constituicao': 17,
      'inteligencia': 12,
      'sabedoria': 14,
      'carisma': 15
    });

    // PERÍCIAS: criamos duas e guardamos ids (assumimos ordem de inserção)
    final int periciaAtletismoId = await db.insert('pericias', {
      'nome': 'Atletismo',
      'atributo_base': 'forca'
    });

    final int periciaAcrobaciaId = await db.insert('pericias', {
      'nome': 'Acrobacia',
      'atributo_base': 'destreza'
    });

    // Vínculo personagem_pericias
    await db.insert('personagem_pericias', {
      'personagem_id': personagemId,
      'pericia_id': periciaAtletismoId,
      'mod_total': 8,
      'treinado': 1
    });

    await db.insert('personagem_pericias', {
      'personagem_id': personagemId,
      'pericia_id': periciaAcrobaciaId,
      'mod_total': 6,
      'treinado': 1
    });

    // TALENTOS e vínculo
    final int talentoId = await db.insert('talentos', {
      'nome': 'Ataque Poderoso',
      'descricao': 'Aumenta o dano em ataques corpo-a-corpo'
    });

    await db.insert('personagem_talentos', {
      'personagem_id': personagemId,
      'talento_id': talentoId
    });

    // ITENS
    final int itemEspadaId = await db.insert('itens', {
      'nome': 'Espada Longa',
      'descricao': 'Arma corpo-a-corpo',
      'peso': 3.0,
      'valor': 150
    });

    final int itemPocaoId = await db.insert('itens', {
      'nome': 'Poção de Cura',
      'descricao': 'Recupera PV',
      'peso': 0.5,
      'valor': 50
    });

    // INVENTÁRIO (vincula personagem <-> itens)
    await db.insert('inventario', {
      'personagem_id': personagemId,
      'item_id': itemEspadaId,
      'quantidade': 1,
      'equipado': 1
    });

    await db.insert('inventario', {
      'personagem_id': personagemId,
      'item_id': itemPocaoId,
      'quantidade': 3,
      'equipado': 0
    });

    // MAGIAS e vínculo
    final int magiaId = await db.insert('magias', {
      'nome': 'Kamehameha',
      'grau': 3,
      'escola': 'Energia',
      'descricao': 'Ataque de energia devastador'
    });

    await db.insert('personagem_magias', {
      'personagem_id': personagemId,
      'magia_id': magiaId,
      'preparado': 1,
      'usos_restantes': 5
    });

    // ATAQUES
    await db.insert('ataques', {
      'personagem_id': personagemId,
      'nome': 'Soco',
      'ataque_bonus': 8,
      'dano': '1d6+4',
      'tipo': 'contusão',
      'alcance': 'corpo-a-corpo',
      'observacao': 'Ataque básico'
    });

    // Pronto — todos os relacionamentos do personagem com as outras tabelas foram populados
  }

  /* ----------------- Criação de tabelas ----------------- */

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
      criado_em TEXT DEFAULT (datetime('now')),
      FOREIGN KEY (raca_id) REFERENCES racas(id) ON DELETE SET NULL,
      FOREIGN KEY (classe_id) REFERENCES classes(id) ON DELETE SET NULL
    )
  ''';

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
      observacao TEXT,
      FOREIGN KEY (personagem_id) REFERENCES personagens(id) ON DELETE CASCADE,
      FOREIGN KEY (item_id) REFERENCES itens(id) ON DELETE SET NULL
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

  String get _indices => '''
    CREATE INDEX idx_personagens_nome ON personagens(nome);
    CREATE INDEX idx_inventario_personagem ON inventario(personagem_id);
  ''';
}