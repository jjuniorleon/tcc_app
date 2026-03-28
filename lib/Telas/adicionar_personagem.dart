import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:tcc_app/Telas/atributos.dart';
import 'package:tcc_app/Telas/selecionarItem.dart';
import 'package:tcc_app/repositorio/Classe_repositorio.dart';
import 'package:tcc_app/repositorio/Raca_repositorio.dart';
//import 'package:tcc_app/repositorio/personagem_repositorio.dart';
import 'package:tcc_app/wigtes/AdicionarItem.dart';
import 'package:tcc_app/wigtes/radioGroup.dart';

class AdicionarPersonagem extends StatefulWidget {
  AdicionarPersonagem({super.key});

  @override
  State<AdicionarPersonagem> createState() => _AdicionarPersonagemState();
}

class _AdicionarPersonagemState extends State<AdicionarPersonagem> {
  final ScrollController _scrollController = ScrollController();

  Map<String, int?>? atributos = null;
  int? nivel = null;

  final RacaRepo = RacaRepositorio();
  final ClasseRepo = ClasseRepositorio();

  void _entrarNaPaginaDeRaca(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Selecionaritem(repo: RacaRepo, tipo: 'raca'),
    ),
  );
  void _entrarNaPaginaDeClasse(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Selecionaritem(repo: ClasseRepo, tipo: 'classe'),
    ),
  );
  Future<void> _entrarNaPaginaDeNivel(BuildContext context) async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => Selecionaritem(repo: null, tipo: 'nivel'),
      ),
    );

    setState(() {
      nivel = result;
    });
  }

  Future<void> _entrarNaPaginaDeAtributos(BuildContext context) async {
    final Map<String, int?>? result = await Navigator.push<Map<String, int?>>(
      context,
      MaterialPageRoute(builder: (context) => const Atributos()),
    );

    setState(() {
      atributos = result;
    });
  }

  int? teste;

  Map<String, Map<VoidCallback, dynamic>> lista(BuildContext context) {
    return {
      "Atributos": {() => _entrarNaPaginaDeAtributos(context): atributos},
      "Raça": {() => _entrarNaPaginaDeRaca(context): teste},
      "Classe": {() => _entrarNaPaginaDeClasse(context): teste},
      "Nivel": {() => _entrarNaPaginaDeNivel(context): teste},
      "Antecedente": {() => _entrarNaPaginaDeRaca(context): teste},
    };
  }

  @override
  Widget build(BuildContext context) {
    //final personagem = context.watch<PersonagemRepositorio>();

    final itens = lista(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          controller: _scrollController,
          children: [
            for (var item in itens.entries) ...[
              Adicionaritem(
                onTap: item.value.keys.first,
                titulo: item.key,
                v: item.value.values.first,
              ),
              const SizedBox(height: 10),
            ],
            Radiogroup(
              initialValue: 'Masculino',
              onChanged: (v) {
                print('selecionado: $v');
                print(nivel.toString());
              },
            ),
            ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(atributos.toString()),
                  ),
                );
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
