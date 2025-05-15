import 'dart:typed_data';
import 'package:cookbook/model/receita.dart';
import 'package:cookbook/model/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String? erroAddTag;
String? erroCriarBanco;
String? erroConectarBanco;

class Banco {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cookbook.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tags (
        nome TEXT,
        descricao TEXT PRIMARY KEY,
        dificuldade TEXT,
        culinaria TEXT,
        categoria TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS receitas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        tempoPreparo TEXT,
        modoPreparo TEXT,
        ingredientes TEXT,
        tags TEXT,
        imagem BLOB
      )
    ''');
  }

  Future<void> salvarTag(Tag tag) async {
    final db = await database;
    
    final List<Map<String, dynamic>> tags = await db.query(
      'tags',
      where: 'descricao = ?',
      whereArgs: [tag.descricao],
    );

    final Map<String, dynamic> tagData = {
      'nome': tag.nome,
      'descricao': tag.descricao,
      'dificuldade': tag.dificuldade,
      'culinaria': tag.culinaria,
      'categoria': tag.categoria,
    };

    if (tags.isEmpty) {
      await db.insert('tags', tagData);
    } else {
      await db.update(
        'tags',
        tagData,
        where: 'descricao = ?',
        whereArgs: [tag.descricao],
      );

      final List<Map<String, dynamic>> receitas = await db.query('receitas');
      for (var receita in receitas) {
        List<String> tagsReceita = (receita['tags'] as String).split(',');
        if (tagsReceita.contains(tags[0]['nome'])) {
          tagsReceita = tagsReceita.map((t) => t == tags[0]['nome'] ? tag.nome : t).toList();
          
          await db.update(
            'receitas',
            {'tags': tagsReceita.join(',')},
            where: 'id = ?',
            whereArgs: [receita['id']],
          );
        }
      }
    }
  }

  Future<void> removerTag(String nome) async {
    final db = await database;
    
    final List<Map<String, dynamic>> receitas = await db.query('receitas');
    for (var receita in receitas) {
      List<String> tagsReceita = (receita['tags'] as String).split(',');
      if (tagsReceita.contains(nome)) {
        tagsReceita.remove(nome);
        
        await db.update(
          'receitas',
          {'tags': tagsReceita.join(',')},
          where: 'id = ?',
          whereArgs: [receita['id']],
        );
      }
    }

    await db.delete(
      'tags',
      where: 'nome = ?',
      whereArgs: [nome],
    );
  }

  Future<List<Receita>> listarReceitas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('receitas', orderBy: 'nome');

    return List.generate(maps.length, (i) {
      return Receita(
        id: maps[i]['id'] as int,
        nome: maps[i]['nome'] as String,
        tempoPreparo: maps[i]['tempoPreparo'] as String,
        modoPreparo: maps[i]['modoPreparo'] as String,
        ingredientes: maps[i]['ingredientes'] as String,
        tags: (maps[i]['tags'] as String).split(','),
        imagem: maps[i]['imagem'] as Uint8List?,
      );
    });
  }

  Future<Uint8List?> carregarImagemReceita(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'receitas',
      columns: ['imagem'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty && maps[0]['imagem'] != null) {
      return maps[0]['imagem'] as Uint8List;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> listarTags() async {
    final db = await database;
    return await db.query('tags', orderBy: 'nome');
  }

  Future<void> removerReceita(String nome) async {
    final db = await database;
    await db.delete(
      'receitas',
      where: 'nome = ?',
      whereArgs: [nome],
    );
  }

  Future<void> salvarReceita(Receita receita) async {
    final db = await database;
    await db.insert(
      'receitas',
      {
        'nome': receita.nome,
        'tempoPreparo': receita.tempoPreparo,
        'modoPreparo': receita.modoPreparo,
        'ingredientes': receita.ingredientes,
        'tags': receita.tags.join(','),
        'imagem': receita.imagem,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> atualizarReceita(Receita receita) async {
    final db = await database;
    await db.update(
      'receitas',
      {
        'nome': receita.nome,
        'tempoPreparo': receita.tempoPreparo,
        'modoPreparo': receita.modoPreparo,
        'ingredientes': receita.ingredientes,
        'tags': receita.tags.isEmpty ? '' : receita.tags.join(','),
        if (receita.imagem != null) 'imagem': receita.imagem,
      },
      where: 'id = ?',
      whereArgs: [receita.id],
    );
  }
}
