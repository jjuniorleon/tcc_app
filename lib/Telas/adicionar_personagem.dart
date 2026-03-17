import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:tcc_app/Telas/atributos.dart';
import 'package:tcc_app/Telas/selecionarItem.dart';
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

  void _entrarNaPaginaDeRaca(BuildContext context) => Navigator.push(context,MaterialPageRoute(builder: (context) => const Selecionaritem()),);

   Future<void> _entrarNaPaginaDeAtributos(BuildContext context) async {
    final Map<String, int?>? result = await Navigator.push<Map<String, int?>>(
      context,
      MaterialPageRoute(builder: (context) => const Atributos()),
    );

    setState(() {
      atributos = result;
    });
  }

  Map<String, VoidCallback> lista(BuildContext context) => {
    "Atributos": () => _entrarNaPaginaDeAtributos(context),
    "Raça": () => _entrarNaPaginaDeRaca(context),
    "Classe": () => _entrarNaPaginaDeRaca(context),
    "Equipamentos": () => _entrarNaPaginaDeRaca(context),
    "Habilidades": () => _entrarNaPaginaDeRaca(context),
  };

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
              Adicionaritem(onTap: item.value, titulo: item.key),
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
