import 'package:flush/controller/ajustes_controller.dart';
import 'package:flush/model/receita.dart';
import 'package:flush/model/tag.dart';
import 'package:postgres/postgres.dart';

String? erroAddTag;
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
    
    CREATE TABLE IF NOT EXISTS public.tags (
    nome TEXT,
    descricao TEXT PRIMARY KEY,
    dificuldade TEXT,
    culinaria TEXT,
    projeto TEXT
    )

     ''');

    await conn.execute('''
    
    CREATE TABLE IF NOT EXISTS public.receitas (
    id SERIAL PRIMARY KEY,
    nome TEXT,
    tempoPreparo TEXT,
    modoPreparo TEXT,
    ingredientes TEXT,
    tags TEXT
    )
    
     ''');

    await conn.close();
  }

  Future<void> salvarTag(Tag tag) async {
  Connection conn = await conectarbanco();

  await conn.execute('''
    INSERT INTO tags (nome, descricao, dificuldade, culinaria)
    VALUES ('${tag.nome}', '${tag.descricao}', '${tag.dificuldade}', '${tag.culinaria}')
  ''');

  await conn.close();
}


  // Future<void> adicionarTag(
  //     String nome, String descricao, String dificuldade, String culinaria) async {
  //   Connection conn = await conectarbanco();

  //   try {
  //     await conn.execute('''
      
  //     INSERT INTO tags (nome, descricao, dificuldade, culinaria) 
  //     VALUES ('$nome', '$descricao', '$dificuldade', '$culinaria')
      
  //     ''');

  //     await conn.close();
  //   } catch (e) {
  //     erroAddTag = e.toString();
  //   }
  // }

  Future<void> removerTag(String nome) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      DELETE FROM tags 
      WHERE nome = '$nome'
      ''');
    await conn.close();
  }

  Future<void> removerReceita(String nome) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      DELETE FROM receitas
      WHERE nome = '$nome'
      ''');
    await conn.close();
  }

  Future<void> salvarReceita(Receita receita) async {
  Connection conn = await conectarbanco();

  await conn.execute('''
    INSERT INTO public.receitas (nome, tempoPreparo, modoPreparo, ingredientes, tags)
    VALUES ('${receita.nome}', '${receita.tempoPreparo}', '${receita.modoPreparo}', '${receita.ingredientes}', '${receita.tags.join(',')}')
  ''');

  await conn.close();
}


  // Future<void> salvarReceita(
  //     String nome,
  //     String tempo,
  //     String ingredientes,
  //     String modoPreparo,
  //     List<String> tags,
  //     ) async {
  //   Connection conn = await conectarbanco();

  //   await conn.execute('''
  //     INSERT INTO public.receitas (nome,tempoPreparo,modoPreparo,ingredientes,tags)
  //     VALUES ('$nome', '$tempo', '$modoPreparo','$ingredientes', '$tags')
  //   ''');

  //   await conn.close();
  // }

  Future<List<Map<String, dynamic>>> listarTags() async {
    Connection conn = await conectarbanco();

    final results = await conn.execute(
      Sql.named('SELECT * FROM tags ORDER BY nome'),
    );
    List<Map<String, dynamic>> tags = [];

    for (var row in results) {
      var tag = {
        'nome': row[0],
      };
      tags.add(tag);
    }

    await conn.close();
    return tags;
  }
}
