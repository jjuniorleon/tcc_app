import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Personagens',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Campanhas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add),
          label: 'Criar Personagem',
        ),
      ],
    );
  }
}