import 'package:flush/model/receita.dart';
import 'package:flutter/material.dart';

class BuscaReceita extends SearchDelegate {
  final List<Receita> receitas;

  BuscaReceita(this.receitas);

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
    final results = receitas
        .where((receita) =>
        receita.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].nome),
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
    final suggestions = receitas
        .where((receita) =>
        receita.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].nome),
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