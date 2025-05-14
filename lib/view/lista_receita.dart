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
          'SELECT id, nome, tempopreparo, modopreparo, ingredientes, tags, imagem FROM receitas ORDER BY nome'),
    );

    for (var row in results) {
      Receita receita = Receita(
        id: row[0] as int,
        nome: row[1] as String,
        tempoPreparo: row[2] as String,
        modoPreparo: row[3] as String,
        ingredientes: row[4] as String,
        tags: (row[5] as String?)
                ?.replaceAll(RegExp(r'[\{\}]'), '')
                .split(',')
                .map((e) => e.trim())
                .toList() ??
            [],
        imagem: row[6] as Uint8List?,
      );
      print('ListaReceita - Receita carregada - ID: ${receita.id}, Nome: ${receita.nome}');
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
      backgroundColor: const Color.fromARGB(255, 253, 243, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 49, 49),
        title: const Text('Receitas', style: TextStyle(color: Colors.white, fontSize: 24)),
        actions: [
          IconButton(
             color: Colors.white,
            onPressed: () {
              atualizarListaPesquisas();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            color: Colors.white,
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
             color: Colors.white,
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
    : Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 4, right: 4),
        child: ListView.builder(
          itemCount: receitasFiltradas.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), 
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color.fromARGB(255, 255, 185, 185), 
                    width: 0.5, 
                  ),
                ),
              ),
              child: ListTile(
                leading: receitasFiltradas[index].imagem != null
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            receitasFiltradas[index].imagem!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                title: Text(
                  receitasFiltradas[index].nome,
                  style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 72, 28, 28)),
                ),
                subtitle: Text(
                  receitasFiltradas[index].tempoPreparo.toString(),
                  style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 193, 175, 175)),
                ),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/dadosprojeto',
                    arguments: receitasFiltradas[index],
                  );
                  
                  if (result == true) {
                    print('Atualizando lista após edição/remoção');
                    await atualizarListaPesquisas();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
