// lib/modelos/Antecedente.dart
class Antecedente {
  int? id;
  String nome;
  int? pericias;
  String? idiomas;
  String? ferramentas;
  int? ouro;
  String descricao;

  Antecedente({
    this.id,
    required this.nome,
    this.pericias,
    this.idiomas,
    this.ferramentas,
    this.ouro,
    required this.descricao,

  });

  factory Antecedente.fromMap(Map<String, dynamic> map) {
    return Antecedente(
      id: map['id'] as int?,
      nome: map['nome'] as String? ?? '',
      pericias: map['pericias'] as int?,
      idiomas: map['idiomas'] as String?,
      ferramentas: map['ferramentas'] as String?,
      ouro: map['ouro'] as int?,
      descricao: map['descricao'] as String? ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'pericias': pericias,
      'idiomas': idiomas,
      'ferramentas': ferramentas,
      'ouro': ouro,
      'descricao': descricao,
    };
  }

  @override
  String toString() {
    return 'Antecedente{id: $id, nome: $nome}';
  }
}