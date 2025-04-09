import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../data/banco.dart';

class CadastroProjeto extends StatefulWidget {
  const CadastroProjeto({super.key});

  @override
  State<CadastroProjeto> createState() => _CadastroProjetoState();
}

class _CadastroProjetoState extends State<CadastroProjeto> {
  DateTime? dataInicial;
  DateTime? dataFinal;

  bool noDataFinal = false;

  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final empresaController = TextEditingController();
  final valorController = TextEditingController();
  final referenciaController = TextEditingController();

  Banco banco = Banco();
  List<Map<String, dynamic>> _pesquisadores = [];
  List<String> _selectedResearcherIds = [];

  Future<void> _dataInicial(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataInicial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dataInicial = picked;
      });
    }
  }

  Future<void> _dataFinal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: dataFinal ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dataFinal) {
      setState(() {
        dataFinal = picked;
      });
    }
  }

  Future<void> _carregarPesquisadores() async {
    List<Map<String, dynamic>> pesquisadores =
    await banco.listarPesquisadores();
    setState(() {
      _pesquisadores = pesquisadores;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarPesquisadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                banco.salvarProjeto(
                    tituloController.text,
                    empresaController.text,
                    descricaoController.text,
                    referenciaController.text,
                    valorController.text,
                    dataInicial.toString(),
                    noDataFinal ? "01/01/3000" : dataFinal.toString(),
                    _selectedResearcherIds);
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.save))
        ],
        title: const Text('Cadastrar Projeto'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff004c9e),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Título',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: empresaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Empresa Patrocinadora',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Valor Investido',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: referenciaController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Referências',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: 'Descrição',
                ),
                maxLines: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              MultiSelectDialogField(
                isDismissible: true,
                dialogHeight: 300,
                backgroundColor: Colors.grey.shade200,
                decoration: BoxDecoration(
                    border: null,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12),
                searchable: true,
                items: _pesquisadores
                    .map((pesquisador) => MultiSelectItem<String>(
                    pesquisador['nome'], pesquisador['nome']))
                    .toList(),
                onConfirm: (values) {
                  setState(() {
                    _selectedResearcherIds = values;
                  });
                },
                title: const Text("Integrantes"),
                buttonText: const Text("Integrantes"),
                selectedColor: Colors.blue,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _dataInicial(context),
                        child: Text(
                          dataInicial == null
                              ? 'Data Inicial'
                              : 'Início: ${dataInicial?.day}/${dataInicial?.month}/${dataInicial?.year}',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: noDataFinal ? null : () => _dataFinal(context),
                        child: Text(dataFinal == null
                            ? 'Data Final'
                            : 'Fim: ${dataFinal?.day}/${dataFinal?.month}/${dataFinal?.year}'),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: noDataFinal,
                    onChanged: (value) {
                      setState(() {
                        noDataFinal = value!;
                        if (noDataFinal) {
                          dataFinal = null;
                        }
                      });
                    },
                  ),
                  const Text('Sem Data Final')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
