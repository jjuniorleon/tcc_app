// lib/wigtes/mostrar_banco.dart
import 'package:flutter/material.dart';
import 'package:tcc_app/repositorio/Classe_repositorio.dart';
import 'package:tcc_app/repositorio/Raca_repositorio.dart';

class MostrarBanco extends StatefulWidget {
  final RacaRepositorio? bdR;
  final ClasseRepositorio? bdC;

  const MostrarBanco({Key? key, this.bdR, this.bdC}) : super(key: key);

  @override
  State<MostrarBanco> createState() => _MostrarBancoState();
}

class _MostrarBancoState extends State<MostrarBanco> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    if (widget.bdR != null) {
      _future = widget.bdR!.getAll();
    } else if (widget.bdC != null) {
      _future = widget.bdC!.getAll();
    } else {
      _future = Future.value([]);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _carregar();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bdR == null && widget.bdC == null) {
      return const Center(
        child: Text('Nenhum repositório foi fornecido.'),
      );
    }

    return FutureBuilder<List<dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        final lista = snapshot.data ?? [];

        if (lista.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: const [
                SizedBox(height: 80),
                Center(child: Text('Nenhum item encontrado.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];

              return ListTile(
                title: Text(item.nome),
                subtitle: item.descricao != null && item.descricao.isNotEmpty
                    ? Text(item.descricao)
                    : null,
                onTap: () {
                  Navigator.of(context).pop(item);
                },
              );
            },
          ),
        );
      },
    );
  }
}