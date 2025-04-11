import 'package:flush/view/dados_receita.dart';
import 'package:flutter/material.dart';
import 'package:flush/view/ajustes.dart';
import '../data/banco.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cadastro_tag.dart';
import 'cadastro_receita.dart';
import 'home.dart';
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
    const HomePage(),
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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/ajustes');
            },
            icon: const Icon(Icons.settings),
            color: Colors.white,
          )
        ],
        backgroundColor: const Color.fromARGB(255, 143, 0, 57),
        title: const Text('CookBook'),
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
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
