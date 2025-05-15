import 'package:cookbook/model/receita.dart';
import 'package:flutter/material.dart';
import '../data/banco.dart';
import 'editar_receita.dart';

class DadosReceita extends StatefulWidget {
  final Receita receita;
  
  const DadosReceita({
    super.key,
    required this.receita,
  });

  @override
  State<DadosReceita> createState() => _DadosReceitaState();
}

class _DadosReceitaState extends State<DadosReceita> {
  final Color _corPrincipal = const Color.fromARGB(255, 147, 49, 49);

  @override
  Widget build(BuildContext context) {
    final Banco banco = Banco();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita.nome),
        foregroundColor: Colors.white,
        backgroundColor: _corPrincipal,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarReceita(receita: widget.receita),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              await banco.removerReceita(widget.receita.nome);
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.delete),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: widget.receita.imagem != null
                        ? Image.memory(
                            widget.receita.imagem!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              size: 80,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    'Tempo de Preparo',
                    widget.receita.tempoPreparo,
                    Icons.timer,
                    _corPrincipal,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Ingredientes',
                    widget.receita.ingredientes,
                    Icons.shopping_basket,
                    _corPrincipal,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Modo de Preparo',
                    widget.receita.modoPreparo,
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
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: widget.receita.tags.map((tag) {
                              return Chip(
                                label: Text(tag),
                                backgroundColor: _corPrincipal.withValues(alpha: 0.1),
                                labelStyle: TextStyle(color: _corPrincipal),
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
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
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
