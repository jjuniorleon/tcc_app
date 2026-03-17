import 'package:flutter/material.dart';

class Personagem extends StatelessWidget {
  const Personagem({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/images.png",
              height: 80,
            ),
      
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nome do Personagem",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Raça: Elfo", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),),
                      SizedBox(height: 4),
                      Text("Classe: Mago", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}