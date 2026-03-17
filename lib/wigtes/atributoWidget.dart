// lib/wigtes/atributo_widget.dart
import 'package:flutter/material.dart';

class AtributoWidget extends StatelessWidget {
  const AtributoWidget({
    Key? key,
    required this.nome,
    required this.assigned,
    required this.onAccept, // (nome, value) => ...
  }) : super(key: key);

  final String nome;
  final int? assigned;
  final void Function(String nome, Map<String, dynamic> value) onAccept;

  Widget _numberCircle(int number, {double size = 56}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2),
        color: Colors.white,
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Map<String, dynamic>>(
      onWillAccept: (value) {
        return value != null;
      },
      onAccept: (value) {
        onAccept(nome, value);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 140,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(nome, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              if (assigned != null)
                Draggable<Map<String, dynamic>>(
                  data: {'value': assigned, 'from': nome},
                  feedback: Material(
                    elevation: 6,
                    color: Colors.transparent,
                    child: _numberCircle(assigned!, size: 72),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: _numberCircle(assigned!),
                  ),
                  child: _numberCircle(assigned!),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('-', style: TextStyle(fontSize: 20)),
                ),
              if (candidateData.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Solte para atribuir',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}