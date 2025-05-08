import 'dart:typed_data';

import 'package:flush/model/receita.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import '../data/banco.dart';
import 'busca_receita.dart';

class ListaReceita extends StatefulWidget {
  const ListaReceita({super.key});

  @override
  State<ListaReceita> createState() => _ListaReceitaState();
}

class _ListaReceitaState extends State<ListaReceita> {
  Banco banco = Banco();
  List<Receita> receitas = [];
  List<Receita> receitasFiltradas = [];
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
      Sql.named(
          'SELECT nome, tempopreparo, modopreparo, ingredientes, tags, imagem FROM receitas ORDER BY nome'),
    );

    for (var row in results) {
      Receita receita = Receita(
        nome: row[0] as String,
        tempoPreparo: row[1] as String,
        modoPreparo: row[2] as String,
        ingredientes: row[3] as String,
        tags: (row[4] as String?)
                ?.replaceAll(RegExp(r'[\{\}]'), '')
                .split(',')
                .map((e) => e.trim())
                .toList() ??
            [],
        imagem: row[5] as Uint8List?,
      );
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
              receita.nome.toLowerCase().contains(searchText.toLowerCase()))
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
              showSearch(context: context, delegate: BuscaReceita(receitas));
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
                  leading: receitasFiltradas[index].imagem != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            receitasFiltradas[index].imagem!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(receitasFiltradas[index].nome),
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
