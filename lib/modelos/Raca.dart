// lib/modelos/raca.dart
class Raca {
  int? id;
  String nome;
  String descricao;
  int? bonus_forca;
  int? bonus_destreza;
  int? bonus_constituicao;
  int? bonus_inteligencia;
  int? bonus_sabedoria;
  int? bonus_carisma;

  Raca({
    this.id,
    required this.nome,
    required this.descricao,
    this.bonus_forca,
    this.bonus_destreza,
    this.bonus_constituicao,
    this.bonus_inteligencia,
    this.bonus_sabedoria,
    this.bonus_carisma,
  });

  factory Raca.fromMap(Map<String, dynamic> map) {
    return Raca(
      id: map['id'] as int?,
      nome: map['nome'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      bonus_forca: map['bonus_forca'] as int?,
      bonus_destreza: map['bonus_destreza'] as int?,
      bonus_constituicao: map['bonus_constituicao'] as int?,
      bonus_inteligencia: map['bonus_inteligencia'] as int?,
      bonus_sabedoria: map['bonus_sabedoria'] as int?,
      bonus_carisma: map['bonus_carisma'] as int?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'bonus_forca': bonus_forca,
      'bonus_destreza': bonus_destreza,
      'bonus_constituicao': bonus_constituicao,
      'bonus_inteligencia': bonus_inteligencia,
      'bonus_sabedoria': bonus_sabedoria,
      'bonus_carisma': bonus_carisma,
    };
  }

  @override
  String toString() {
    return 'Raca{id: $id, nome: $nome}';
  }
}