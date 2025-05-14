import 'package:flush/ajustes/ajustes.dart';
import 'package:flutter/material.dart';
import '../data/banco.dart';
import 'main.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  AjustesState createState() => AjustesState();
}

class AjustesState extends State<Ajustes> {
  Banco banco = Banco();
  AjustesController controller = AjustesController();

  String? _ssl;
  bool passwordVisible = true;

  final List<DropdownMenuItem<String>> _items = [
    const DropdownMenuItem(
      value: "ativado",
      child: Text('Ativado'),
    ),
    const DropdownMenuItem(
      value: "desativado",
      child: Text('Desativado'),
    ),
    // ... outros itens
  ];

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portaController = TextEditingController();
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> salvarconfig() async {
    await controller.salvarConfiguracoes(
        _hostController.text,
        _portaController.text,
        _databaseController.text,
        _usuarioController.text,
        _senhaController.text,
        _ssl ?? 'ativado');
  }

  @override
  void initState() {
    super.initState();
    controller.carregarConfiguracoes().then((configs) {
      setState(() {
        _hostController.text = configs['host'] ?? '';
        _portaController.text = configs['porta'] ?? '';
        _databaseController.text = configs['database'] ?? '';
        _usuarioController.text = configs['usuario'] ?? '';
        _senhaController.text = configs['senha'] ?? '';
        _ssl = configs['ssl'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 243, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 49, 49),
        foregroundColor: const Color.fromARGB(255, 253, 243, 243),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              try {
                await salvarconfig();
                await banco.criarbanco();
              } catch (e) {
                setState(() async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(erroConectarBanco!)));
                });
              }
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Inicio()),
                  (Route<dynamic> route) => false,
                );
                setState(() async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Conectado com Sucesso")));
                });
              }
            },
          ),
        ],
        title: const Text('Ajustes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
              TextField(
                keyboardType: TextInputType.url,
                autocorrect: false,
                controller: _hostController,
                decoration: InputDecoration(
                  labelText: "Host",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 225, 224, 224),
                  prefixIcon: const Icon(Icons.computer),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _portaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Porta",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 225, 224, 224),
                    prefixIcon: const Icon(Icons.people),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _databaseController,
                  decoration: InputDecoration(
                    labelText: "Database",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 225, 224, 224),
                    prefixIcon: const Icon(Icons.storage),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    labelText: "Usuario",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 225, 224, 224),
                    prefixIcon: const Icon(Icons.people),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _senhaController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusColor: Colors.blue,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 225, 224, 224),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: DropdownButtonFormField<String>(
                  value: _ssl ?? 'ativado',
                  borderRadius: BorderRadius.circular(20),
                  decoration: InputDecoration(
                    labelText: 'SSL',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 225, 224, 224),
                  ),
                  items: _items,
                  onChanged: (String? newValue) {
                    setState(() {
                      _ssl = newValue!;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
