import 'package:flutter/material.dart';

class Radiogroup extends StatefulWidget {
  final List<String> options;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const Radiogroup({
    super.key,
    this.options = const ['Masculino', 'Feminino'],
    this.initialValue,
    this.onChanged,
  });

  @override
  State<Radiogroup> createState() => _RadiogroupState();
}

class _RadiogroupState extends State<Radiogroup> {
  String? genero;

  @override
  void initState() {
    super.initState();
    genero = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
      ),
      child: Row(
        children: [
          const Text(
            "Gênero",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Wrap(
              spacing: 10,
              children: widget.options.map((opt) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: opt,
                      groupValue: genero,
                      onChanged: (value) {
                        setState(() => genero = value);
                        widget.onChanged?.call(value);
                      },
                    ),
                    Text(opt),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}