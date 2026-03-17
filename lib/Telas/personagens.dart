import 'package:flutter/material.dart';
import 'package:tcc_app/wigtes/personagem.dart';

class Personagens extends StatelessWidget {
  Personagens({super.key});

  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          controller: _scrollController,
          children: [
            Personagem(onTap: () {
              print("Personagem clicado");
            },),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}