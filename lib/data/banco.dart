import 'dart:convert';
import 'dart:typed_data';

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
  Uint8List? imagembanco;

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
    tags TEXT,
    imagem BYTEA
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

  Future<void> removerTag(String nome) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      DELETE FROM tags 
      WHERE nome = '$nome'
      ''');
    await conn.close();
  }

  

  Future<List<Receita>> listarReceitas() async {
    Connection conn = await conectarbanco();

    final results = await conn.execute(
      Sql.named('SELECT id, nome, tempoPreparo, modoPreparo, ingredientes, tags, imagem FROM receitas ORDER BY nome'),
    );
    

    List<Receita> receitas = [];
    for (var row in results) {
      receitas.add(Receita(
        id: row[0] as int,
        nome: row[1] as String,
        tempoPreparo: row[2] as String,
        modoPreparo: row[3] as String,
        ingredientes: row[4] as String,
        tags: (row[5] as String).split(','),
        imagem: row[6] as Uint8List?,

      ));
    }

    await conn.close();
    return receitas;
  }

Future<Uint8List?> carregarImagemReceita(int id) async {
    Connection conn = await conectarbanco();

    final results = await conn.execute(
      Sql.named('SELECT imagem FROM receitas WHERE id = @id'),
      parameters: {'id': id},
    );

    Uint8List? imagem;
    if (results.isNotEmpty) {
      imagem = results[0][0] as Uint8List?;
    }

    await conn.close();
    return imagem;
  }

  Future<List<String>> listarTags() async {
    Connection conn = await conectarbanco();

    final results = await conn.execute(
      Sql.named('SELECT nome FROM tags ORDER BY nome'),
    );
    List<String> tags = [];

    for (var row in results) {
      tags.add(row[0] as String);
    }

    await conn.close();
    return tags;
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
  try {
    final conn = await conectarbanco();
    
    String? imagemBase64;
    if (receita.imagem != null) {
      imagemBase64 = base64Encode(receita.imagem!);
    }
    
    await conn.execute(
      Sql.named('''
        INSERT INTO public.receitas (nome, tempoPreparo, modoPreparo, ingredientes, tags, imagem)
        VALUES (@nome, @tempoPreparo, @modoPreparo, @ingredientes, @tags, decode(@imagem, 'base64'))
      '''),
      parameters: {
        'nome': receita.nome,
        'tempoPreparo': receita.tempoPreparo,
        'modoPreparo': receita.modoPreparo,
        'ingredientes': receita.ingredientes,
        'tags': receita.tags.join(','),
        'imagem': imagemBase64,
      },
    );
    
    await conn.close();
  } catch (e) {
    print('Erro ao salvar receita: $e');
    rethrow;
  }
}


}
