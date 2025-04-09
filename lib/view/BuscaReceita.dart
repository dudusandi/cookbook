import 'package:flutter/material.dart';

class PesquisaSearch extends SearchDelegate {
  final List<Map<String, dynamic>> pesquisas;

  PesquisaSearch(this.pesquisas);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
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

  @override
  Widget buildResults(BuildContext context) {
    final results = pesquisas
        .where((pesquisa) =>
        pesquisa['titulo'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['titulo']),
          subtitle: Text(results[index]['datainicial']),
          onTap: () async {
            await Navigator.pushNamed(context, '/dadosprojeto',
                arguments: results[index])
                .then((value) {
              if (value == true) {
                close(context, true);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = pesquisas
        .where((pesquisa) =>
        pesquisa['nome'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['nome']),
          onTap: () async {
            await Navigator.pushNamed(context, '/dadosprojeto',
                arguments: suggestions[index])
                .then((value) {
              if (value == true) {
                close(context, true);
              }
            });
          },
        );
      },
    );
  }
}