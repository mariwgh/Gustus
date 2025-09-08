class Prato {
  final int idPrato;    
  final String prato;  
  final String foto;    
  final String descricao; 
  final String linkReceita;

  Prato({
    required this.idPrato,
    required this.prato,
    required this.foto,
    required this.descricao,
    required this.linkReceita,
  });

  factory Prato.fromJson(Map<String, dynamic> json) {
    return Prato(
      idPrato: json['idprato'],
      prato: json['prato'],
      foto: json['foto'],
      descricao: json['descricao'],
      linkReceita: json['linkreceita'] ?? '',
    );
  }
}
