import 'package:cookbook/model/tag.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/view/dados_tag.dart';
import '../data/banco.dart';
import 'busca_tag.dart';

class ListaTag extends StatefulWidget {
  const ListaTag({super.key});

  @override
  ListaTagState createState() => ListaTagState();
}

class ListaTagState extends State<ListaTag> {
  Banco banco = Banco();

  List<Tag> tags = [];
  List<Tag> tagsFiltradas = [];

  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
        filtrarTags();
      });
    });
    atualizarListaTags();
  }

  Future<void> atualizarListaTags() async {
    setState(() {
      tags.clear();
      _isLoading = true;
    });

    final db = await banco.database;
    final List<Map<String, dynamic>> maps = await db.query('tags', orderBy: 'nome');

    tags = List.generate(maps.length, (i) {
      return Tag(
        nome: maps[i]['nome'] as String,
        descricao: maps[i]['descricao'] as String,
        dificuldade: maps[i]['dificuldade'] as String,
        culinaria: maps[i]['culinaria'] as String,
        categoria: maps[i]['categoria'] as String,
      );
    });

    filtrarTags();
    setState(() {
      _isLoading = false;
    });
  }

  void filtrarTags() {
    if (searchText.isEmpty) {
      tagsFiltradas = List.from(tags);
    } else {
      tagsFiltradas = tags
          .where((tag) => tag.nome
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 243, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 49, 49),
        foregroundColor: Colors.white,
        title: const Text('Tags'),
        actions: [
          IconButton(
            onPressed: () {
              atualizarListaTags();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/cadastro').then(
                (value) => setState(
                  () {
                    if (value == true) {
                      atualizarListaTags();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tag Cadastrada')),
                      );
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
                  delegate: BuscaTag(tagsFiltradas));
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
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tags[index].nome),
                  subtitle: Text(tags[index].categoria),
                  onTap: () async {
                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DadosTag(),
                                settings: RouteSettings(
                                    arguments: tags[index])))
                        .then(
                      (value) => setState(() {
                        if (value == true) {
                          atualizarListaTags();
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
