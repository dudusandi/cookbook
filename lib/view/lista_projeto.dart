import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import '../data/banco.dart';
import 'PesquisaSearch.dart';

class ListaProjeto extends StatefulWidget {
  const ListaProjeto({super.key});

  @override
  State<ListaProjeto> createState() => _ListaProjetoState();
}

class _ListaProjetoState extends State<ListaProjeto> {
  Banco banco = Banco();
  List<Map<String, dynamic>> pesquisas = [];
  List<Map<String, dynamic>> pesquisasFiltradas = [];
  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
        filtrarPesquisas();
      });
    });
    atualizarListaPesquisas();
  }

  Future<void> atualizarListaPesquisas() async {
    Connection conn = await banco.conectarbanco();

    setState(() {
      pesquisas.clear();
      _isLoading = true;
    });

    final results = await conn.execute(
      Sql.named('SELECT * FROM pesquisas ORDER BY titulo'),
    );

    for (var row in results) {
      var dataInicial = row[3];
      var dataFinal = row[4];

      var pesquisa = {
        'titulo': row[1],
        'descricao': row[2],
        'datainicial': DateFormat('dd/MM/yyyy').format(dataInicial as DateTime),
        'datafinal': DateFormat('dd/MM/yyyy').format(dataFinal as DateTime),
        'pesquisadores': row[5],
        'referencia': row[8]

      };
      pesquisas.add(pesquisa);
    }

    await conn.close();
    filtrarPesquisas();
    setState(() {
      _isLoading = false;
    });
  }

  void filtrarPesquisas() {
    if (searchText.isEmpty) {
      pesquisasFiltradas = List.from(pesquisas);
    } else {
      pesquisasFiltradas = pesquisas
          .where((pesquisa) =>
          pesquisa['titulo'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projetos'),
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
              showSearch(context: context, delegate: PesquisaSearch(pesquisas));
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
        itemCount: pesquisasFiltradas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pesquisasFiltradas[index]['titulo']),
            subtitle: Text(pesquisasFiltradas[index]['datainicial']),
            onTap: () async {
              await Navigator.pushNamed(context, '/dadosprojeto',
                  arguments: pesquisasFiltradas[index])
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