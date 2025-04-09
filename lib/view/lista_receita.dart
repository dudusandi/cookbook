import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import '../data/banco.dart';
import 'BuscaReceita.dart';

class ListaReceita extends StatefulWidget {
  const ListaReceita({super.key});

  @override
  State<ListaReceita> createState() => _ListaReceitaState();
}

class _ListaReceitaState extends State<ListaReceita> {
  Banco banco = Banco();
  List<Map<String, dynamic>> receitas = [];
  List<Map<String, dynamic>> receitasFiltradas = [];
  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
        filtrarReceitas();
      });
    });
    atualizarListaPesquisas();
  }

  Future<void> atualizarListaPesquisas() async {
    Connection conn = await banco.conectarbanco();

    setState(() {
      receitas.clear();
      _isLoading = true;
    });

    final results = await conn.execute(
      Sql.named('SELECT * FROM receitas ORDER BY nome'),
    );

    for (var row in results) {

      var receita = {
        'nome': row[1],
        'tempopreparo': row[2],
        'modoPreparo':row[3],
        'ingredientes':row[4],
        'tags': row[5],
      };
      receitas.add(receita);
    }

    await conn.close();
    filtrarReceitas();
    setState(() {
      _isLoading = false;
    });
  }

  void filtrarReceitas() {
    if (searchText.isEmpty) {
      receitasFiltradas = List.from(receitas);
    } else {
      receitasFiltradas = receitas
          .where((receita) =>
          receita['nome'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        actions: [
          IconButton(
            onPressed: () {
              atualizarListaPesquisas();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/cadastro_projeto').then(
                    (value) => setState(() {
                  value == true ? atualizarListaPesquisas() : null;
                }),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: PesquisaSearch(receitas));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: receitasFiltradas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(receitasFiltradas[index]['nome']),
            onTap: () async {
              await Navigator.pushNamed(context, '/dadosprojeto',
                  arguments: receitasFiltradas[index])
                  .then((value) => setState(() {
                value == true ? atualizarListaPesquisas() : null;
              }));
            },
          );
        },
      ),
    );
  }
}