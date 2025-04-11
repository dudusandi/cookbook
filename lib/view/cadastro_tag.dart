import 'package:flush/model/tag.dart';
import 'package:flutter/material.dart';
import 'package:flush/view/ajustes.dart';
import '../data/banco.dart';

class CadastroTag extends StatefulWidget {
  const CadastroTag({super.key});

  @override
  CadastroTagState createState() => CadastroTagState();
}

AjustesState ajustesState = AjustesState();

class CadastroTagState extends State<CadastroTag> {
  Banco banco = Banco();

  @override
  void initState() {
    super.initState();
  }

  String _dificuldadeSelecionado = 'Escolha';
  String _culinariaSelecionada = 'Escolha';

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff004c9e),
          title: const Text('Nova Tag'),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  final tag = Tag(
                    nome: _nomeController.text,
                    descricao: _descricaoController.text,
                    dificuldade: _dificuldadeSelecionado,
                    culinaria: _culinariaSelecionada
                  );
                  banco.salvarTag(tag);
                  if (!context.mounted) return;
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.save))
          ]),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            TextFormField(
              controller: _nomeController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.black12,
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 30.0),
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.black12,
                labelText: 'Descrição',
              ),
            ),
            const SizedBox(height: 30.0),
            DropdownButtonFormField<String>(
              value: _dificuldadeSelecionado,
              borderRadius: BorderRadius.circular(20),
              onChanged: (String? newValue) {
                setState(() {
                  _dificuldadeSelecionado = newValue!;
                });
              },
              items: <String>['Escolha', 'Facil', 'Normal', 'Dificil']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.black12,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Dificuldade',
                labelStyle: const TextStyle(color: Colors.black)
              ),
            ),
            const SizedBox(height: 30.0),
            DropdownButtonFormField<String>(
              value: _culinariaSelecionada,
              borderRadius: BorderRadius.circular(20),
              onChanged: (String? newValue) {
                setState(() {
                  _culinariaSelecionada = newValue!;
                });
              },
              items: <String>[
                'Escolha',
                'Italiana',
                'Brasileira',
                'Japonesa',
                'Arabe',
                'Mexicana',
                'Francesa',
                'Americana'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.black12,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Culinária',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
