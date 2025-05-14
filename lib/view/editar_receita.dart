import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../model/receita.dart';
import '../data/banco.dart';

class EditarReceita extends StatefulWidget {
  final Receita receita;

  const EditarReceita({super.key, required this.receita});

  @override
  State<EditarReceita> createState() => _EditarReceitaState();
}

class _EditarReceitaState extends State<EditarReceita> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _tempoPreparoController;
  late TextEditingController _ingredientesController;
  late TextEditingController _modoPreparoController;
  late List<String> _tags;
  Uint8List? _imagem;
  final Banco _banco = Banco();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.receita.nome);
    _tempoPreparoController = TextEditingController(text: widget.receita.tempoPreparo);
    _ingredientesController = TextEditingController(text: widget.receita.ingredientes);
    _modoPreparoController = TextEditingController(text: widget.receita.modoPreparo);
    _tags = List.from(widget.receita.tags);
    _imagem = widget.receita.imagem;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tempoPreparoController.dispose();
    _ingredientesController.dispose();
    _modoPreparoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imagem = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Receita'),
        backgroundColor: const Color.fromARGB(255, 132, 94, 143),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _selecionarImagem,
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey[200],
                      child: _imagem != null
                          ? ClipOval(
                              child: Image.memory(
                                _imagem!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.add_a_photo, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da Receita'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome da receita';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _tempoPreparoController,
                  decoration: const InputDecoration(labelText: 'Tempo de Preparo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tempo de preparo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ingredientesController,
                  decoration: const InputDecoration(labelText: 'Ingredientes'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira os ingredientes';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _modoPreparoController,
                  decoration: const InputDecoration(labelText: 'Modo de Preparo'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o modo de preparo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        print('ID da receita original: ${widget.receita.id}');
                        final receitaAtualizada = Receita(
                          id: widget.receita.id,
                          nome: _nomeController.text,
                          tempoPreparo: _tempoPreparoController.text,
                          ingredientes: _ingredientesController.text,
                          modoPreparo: _modoPreparoController.text,
                          tags: _tags,
                          imagem: _imagem,
                        );
                        print('Dados da receita a ser atualizada:');
                        print('ID: ${receitaAtualizada.id}');
                        print('Nome: ${receitaAtualizada.nome}');
                        print('Tempo: ${receitaAtualizada.tempoPreparo}');
                        print('Ingredientes: ${receitaAtualizada.ingredientes}');
                        print('Modo: ${receitaAtualizada.modoPreparo}');
                        print('Tags: ${receitaAtualizada.tags}');
                        print('Tem imagem: ${receitaAtualizada.imagem != null}');

                        await _banco.atualizarReceita(receitaAtualizada);
                        print('Receita atualizada com sucesso');
                        
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      } catch (e) {
                        print('Erro ao atualizar receita: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao atualizar receita: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 132, 94, 143),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Salvar Alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 