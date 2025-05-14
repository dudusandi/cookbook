import 'package:cookbook/model/tag.dart';
import 'package:flutter/material.dart';
import '../data/banco.dart';
import 'editar_tag.dart';

class DadosTag extends StatefulWidget {
  const DadosTag({super.key});

  @override
  State<DadosTag> createState() => _DadosTagState();
}

class _DadosTagState extends State<DadosTag> {
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
  Widget build(BuildContext context) {
    final Tag tag = ModalRoute.of(context)!.settings.arguments as Tag;
    final color = _getColorForCategory(tag.categoria);
    final icon = _getIconForCategory(tag.categoria);
    Banco banco = Banco();

    return Scaffold(
      appBar: AppBar(
        title: Text(tag.nome),
        foregroundColor: Colors.white,
        backgroundColor: color,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarTag(tag: tag),
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
              await banco.removerTag(tag.nome);
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.delete),
          )
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
                    tag.categoria,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    'Nome',
                    tag.nome,
                    Icons.label,
                    color,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Descrição',
                    tag.descricao,
                    Icons.description,
                    color,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Dificuldade',
                    tag.dificuldade,
                    Icons.trending_up,
                    color,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Culinária',
                    tag.culinaria,
                    Icons.restaurant,
                    color,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'Categoria',
                    tag.categoria,
                    icon,
                    color,
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
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
