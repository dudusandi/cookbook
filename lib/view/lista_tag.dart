import 'package:flush/model/tag.dart';
import 'package:flutter/material.dart';
import 'package:flush/view/dados_tag.dart';
import 'package:postgres/postgres.dart';
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
    Connection conn = await banco.conectarbanco();

    setState(() {
      tags.clear();
      _isLoading = true;
    });

    final results = await conn.execute(
      Sql.named('SELECT * FROM tags ORDER BY nome'),
    );

    for (var row in results) {
      Tag tag = Tag(
        nome: row[0] as String,
        descricao: row[1] as String,
        dificuldade: row[2] as String,
        culinaria: row[3] as String
      );
      tags.add(tag);
    }

    await conn.close();
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
      appBar: AppBar(
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
                        SnackBar(
                            content: Text(erroAddTag!.isNotEmpty
                                ? 'Erro ao Cadastrar'
                                : 'Tag Cadastrada')),
                      );
                      erroAddTag = '';
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
                  subtitle: Text(tags[index].descricao),
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
