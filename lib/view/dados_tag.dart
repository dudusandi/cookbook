import 'package:flush/model/tag.dart';
import 'package:flutter/material.dart';
import '../data/banco.dart';

class DadosTag extends StatefulWidget {
  const DadosTag({super.key});

  @override
  State<DadosTag> createState() => _DadosTagState();
}

class _DadosTagState extends State<DadosTag> {
  @override
  Widget build(BuildContext context) {

  final Tag tag = ModalRoute.of(context)!.settings.arguments as Tag;


    Banco banco = Banco();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tag'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff004c9e),
        actions: [
          IconButton(
              onPressed: () async {
                await banco.removerTag(tag.nome);
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nome:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  tag.nome,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descrição:',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tag.descricao,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dificuldade:',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tag.dificuldade,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Culinaria:',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tag.culinaria,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
