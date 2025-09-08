class Favorito {
  final int idFavorito;   
  final int idUsuario;  
  final int idPrato;   

  Favorito({
    required this.idFavorito,
    required this.idUsuario,
    required this.idPrato,
  });

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
      idFavorito: json['idfavorito'],
      idUsuario: json['idusuario'],
      idPrato: json['idprato'],
    );
  }
}
