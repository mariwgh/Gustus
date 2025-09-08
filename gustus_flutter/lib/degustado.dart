class Degustado {
  final int idDegustado;  
  final int idUsuario;    
  final int idPrato;     
  final int? nota;       
  final String? descricao; 

  Degustado({
    required this.idDegustado,
    required this.idUsuario,
    required this.idPrato,
    this.nota,
    this.descricao,
  });

  factory Degustado.fromJson(Map<String, dynamic> json) {
    return Degustado(
      idDegustado: json['iddegustado'],
      idUsuario: json['idusuario'],
      idPrato: json['idprato'],
      nota: json['nota'],
      descricao: json['descricao'],
    );
  }
}
