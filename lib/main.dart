import 'package:flutter/material.dart';
import 'package:tcc_app/Telas/personagens.dart';
import 'package:provider/provider.dart';
import 'package:tcc_app/Telas/campanhas.dart';
import 'package:tcc_app/Telas/adicionar_personagem.dart';
import 'package:tcc_app/repositorio/Classe_repositorio.dart';
import 'package:tcc_app/wigtes/bottomNavigationBar.dart';
import 'package:tcc_app/repositorio/Raca_repositorio.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RacaRepositorio()),
        ChangeNotifierProvider(create: (_) => ClasseRepositorio()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

//index da pagina atual
  int _currentIndex = 0;

//lista de telas do app
  final List<Widget> _telas = [
    Personagens(),
    Campanhas(),
    AdicionarPersonagem(),
  ];

//função para atualizar o index da pagina atual
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: 'RPG',
      home: Scaffold(
        //chama a tela atual com base no index
        body: _telas[_currentIndex],
        //chama o widget do bottom navigation bar passando o index atual e a função de atualização
        bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}