class Wishlist {
  final int idWishlist;
  final int idUsuario;   
  final int idPrato;    

  Wishlist({
    required this.idWishlist,
    required this.idUsuario,
    required this.idPrato,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      idWishlist: json['idwishlist'],
      idUsuario: json['idusuario'],
      idPrato: json['idprato'],
    );
  }
}
