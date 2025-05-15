import 'package:flutter/material.dart';
import '../data/banco.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'lista_receita.dart';
import 'lista_tag.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livro de Receitas',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), 
      ],
      home: const Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  InicioState createState() => InicioState();
}

class InicioState extends State<Inicio> {
  int _selectedIndex = 0;

  Banco banco = Banco();

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const ListaReceita(),
    const ListaTag(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 147, 49, 49),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white70),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'Receitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag),
            label: 'Tags',
          ),
        ],
      ),
    );
  }
}
