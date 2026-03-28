import 'package:flutter/material.dart';

class Nivel extends StatefulWidget {
  const Nivel({super.key});

  @override
  State<Nivel> createState() => _NivelState();
}

class _NivelState extends State<Nivel> {
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return ListView(
          controller: _scrollController,
          children: [
            for(int i=1;i<=20;i++)...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              
              child: InkWell(
                onTap: () => Navigator.pop(context, i),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 24, 24, 24),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(i.toString()),
                      ),
                      Checkbox(value: false, onChanged: null)
                    ],
                  ),
                ),
              ),
            ),
            ]
          ]

    );
  }
}