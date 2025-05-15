import 'package:cookbook/model/receita.dart';
import 'package:flutter/material.dart';
import '../data/banco.dart';
import 'dados_receita.dart';

class BuscaReceita extends SearchDelegate {
  final List<Receita> receitas;
  String _filtroAtual = 'Nome';
  final Banco _banco = Banco();
  Map<String, String> _categoriasTags = {};

  BuscaReceita(this.receitas) {
    _carregarCategoriasTags();
  }

  Future<void> _carregarCategoriasTags() async {

      final tags = await _banco.listarTags();
      for (var tag in tags) {
        _categoriasTags[tag['nome']] = tag['categoria'];
      }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 147, 49, 49),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
        prefixStyle: TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      PopupMenuButton<String>(
        icon: const Icon(Icons.filter_list),
        onSelected: (String value) {
          _filtroAtual = value;
          showResults(context);
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'Nome',
            child: Row(
              children: [
                Icon(Icons.label, color: Color.fromARGB(255, 147, 49, 49)),
                SizedBox(width: 8),
                Text('Nome da Receita'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Tag',
            child: Row(
              children: [
                Icon(Icons.tag, color: Color.fromARGB(255, 147, 49, 49)),
                SizedBox(width: 8),
                Text('Tag'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Categoria',
            child: Row(
              children: [
                Icon(Icons.category, color: Color.fromARGB(255, 147, 49, 49)),
                SizedBox(width: 8),
                Text('Categoria'),
              ],
            ),
          ),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  List<Receita> _filtrarReceitas() {
    if (query.isEmpty) return receitas;

    switch (_filtroAtual) {
      case 'Nome':
        return receitas
            .where((receita) =>
                receita.nome.toLowerCase().contains(query.toLowerCase()))
            .toList();
      case 'Tag':
        return receitas
            .where((receita) =>
                receita.tags.any((tag) =>
                    tag.toLowerCase().contains(query.toLowerCase())))
            .toList();
      case 'Categoria':
        return receitas
            .where((receita) =>
                receita.tags.any((tag) {
                  final categoria = _categoriasTags[tag];
                  return categoria != null && 
                         categoria.toLowerCase().contains(query.toLowerCase());
                }))
            .toList();
      default:
        return receitas;
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filtrarReceitas();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma receita encontrada',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final receita = results[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: receita.imagem != null
                  ? Image.memory(
                      receita.imagem!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[600],
                      ),
                    ),
            ),
            title: Text(
              receita.nome,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Tempo: ${receita.tempoPreparo}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: receita.tags.map((tag) {
                    final categoria = _categoriasTags[tag];
                    return Tooltip(
                      message: categoria != null ? 'Categoria: $categoria' : '',
                      child: Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: const Color.fromARGB(255, 147, 49, 49).withValues(alpha: 0.1),
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 147, 49, 49),
                        ),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DadosReceita(receita: receita),
                ),
              ).then((value) {
                if (value == true && context.mounted) {
                  close(context, true);
                }
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}