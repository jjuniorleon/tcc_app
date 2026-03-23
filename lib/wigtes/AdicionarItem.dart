import 'package:flutter/material.dart';

class Adicionaritem extends StatelessWidget {
  const Adicionaritem({super.key, required this.onTap, this.height = 60, required this.titulo, required this.v});

  final VoidCallback onTap;
  final double height;
  final String titulo;
  final v;
  
  @override
  Widget build(BuildContext context) {
    //print(v);
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
            Checkbox(value: v==null?false:true, onChanged: (value) {}),
          ],
        ),
      ),
    );
  }
}