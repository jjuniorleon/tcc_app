import 'package:flutter/material.dart';

class Adicionaritem extends StatelessWidget {
  const Adicionaritem({super.key, required this.onTap, this.height = 60, required this.titulo});

  final VoidCallback onTap;
  final double height;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo),
            Checkbox(value: false, onChanged: (value) {}),
          ],
        ),
      ),
    );
  }
}