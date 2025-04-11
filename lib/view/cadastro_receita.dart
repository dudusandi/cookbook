import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../data/banco.dart';
import '../model/receita.dart';

class CadastroReceita extends StatefulWidget {
  const CadastroReceita({super.key});

  @override
  State<CadastroReceita> createState() => _CadastroReceitaState();
}

class _CadastroReceitaState extends State<CadastroReceita> {
  final nomeController = TextEditingController();
  final modoPreparoController = TextEditingController();
  final tempoPreparoController = TextEditingController();
  final valorController = TextEditingController();
  final ingredientesController = TextEditingController();

  Banco banco = Banco();
  List<String> _tags = [];

  Future<void> _carregarTags() async {
    List<String> tags = await banco.listarTags();
    setState(() {
      _tags = tags;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final receita = Receita(
                  nome: nomeController.text,
                  tempoPreparo: tempoPreparoController.text,
                  modoPreparo: modoPreparoController.text,
                  ingredientes: ingredientesController.text,
                  tags: _tags,
                );

                banco.salvarReceita(receita);
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.save))
        ],
        title: const Text('Nova Receita'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff004c9e),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Nome da Receita',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: tempoPreparoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Tempo de Preparo',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: ingredientesController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Ingredientes',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: modoPreparoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Modo de Preparo',
                ),
                maxLines: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              MultiSelectDialogField(
                isDismissible: true,
                dialogHeight: 300,
                backgroundColor: Colors.grey.shade200,
                decoration: BoxDecoration(
                    border: null,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12),
                searchable: true,
                items: _tags
                    .map((tag) => MultiSelectItem<String>(tag, tag))
                    .toList(),
                onConfirm: (values) {
                  setState(() {
                    _tags = values;
                  });
                },
                title: const Text("Tag"),
                buttonText: const Text("Tag"),
                selectedColor: Colors.blue,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
