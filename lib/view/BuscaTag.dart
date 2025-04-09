import 'package:flutter/material.dart';

import 'dados_tag.dart';

class PesquisadorSearch extends SearchDelegate {
  final List<Map<String, dynamic>> pesquisadores;

  PesquisadorSearch(this.pesquisadores);

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
    final results = pesquisadores
        .where((pesquisador) =>
            pesquisador['nome'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['nome']),
          subtitle: Text(results[index]['areaConhecimento']),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = pesquisadores
        .where((pesquisador) =>
            pesquisador['nome'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['nome']),
          subtitle: Text(suggestions[index]['areaConhecimento']),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DadosTag(),
                settings: RouteSettings(arguments: suggestions[index]),
              ),
            ).then((value) {
              if (value == true) {
                // Feche a tela de busca e atualize a lista principal
                close(context, true);
              }
            });
          },
        );
      },
    );
  }
}
