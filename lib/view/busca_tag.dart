import 'package:cookbook/model/tag.dart';
import 'package:flutter/material.dart';

import 'dados_tag.dart';

class BuscaTag extends SearchDelegate {
  final List<Tag> tags;  

  BuscaTag(this.tags);

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
    final results = tags
        .where((tag) =>
            tag.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].nome),
          subtitle: Text(results[index].descricao),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = tags
        .where((tag) =>
            tag.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].nome),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DadosTag(tag: suggestions[index]),
              ),
            ).then((value) {
              if (value == true && context.mounted) {
                close(context, true);
              }
            });
          },
        );
      },
    );
  }
}
