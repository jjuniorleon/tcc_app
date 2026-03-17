import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tcc_app/wigtes/AtributoAdd.dart';
import 'package:tcc_app/wigtes/atributoWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Atributos(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Atributos extends StatefulWidget {
  const Atributos({super.key});

  @override
  State<Atributos> createState() => _AtributosState();
}

class _AtributosState extends State<Atributos> {
  // Pool inicial com os números disponíveis
  final List<int> pool = [];
  final Random random = Random();

  // Mapa de atributos -> número atribuído (null se vazio)
  late final Map<String, int?> atributos = {
    'Força': null,
    'Destreza': null,
    'Constituição': null,
    'Inteligência': null,
    'Sabedoria': null,
    'Carisma': null,
  };

  @override
  void initState() {
    super.initState();
    _random();
  }

  // Gera 6 números aleatórios de 1 a 6
  void _random() {
    pool.clear();
    for (int i = 0; i < 6; i++) {
      pool.add(random.nextInt(6) + 1); // 1..6
    }
  }

  // Remove a origem correta do item (vem como mapa: {'value': int, 'from': String, 'index': int?})
  void _removerOndeEstiverMap(Map<String, dynamic> data) {
    final int valor = data['value'] as int;
    final String from = data['from'] as String;
    final int? index = data['index'] as int?;

    if (from == 'pool') {
      // se index válido e o valor bater, remove por índice (garante instância correta)
      if (index != null &&
          index >= 0 &&
          index < pool.length &&
          pool[index] == valor) {
        pool.removeAt(index);
      } else {
        // fallback: remove a primeira ocorrência
        pool.remove(valor);
      }
    } else {
      // vem de um atributo: apenas zera o atributo de origem
      final String attr = from;
      if (atributos.containsKey(attr) && atributos[attr] == valor) {
        atributos[attr] = null;
      } else {
        // fallback: zera apenas a primeira ocorrência encontrada com esse valor
        final entry = atributos.entries.firstWhere(
          (e) => e.value == valor,
          orElse: () => const MapEntry('', null),
        );
        if (entry.key != '') atributos[entry.key] = null;
      }
    }
  }

  // Ao aceitar um drop num atributo
  void _atribuirAtributo(String nome, Map<String, dynamic> data) {
    setState(() {
      final int valor = data['value'] as int;

      // se o atributo já tinha um valor, devolve esse valor ao pool
      final prev = atributos[nome];
      if (prev != null) pool.add(prev);

      // remove o item da origem correta (pool ou outro atributo)
      _removerOndeEstiverMap(data);

      // atribui ao atributo
      atributos[nome] = valor;

      pool.sort();
    });
  }

  // Ao aceitar um drop de volta no pool
  void _devolverAoPool(Map<String, dynamic> data) {
    setState(() {
      final int valor = data['value'] as int;
      _removerOndeEstiverMap(data);
      pool.add(valor);
      pool.sort();
    });
  }

  Widget _numberCircle(int number, {double size = 56}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2),
        color: Colors.white,
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  void salvar() {
    bool nulo = false;

    atributos.forEach((key, value) {
      if (value == null) {
        nulo = true;
      }
    });

    if (!nulo) {
      Navigator.pop(context, atributos);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fechar"),
            ),
          ],
          title: const Text("Erro"),
          contentPadding: const EdgeInsets.all(20),
          content: const Text("Todos os atributos precisam ser preenchidos."),
        ),
      );
    }
  }

  int tab = 0;
  int pontos = 10;

  @override
  Widget build(BuildContext context) {
    final attrKeys = atributos.keys.toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Atributos'),
          centerTitle: true,
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                tab = index;
                if (index == 0) {
                  atributos.forEach((key, value) => atributos[key] = null);
                } else {
                  atributos.forEach((key, value) => atributos[key] = 0);
                }
              });
            },
            tabs: const [
              Tab(icon: Icon(Icons.restart_alt_rounded)),
              Tab(icon: Icon(Icons.point_of_sale)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 12,
              ),
              child: Column(
                children: [
                  // POOL de números — é também um DragTarget (para devolver números)
                  DragTarget<Map<String, dynamic>>(
                    onWillAccept: (v) => v != null,
                    onAccept: (value) => _devolverAoPool(value),
                    builder: (context, candidateData, rejectedData) {
                      return Column(
                        children: [
                          const Text(
                            'Números (arraste para um atributo)',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          if (pool.isEmpty)
                            const Text(
                              'Pool vazio',
                              style: TextStyle(fontSize: 14),
                            )
                          else
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: pool.asMap().entries.map((entry) {
                                final i = entry.key;
                                final n = entry.value;

                                return Draggable<Map<String, dynamic>>(
                                  data: {
                                    'value': n,
                                    'from': 'pool',
                                    'index': i,
                                  },
                                  feedback: Material(
                                    elevation: 6,
                                    color: Colors.transparent,
                                    child: _numberCircle(n, size: 72),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.3,
                                    child: _numberCircle(n),
                                  ),
                                  child: _numberCircle(n),
                                );
                              }).toList(),
                            ),
                          if (candidateData.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text('Solte aqui para devolver ao pool'),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: attrKeys.map((nome) {
                          final assigned = atributos[nome];
                          return AtributoWidget(
                            nome: nome,
                            assigned: assigned,
                            onAccept: _atribuirAtributo, // chama a função do pai
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: salvar,
                    child: const Text("Salvar atributos"),
                  ),
                ],
              ),
            ),
            Container(
              child: Center(
                child: Column(
                  children: [
                    Text(pontos.toString()),
                    ...atributos.entries.map((entry) {
                      return Atributoadd(
                        texto: entry.key,
                        valorInicial: entry.value,
                        pontuacaoInicial: pontos,
                        atributos: atributos,
                        pontuacaoTrocada: (valor) {
                          setState(() {
                            pontos += valor;
                          });
                        },
                      );
                    }).toList(),
                    ElevatedButton(
                      onPressed: salvar,
                      child: const Text("Salvar atributos"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: tab == 0
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _random();
                    // limpa atributos
                    atributos.updateAll((key, value) => null);
                  });
                },
                child: const Icon(Icons.shuffle),
                tooltip: 'Re-rolar números',
              )
            : null,
      ),
    );
  }
}