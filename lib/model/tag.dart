class Tag {
  final String nome;
  final String descricao;
  final String dificuldade;
  final String culinaria;

  Tag({
    required this.nome,
    required this.descricao,
    required this.dificuldade,
    required this.culinaria,
  });

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      nome: map['nome'],
      descricao: map['descricao'],
      dificuldade: map['dificuldade'],
      culinaria: map['culinaria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'dificuldade': dificuldade,
      'culinaria': culinaria,
    };
  }
}
