import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Atributoadd extends StatefulWidget {
  Atributoadd({
    super.key,
    required this.texto,
    this.valorInicial,
    required this.pontuacaoInicial,
    this.onChanged,
    this.pontuacaoTrocada,
    required this.atributos
  });
  String texto;
  final int? valorInicial;
  final ValueChanged<int>? onChanged;
  final int pontuacaoInicial;
  final ValueChanged<int>? pontuacaoTrocada;
  final Map<String, int?> atributos;

  @override
  State<Atributoadd> createState() => _AtributoaddState();
}

class _AtributoaddState extends State<Atributoadd> {
  late int _valor;

  @override
  void initState() {
    super.initState();
    _valor = widget.valorInicial ?? 0;
  }

  void _change(int delta) {
    widget.onChanged?.call(_valor);

    if (delta > 0) {
      // incremento
      if (widget.pontuacaoInicial > 0 && (widget.pontuacaoInicial - _valor) > 0) {
        setState(() {
          if (_valor < 4) _valor++;
          widget.atributos[widget.texto] = _valor;
        });

        switch (_valor) {
          case -1:
          case 0:
          case 1:
            widget.pontuacaoTrocada?.call(-1);
            break;
          case 2:
            widget.pontuacaoTrocada?.call(-2);
            break;
          case 3:
            widget.pontuacaoTrocada?.call(-3);
            break;
          case 4:
            widget.pontuacaoTrocada?.call(-4);
            break;
        }
      }
    } else {
      // decreser
      if (_valor > -1) {
        setState(() {
          _valor--;
          widget.atributos[widget.texto] = _valor;
        });

        switch (_valor) {
          case -1:
          case 0:
            widget.pontuacaoTrocada?.call(1);
            break;
          case 1:
            widget.pontuacaoTrocada?.call(2);
            break;
          case 2:
            widget.pontuacaoTrocada?.call(3);
            break;
          case 3:
            widget.pontuacaoTrocada?.call(4);
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(widget.texto),
          TextButton.icon(
            onPressed: () => _change(-1), // ajustado para -1
            label: Icon(CupertinoIcons.lessthan),
            icon: const SizedBox.shrink(),
          ),
          Text(_valor.toString()),
          TextButton.icon(
            onPressed: () => _change(1),
            label: Icon(CupertinoIcons.greaterthan),
            icon: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}