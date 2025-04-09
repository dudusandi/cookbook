import 'package:flush/controller/ajustes_controller.dart';
import 'package:postgres/postgres.dart';

String? erroAddPesquisador;
String? erroCriarBanco;
String? erroConectarBanco;

class Banco {
  String? host;
  String? database;
  String? usuario;
  String? senha;
  String? ssl;
  String? port;
  String? portaController;

  Future<Connection> conectarbanco() async {
    AjustesController ajustes = AjustesController();

    try {
      await ajustes.carregarConfiguracoes().then((configs) {
        host = configs['host'] ?? '';
        portaController = configs['porta'] ?? '';
        database = configs['database'] ?? '';
        usuario = configs['usuario'] ?? '';
        senha = configs['senha'] ?? '';
        ssl = configs['ssl'] ?? '';
      });

      SslMode sslMode() {
        return ssl == 'ativado' ? SslMode.require : SslMode.disable;
      }

      final conn = await Connection.open(
        Endpoint(
            host: host!,
            database: database!,
            username: usuario,
            password: senha,
            port: int.parse(portaController ?? '5432')),
        settings: ConnectionSettings(sslMode: sslMode()),
      );
      return conn;
    } catch (e) {
      erroConectarBanco = (e.toString());
      return Future.error(e);
    }
  }

  Future<void> criarbanco() async {
    Connection conn = await conectarbanco();

    await conn.execute('''
    
    CREATE TABLE IF NOT EXISTS public.pesquisadores (
    nome TEXT,
    cpf TEXT PRIMARY KEY,
    tipo TEXT,
    areaconhecimento TEXT,
    projeto TEXT
)

     ''');

    await conn.execute('''
    
    CREATE TABLE IF NOT EXISTS public.pesquisas(
    id SERIAL PRIMARY KEY,
    titulo TEXT,
    descricao TEXT,
    datainicio DATE,
    datafim DATE,
    pesquisadores TEXT,
    empresa TEXT,
    valor TEXT,
    referencia TEXT
    )
    
     ''');

    await conn.close();
  }

  Future<void> adicionarPesquisador(
      String nome, String cpf, String tipo, String area) async {
    Connection conn = await conectarbanco();

    try {
      await conn.execute('''
      
      INSERT INTO pesquisadores (nome, cpf, tipo, areaconhecimento) 
      VALUES ('$nome', '$cpf', '$tipo', '$area')
      
      ''');

      await conn.close();
    } catch (e) {
      erroAddPesquisador = e.toString();
    }
  }

  Future<void> removerPesquisador(String nome) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      DELETE FROM pesquisadores 
      WHERE nome = '$nome'
      ''');
    await conn.close();
  }

  Future<void> removerPesquisa(String titulo) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      DELETE FROM pesquisas
      WHERE titulo = '$titulo'
      ''');
    await conn.close();
  }

  Future<void> salvarProjeto(
      String titulo,
      String empresa,
      String descricao,
      String referencia,
      String valor,
      String? dataInicio,
      String? dataFim,
      List<String> pesquisadores,
      ) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      INSERT INTO public.pesquisas (titulo, descricao, datainicio, datafim, pesquisadores,empresa,valor, referencia)
      VALUES ('$titulo', '$descricao', '$dataInicio', '$dataFim', '$pesquisadores','$empresa', '$valor', '$referencia')
    ''');

    await conn.close();
  }

  Future<List<Map<String, dynamic>>> listarPesquisadores() async {
    Connection conn = await conectarbanco();

    final results = await conn.execute(
      Sql.named('SELECT * FROM pesquisadores ORDER BY nome'),
    );
    List<Map<String, dynamic>> pesquisadores = [];

    for (var row in results) {
      var pesquisador = {
        'nome': row[0],
      };
      pesquisadores.add(pesquisador);
    }

    await conn.close();
    return pesquisadores;
  }
}
