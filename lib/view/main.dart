import 'package:flush/view/dados_receita.dart';
import 'package:flutter/material.dart';
import 'package:flush/view/ajustes.dart';
import '../data/banco.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cadastro_tag.dart';
import 'cadastro_receita.dart';
import 'lista_receita.dart';
import 'dados_tag.dart';
import 'lista_tag.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Pesquisadores',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), 
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const Inicio(),
        '/detalhes': (context) => const DadosTag(),
        '/cadastro': (context) => const CadastroTag(),
        '/cadastro_projeto': (context) => const CadastroReceita(),
        '/ajustes': (context) => const Ajustes(),
        '/listapesquisadores': (context) => const ListaTag(),
        '/dadosprojeto': (context) => const DadosReceita()
      },
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
    const Ajustes(),

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
            backgroundColor: Colors.white,
            icon: Icon(Icons.book_rounded, color: Colors.white,),
            label: 'Receitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag),
            label: 'Tags',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
