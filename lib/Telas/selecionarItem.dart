import 'package:flutter/material.dart';

class Selecionaritem extends StatelessWidget {
  const Selecionaritem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione o Item"),
      ),
      body: Center(
        child: Text("Tela de Seleção de Item"),
      ),
    );
  }
}