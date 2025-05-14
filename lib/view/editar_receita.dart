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
  List<String> _todasTags = [];
  List<String> _tagsSelecionadas = [];
  final Color _corPrincipal = const Color.fromARGB(255, 147, 49, 49);

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.receita.nome);
    _tempoPreparoController = TextEditingController(text: widget.receita.tempoPreparo);
    _ingredientesController = TextEditingController(text: widget.receita.ingredientes);
    _modoPreparoController = TextEditingController(text: widget.receita.modoPreparo);
    _tags = List.from(widget.receita.tags);
    _imagem = widget.receita.imagem;
    _carregarTags();
  }

  Future<void> _carregarTags() async {
    try {
      final tags = await _banco.listarTags();
      setState(() {
        _todasTags = tags;
        _tagsSelecionadas = List.from(_tags);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar tags: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final receitaAtualizada = Receita(
                    id: widget.receita.id,
                    nome: _nomeController.text,
                    tempoPreparo: _tempoPreparoController.text,
                    ingredientes: _ingredientesController.text,
                    modoPreparo: _modoPreparoController.text,
                    tags: _tagsSelecionadas,
                    imagem: _imagem,
                  );

                  await _banco.atualizarReceita(receitaAtualizada);
                  
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                } catch (e) {
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
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 147, 49, 49),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selecionarImagem,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: _imagem != null
                          ? Image.memory(
                              _imagem!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.add_a_photo,
                                size: 80,
                                color: Colors.grey[600],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormCard(
                      'Nome da Receita',
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome da receita';
                          }
                          return null;
                        },
                      ),
                      Icons.label,
                      _corPrincipal,
                    ),
                    const SizedBox(height: 16),
                    _buildFormCard(
                      'Tempo de Preparo',
                      TextFormField(
                        controller: _tempoPreparoController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o tempo de preparo';
                          }
                          return null;
                        },
                      ),
                      Icons.timer,
                      _corPrincipal,
                    ),
                    const SizedBox(height: 16),
                    _buildFormCard(
                      'Ingredientes',
                      TextFormField(
                        controller: _ingredientesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira os ingredientes';
                          }
                          return null;
                        },
                      ),
                      Icons.shopping_basket,
                      _corPrincipal,
                    ),
                    const SizedBox(height: 16),
                    _buildFormCard(
                      'Modo de Preparo',
                      TextFormField(
                        controller: _modoPreparoController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o modo de preparo';
                          }
                          return null;
                        },
                      ),
                      Icons.menu_book,
                      _corPrincipal,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.tag, color: _corPrincipal, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Tags',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_todasTags.isEmpty)
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            else
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _todasTags.map((tag) {
                                  final isSelected = _tagsSelecionadas.contains(tag);
                                  return FilterChip(
                                    label: Text(tag),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _tagsSelecionadas.add(tag);
                                        } else {
                                          _tagsSelecionadas.remove(tag);
                                        }
                                      });
                                    },
                                    selectedColor: _corPrincipal,
                                    checkmarkColor: Colors.white,
                                    backgroundColor: Colors.grey[200],
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(String title, Widget formField, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            formField,
          ],
        ),
      ),
    );
  }
} 