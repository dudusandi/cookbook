import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  final ingredientesController = TextEditingController();

  Banco banco = Banco();
  List<String> _tags = [];
  Uint8List? _imagem;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selecionarImagem() async {
    final XFile? imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);
    if (imagemSelecionada != null) {
      // Comprimir a imagem
      final bytes = await _comprimirImagem(imagemSelecionada);
      if (bytes != null) {
        setState(() {
          _imagem = bytes;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao comprimir a imagem')),
        );
      }
    }
  }

  Future<Uint8List?> _comprimirImagem(XFile imagem) async {
    try {
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imagem.path,
        quality: 70, // Qualidade de 0 a 100
        minWidth: 800, // Largura máxima
        minHeight: 600, // Altura máxima
      );
      return compressedImage;
    } catch (e) {
      print('Erro ao comprimir imagem: $e');
      return null;
    }
  }

  Future<void> _carregarTags() async {
    try {
      List<String> tags = await banco.listarTags();
      setState(() {
        _tags = tags;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar tags: $e')),
      );
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
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final receita = Receita(
                  nome: nomeController.text,
                  tempoPreparo: tempoPreparoController.text,
                  modoPreparo: modoPreparoController.text,
                  ingredientes: ingredientesController.text,
                  tags: _tags,
                  imagem: _imagem,
                );

                await banco.salvarReceita(receita);
                Navigator.pop(context, true);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao salvar receita: $e')),
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              MultiSelectDialogField(
                isDismissible: true,
                dialogHeight: 300,
                backgroundColor: Colors.grey.shade200,
                decoration: BoxDecoration(
                  border: null,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12,
                ),
                searchable: true,
                items: _tags.map((tag) => MultiSelectItem<String>(tag, tag)).toList(),
                onConfirm: (values) {
                  setState(() {
                    _tags = values;
                  });
                },
                title: const Text("Tag"),
                buttonText: const Text("Tag"),
                selectedColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              if (_imagem != null)
                Image.memory(
                  _imagem!,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _selecionarImagem,
                icon: const Icon(Icons.image),
                label: const Text('Selecionar Imagem'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}