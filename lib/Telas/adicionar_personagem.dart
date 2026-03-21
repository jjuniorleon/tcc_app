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

  Map<String, int?>? atributos;

  final RacaRepo = RacaRepositorio();
  final ClasseRepo = ClasseRepositorio();

  void _entrarNaPaginaDeRaca(BuildContext context) => Navigator.push(context,MaterialPageRoute(builder: (context) => Selecionaritem(repo: RacaRepo, tipo: 'raca')),);
  void _entrarNaPaginaDeClasse(BuildContext context) => Navigator.push(context,MaterialPageRoute(builder: (context) => Selecionaritem(repo: ClasseRepo, tipo: 'classe')),);

   Future<void> _entrarNaPaginaDeAtributos(BuildContext context) async {
    final Map<String, int?>? result = await Navigator.push<Map<String, int?>>(
      context,
      MaterialPageRoute(builder: (context) => const Atributos()),
    );

    setState(() {
      atributos = result;
    });
  }

Map<String, Map<VoidCallback, dynamic>> lista(BuildContext context) {
  return {
    "Atributos": {() => _entrarNaPaginaDeAtributos(context): atributos,},
    "Raça": {() => _entrarNaPaginaDeRaca(context): atributos},
    "Classe": {() => _entrarNaPaginaDeClasse(context): atributos},
    "Nivel": {() => _entrarNaPaginaDeRaca(context):atributos},
    "Antecedente": {() => _entrarNaPaginaDeRaca(context):atributos},
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
              Adicionaritem(onTap: item.value.keys.first, titulo: item.key),
              const SizedBox(height: 10),
            ],
            Radiogroup(
              initialValue: 'Masculino',
              onChanged: (v) {
                print('selecionado: $v');
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
