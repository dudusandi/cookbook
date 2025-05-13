import 'package:flush/model/receita.dart';
import 'package:flutter/material.dart';
import '../data/banco.dart';

class DadosReceita extends StatefulWidget {
  const DadosReceita({super.key});

  @override
  State<DadosReceita> createState() => _DadosReceitaState();
}

class _DadosReceitaState extends State<DadosReceita> {
  @override
  Widget build(BuildContext context) {
    final Receita receita =
        ModalRoute.of(context)!.settings.arguments as Receita;

    Banco banco = Banco();

    return Scaffold(
      appBar: AppBar(
        title: Text(receita.nome),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 132, 94, 143),
        actions: [
          IconButton(
              onPressed: () async {
                await banco.removerReceita(receita.nome);
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: receita.imagem != null
                      ? Image.memory(
                          receita.imagem!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.image_not_supported,
                          size: 150,
                          color: Colors.grey,
                        ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Tempo de Preparo:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    receita.tempoPreparo,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredientes:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    receita.ingredientes,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modo de Preparo:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    receita.modoPreparo,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tags:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: receita.tags.length,
                    itemBuilder: (context, index) {
                      return Text(
                        receita.tags[index],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
