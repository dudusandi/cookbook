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
        return const Color(0xFFE67E22); // Laranja quente
      case 'jantar':
        return const Color(0xFF8E44AD); // Roxo suave
      case 'café da manhã':
        return const Color(0xFFF1C40F); // Amarelo quente
      case 'lanche':
        return const Color(0xFFE74C3C); // Vermelho suave
      case 'sobremesa':
        return const Color(0xFFC0392B); // Vermelho escuro
      case 'aperitivo':
        return const Color(0xFF27AE60); // Verde suave
      case 'bebida':
        return const Color(0xFF2980B9); // Azul suave
      default:
        return const Color(0xFF7F8C8D); // Cinza neutro
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
        backgroundColor: const Color.fromARGB(255, 147, 49, 49),
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
                color: const Color.fromARGB(255, 147, 49, 49),
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
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tag.categoria,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
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
