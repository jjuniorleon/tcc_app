// lib/wigtes/selecionaritem.dart
import 'package:flutter/material.dart';
import 'package:tcc_app/modelos/raca.dart';
import 'package:tcc_app/wigtes/Mostrar_banco.dart';
import 'package:tcc_app/wigtes/nivel.dart';

class Selecionaritem extends StatelessWidget {
  Selecionaritem({Key? key, required this.repo, required this.tipo})
    : super(key: key);
  final repo;
  String tipo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecione o Item")),
      body: Center(
        child: _MB(repo: repo, tipo: tipo),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 🔥 Criando uma raça de exemplo
          final novaRaca = Raca(
            nome: 'Elfo ${DateTime.now().millisecondsSinceEpoch}',
            descricao: 'Ágil e sábio',
            bonus_destreza: 2,
            bonus_sabedoria: 1,
          );

          await repo.insertRaca(novaRaca);

          // 🔄 Recarrega a tela
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => Selecionaritem(repo: null, tipo: ''),
            ),
          );

          // feedback pro usuário
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Raça adicionada com sucesso!')),
          );
        },
      ),
    );
  }
}

class _MB extends StatelessWidget {
  _MB({required this.repo, required this.tipo});
  final repo;
  String tipo;

  @override
  Widget build(BuildContext context) {
    switch (tipo) {
      case 'raca':
        return MostrarBanco(bdR: repo);
      case 'classe':
        return MostrarBanco(bdC: repo);
      case 'nivel':
        return Nivel();
      default:
        return const Center(child: Text('Tipo inválido'));
    }
  }
}
