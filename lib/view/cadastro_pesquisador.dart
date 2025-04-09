import 'package:flutter/material.dart';
import 'package:flush/view/ajustes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../data/banco.dart';

class CadastroPesquisador extends StatefulWidget {
  const CadastroPesquisador({super.key});

  @override
  CadastroPesquisadorState createState() => CadastroPesquisadorState();
}

AjustesState ajustesState = AjustesState();

class CadastroPesquisadorState extends State<CadastroPesquisador> {
  var maskFormatter = MaskTextInputFormatter(mask: '###.###.###-##');

  Banco banco = Banco();

  @override
  void initState() {
    super.initState();
  }

  String _tipoSelecionado = 'Escolha';
  String _areaSelecionada = 'Escolha';

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff004c9e),
          title: const Text('Cadastrar Pesquisador'),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  await banco.adicionarPesquisador(
                    _nomeController.text,
                    _cpfController.text,
                    _tipoSelecionado,
                    _areaSelecionada,
                  );
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
              controller: _cpfController,
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.black12,
                labelText: 'CPF',
              ),
            ),
            const SizedBox(height: 30.0),
            DropdownButtonFormField<String>(
              value: _tipoSelecionado,
              borderRadius: BorderRadius.circular(20),
              onChanged: (String? newValue) {
                setState(() {
                  _tipoSelecionado = newValue!;
                });
              },
              items: <String>['Escolha', 'Aluno', 'Professor', 'Funcionário']
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
                labelText: 'Cargo',
                labelStyle: const TextStyle(color: Colors.black)
              ),
            ),
            const SizedBox(height: 30.0),
            DropdownButtonFormField<String>(
              value: _areaSelecionada,
              borderRadius: BorderRadius.circular(20),
              onChanged: (String? newValue) {
                setState(() {
                  _areaSelecionada = newValue!;
                });
              },
              items: <String>[
                'Escolha',
                'Administração de Empresas',
                'Arquitetura',
                'Artes Cênicas',
                'Astronomia',
                'Biologia',
                'Ciência da Computação',
                'Ciência da Informação',
                'Ciências Ambientais',
                'Ciências Políticas',
                'Comunicação Social',
                'Design de Interiores',
                'Design Gráfico',
                'Direito',
                'Economia',
                'Educação Física',
                'Enfermagem',
                'Engenharia Ambiental',
                'Engenharia Biomédica',
                'Engenharia Civil',
                'Engenharia de Alimentos',
                'Engenharia de Software',
                'Engenharia Elétrica',
                'Engenharia Mecânica',
                'Farmácia',
                'Filosofia',
                'Física',
                'Geografia',
                'História',
                'Jornalismo',
                'Letras',
                'Marketing',
                'Matemática',
                'Medicina',
                'Música',
                'Nutrição',
                'Odontologia',
                'Pedagogia',
                'Psicologia',
                'Química',
                'Relações Internacionais',
                'Turismo',
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
                labelText: 'Formação',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
