import 'package:flutter/material.dart';
import 'package:tcc_app/wigtes/campanha.dart';

class Campanhas extends StatelessWidget {
  Campanhas({super.key});

  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          controller: _scrollController,
          children: [
            Campanha(onTap: () {
              print("Campanha clicada");
            },),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}