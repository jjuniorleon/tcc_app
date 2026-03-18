// lib/modelos/Classe.dart
class Classe {
  int? id;
  String nome;
  String descricao;

  Classe({
    this.id,
    required this.nome,
    required this.descricao,
  });

  factory Classe.fromMap(Map<String, dynamic> map) {
    return Classe(
      id: map['id'] as int?,
      nome: map['nome'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  @override
  String toString() {
    return 'Classe{id: $id, nome: $nome, descrição: $descricao}';
  }
}