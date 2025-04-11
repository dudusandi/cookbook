class Receita {
  final int? id;
  final String nome;
  final String tempoPreparo;
  final String ingredientes;
  final String modoPreparo;
  final List<String> tags;

  Receita({
    this.id,
    required this.nome,
    required this.tempoPreparo,
    required this.ingredientes,
    required this.modoPreparo,
    required this.tags,
  });

  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      nome: map['nome'],
      tempoPreparo: map['tempoPreparo'],
      ingredientes: map['ingredientes'],
      modoPreparo: map['modoPreparo'],
      tags: map['tags'].toString().replaceAll('{', '').replaceAll('}', '').split(','),
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
    };
  }
}
