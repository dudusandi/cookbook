import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../data/banco.dart';
import '../model/receita.dart';

class CadastroReceita extends StatefulWidget {
  const CadastroReceita({super.key});

  @override
  State<CadastroReceita> createState() => _CadastroReceitaState();
}

class _CadastroReceitaState extends State<CadastroReceita> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final modoPreparoController = TextEditingController();
  final tempoPreparoController = TextEditingController();
  final ingredientesController = TextEditingController();

  final Banco _banco = Banco();
  List<String> _todasTags = [];
  List<String> _tagsSelecionadas = [];
  Uint8List? _imagem;
  final ImagePicker _picker = ImagePicker();

  final Color _corPrincipal = const Color.fromARGB(255, 147, 49, 49);

  Future<void> _selecionarImagem() async {
    final XFile? imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);
    if (imagemSelecionada != null) {
      final imagem_compactada = await _comprimirImagem(imagemSelecionada);
      if (imagem_compactada != null) {
        setState(() {
          _imagem = imagem_compactada;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao comprimir a imagem')),
          );
        }
      }
    }
  }

  Future<Uint8List?> _comprimirImagem(XFile imagem) async {
    try {
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imagem.path,
        quality: 60,
      );
      if (compressedImage != null) {
        return Uint8List.fromList(compressedImage);
      }
      return null;
    } catch (e) {
      print('Erro na compressão: $e');
      return null;
    }
  }

  Future<void> _carregarTags() async {
    try {
      List<String> tags = await _banco.listarTags();
      setState(() {
        _todasTags = tags;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar tags: $e')),
        );
      }
    }
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
        title: const Text('Nova Receita'),
        foregroundColor: Colors.white,
        backgroundColor: _corPrincipal,
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final receita = Receita(
                    nome: nomeController.text,
                    tempoPreparo: tempoPreparoController.text,
                    modoPreparo: modoPreparoController.text,
                    ingredientes: ingredientesController.text,
                    tags: _tagsSelecionadas,
                    imagem: _imagem,
                  );

                  await _banco.salvarReceita(receita);
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar receita: $e')),
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
                        controller: nomeController,
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
                        controller: tempoPreparoController,
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
                        controller: ingredientesController,
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
                        controller: modoPreparoController,
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
                                Icon(Icons.image, color: _corPrincipal, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Imagem',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_imagem != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  _imagem!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _selecionarImagem,
                                icon: const Icon(Icons.image),
                                label: const Text('Selecionar Imagem'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _corPrincipal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
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