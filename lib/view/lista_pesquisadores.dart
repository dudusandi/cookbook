import 'package:flutter/material.dart';
import 'package:flush/view/dados_pesquisador.dart';
import 'package:postgres/postgres.dart';
import '../data/banco.dart';
import 'PesquisadorSearch.dart';

class PesquisadoresListScreen extends StatefulWidget {
  const PesquisadoresListScreen({super.key});

  @override
  PesquisadoresListScreenState createState() => PesquisadoresListScreenState();
}

class PesquisadoresListScreenState extends State<PesquisadoresListScreen> {
  Banco banco = Banco();

  List<Map<String, dynamic>> pesquisadores = [];
  List<Map<String, dynamic>> pesquisadoresFiltrados = [];

  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
        filtrarPesquisadores();
      });
    });
    atualizarListaPesquisadores();
  }

  Future<void> atualizarListaPesquisadores() async {
    Connection conn = await banco.conectarbanco();

    setState(() {
      pesquisadores.clear();
      _isLoading = true;
    });

    final results = await conn.execute(
      Sql.named('SELECT * FROM pesquisadores ORDER BY nome'),
    );

    for (var row in results) {
      var pesquisador = {
        'nome': row[0],
        'areaConhecimento': row[2],
        'tipoConhecimento': row[3],
        'cpf': row[1]
      };
      pesquisadores.add(pesquisador);
    }

    await conn.close();
    filtrarPesquisadores();
    setState(() {
      _isLoading = false;
    });
  }

  void filtrarPesquisadores() {
    if (searchText.isEmpty) {
      pesquisadoresFiltrados = List.from(pesquisadores);
    } else {
      pesquisadoresFiltrados = pesquisadores
          .where((pesquisador) => pesquisador['nome']
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisadores'),
        actions: [
          IconButton(
            onPressed: () {
              atualizarListaPesquisadores();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/cadastro').then(
                (value) => setState(
                  () {
                    if (value == true) {
                      atualizarListaPesquisadores();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(erroAddPesquisador!.isNotEmpty
                                ? 'Erro ao Cadastrar'
                                : 'Pesquisador Cadastrado')),
                      );
                      erroAddPesquisador = '';
                    }
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: PesquisadorSearch(pesquisadoresFiltrados));
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
              itemCount: pesquisadores.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pesquisadores[index]['nome']),
                  subtitle: Text(pesquisadores[index]['areaConhecimento']),
                  onTap: () async {
                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DadosPesquisador(),
                                settings: RouteSettings(
                                    arguments: pesquisadores[index])))
                        .then(
                      (value) => setState(() {
                        if (value == true) {
                          atualizarListaPesquisadores();
                        }
                      }),
                    );
                  },
                );
              },
            ),
    );
  }
}
