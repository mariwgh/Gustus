class Usuario {
  final int idUsuario;  
  final String usuario; 
  final String email;  
  final String senha; 

  Usuario({
    required this.idUsuario,
    required this.usuario,
    required this.email,
    required this.senha,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idusuario'],
      usuario: json['usuario'],
      email: json['email'],
      senha: json['senha'],
    );
  }
}
