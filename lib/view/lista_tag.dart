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

  IconData _getIconForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'almoço':
        return Icons.lunch_dining;
      case 'jantar':
        return Icons.dinner_dining;
      case 'café da manhã':
        return Icons.breakfast_dining;
      case 'lanche':
        return Icons.cake;
      case 'sobremesa':
        return Icons.icecream;
      case 'aperitivo':
        return Icons.wine_bar;
      case 'bebida':
        return Icons.local_drink;
      default:
        return Icons.restaurant;
    }
  }

  Color _getColorForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'almoço':
        return Colors.orange.shade300;
      case 'jantar':
        return Colors.purple.shade300;
      case 'café da manhã':
        return Colors.yellow.shade300;
      case 'lanche':
        return Colors.pink.shade300;
      case 'sobremesa':
        return Colors.red.shade300;
      case 'aperitivo':
        return Colors.green.shade300;
      case 'bebida':
        return Colors.blue.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

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
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                final icon = _getIconForCategory(tag.categoria);
                final color = _getColorForCategory(tag.categoria);
                
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DadosTag(),
                          settings: RouteSettings(arguments: tag),
                        ),
                      ).then(
                        (value) => setState(() {
                          if (value == true) {
                            atualizarListaTags();
                          }
                        }),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 32,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tag.nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tag.categoria,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
