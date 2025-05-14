import 'package:shared_preferences/shared_preferences.dart';

class AjustesController {
  Future<Map<String, String>> carregarConfiguracoes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final configs = {
      'host': prefs.getString('host') ?? '',
      'porta': prefs.getString('porta') ?? '',
      'database': prefs.getString('database') ?? '',
      'usuario': prefs.getString('usuario') ?? '',
      'senha': prefs.getString('senha') ?? '',
      'ssl': prefs.getString('ssl') ?? 'ativado',
    };

    return configs;
  }

  Future<void> salvarConfiguracoes(String host, String porta, String database,
      String usuario, String senha, String ssl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('host', host);
    await prefs.setString('porta', porta);
    await prefs.setString('database', database);
    await prefs.setString('usuario', usuario);
    await prefs.setString('senha', senha);
    await prefs.setString('ssl', ssl);
  }
}
