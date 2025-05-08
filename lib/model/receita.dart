import 'dart:typed_data';

class Receita {
  final int? id;
  final String nome;
  final String tempoPreparo;
  final String ingredientes;
  final String modoPreparo;
  final List<String> tags;
  final Uint8List? imagem;

  Receita({
    this.id,
    required this.nome,
    required this.tempoPreparo,
    required this.ingredientes,
    required this.modoPreparo,
    required this.tags,
    required this.imagem,
  });

  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      nome: map['nome'],
      tempoPreparo: map['tempoPreparo'],
      ingredientes: map['ingredientes'],
      modoPreparo: map['modoPreparo'],
      tags: map['tags'].toString().replaceAll('{', '').replaceAll('}', '').split(','),
      imagem: map['imagem'],
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tempoPreparo': tempoPreparo,
      'ingredientes': ingredientes,
      'modoPreparo': modoPreparo,
      'tags': tags.join(','),
      'imagem': imagem,
    };
  }
}
