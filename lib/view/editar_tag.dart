import 'package:flutter/material.dart';
import '../model/tag.dart';
import '../data/banco.dart';

class EditarTag extends StatefulWidget {
  final Tag tag;

  const EditarTag({super.key, required this.tag});

  @override
  State<EditarTag> createState() => _EditarTagState();
}

class _EditarTagState extends State<EditarTag> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late String _dificuldadeSelecionada;
  late String _culinariaSelecionada;
  late String _categoriaSelecionada;
  final Banco _banco = Banco();

  final List<String> _dificuldades = ['Fácil', 'Médio', 'Difícil'];
  final List<String> _culinarias = ['Brasileira', 'Italiana', 'Japonesa', 'Mexicana', 'Chinesa', 'Indiana', 'Árabe', 'Francesa'];
  final List<String> _categorias = ['Almoço', 'Jantar', 'Café da Manhã', 'Lanche', 'Sobremesa', 'Aperitivo', 'Bebida'];

  IconData _getIconForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'almoço':
        return Icons.lunch_dining;
      case 'jantar':
        return Icons.dinner_dining;
      case 'café da manhã':
        return Icons.breakfast_dining;
      case 'lanche':
        return Icons.cake;
      case 'sobremesa':
        return Icons.icecream;
      case 'aperitivo':
        return Icons.wine_bar;
      case 'bebida':
        return Icons.local_drink;
      default:
        return Icons.restaurant;
    }
  }

  Color _getColorForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'almoço':
        return Colors.orange.shade300;
      case 'jantar':
        return Colors.purple.shade300;
      case 'café da manhã':
        return Colors.yellow.shade300;
      case 'lanche':
        return Colors.pink.shade300;
      case 'sobremesa':
        return Colors.red.shade300;
      case 'aperitivo':
        return Colors.green.shade300;
      case 'bebida':
        return Colors.blue.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.tag.nome);
    _descricaoController = TextEditingController(text: widget.tag.descricao);
    
    _dificuldadeSelecionada = _dificuldades.contains(widget.tag.dificuldade) 
        ? widget.tag.dificuldade 
        : _dificuldades[0];
    
    _culinariaSelecionada = _culinarias.contains(widget.tag.culinaria)
        ? widget.tag.culinaria
        : _culinarias[0];
    
    _categoriaSelecionada = _categorias.contains(widget.tag.categoria)
        ? widget.tag.categoria
        : _categorias[0];
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForCategory(_categoriaSelecionada);
    final icon = _getIconForCategory(_categoriaSelecionada);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tag'),
        backgroundColor: color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final tagAtualizada = Tag(
                    nome: _nomeController.text,
                    descricao: _descricaoController.text,
                    dificuldade: _dificuldadeSelecionada,
                    culinaria: _culinariaSelecionada,
                    categoria: _categoriaSelecionada,
                  );

                  await _banco.salvarTag(tagAtualizada);
                  
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar tag: $e'),
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
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 80,
                    color: color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _categoriaSelecionada,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
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
                      'Nome',
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome';
                          }
                          return null;
                        },
                      ),
                      Icons.label,
                      color,
                    ),
                    const SizedBox(height: 16),
                    _buildFormCard(
                      'Descrição',
                      TextFormField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a descrição';
                          }
                          return null;
                        },
                      ),
                      Icons.description,
                      color,
                    ),
                    const SizedBox(height: 16),
                    _buildFormCard(
                      'Dificuldade',
                      DropdownButtonFormField<String>(
                        value: _dificuldadeSelecionada,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: _dificuldades.map((String dificuldade) {
                          return DropdownMenuItem<String>(
                            value: dificuldade,
                            child: Text(dificuldade),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _dificuldadeSelecionada = newValue;
                            });
                          }
                        },
                      ),
                      Icons.trending_up,
                      color,
                    ),
                    const SizedBox(height: 16),
                    _buildFormCard(
                      'Culinária',
                      DropdownButtonFormField<String>(
                        value: _culinariaSelecionada,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: _culinarias.map((String culinaria) {
                          return DropdownMenuItem<String>(
                            value: culinaria,
                            child: Text(culinaria),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _culinariaSelecionada = newValue;
                            });
                          }
                        },
                      ),
                      Icons.restaurant,
                      color,
                    ),
                    const SizedBox(height: 16),
                    _buildFormCard(
                      'Categoria',
                      DropdownButtonFormField<String>(
                        value: _categoriaSelecionada,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: _categorias.map((String categoria) {
                          return DropdownMenuItem<String>(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _categoriaSelecionada = newValue;
                            });
                          }
                        },
                      ),
                      icon,
                      color,
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