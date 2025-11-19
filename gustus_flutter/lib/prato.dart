// String _corrigirCodificacao(String textoCorrompido) {
//   // Isso resolve os problemas de Latin-1/ISO quebrando em UTF-8 (CamarÆo -> Camarão, A‡aí -> Açaí)
//   String corrigido = textoCorrompido
//       .replaceAll('Æ', 'ã')
//       .replaceAll('‡', 'ç')
//       .replaceAll('¡', 'í')
//       .replaceAll('…', 'à')
//       .replaceAll('ä', 'õ')
//       .replaceAll('ˆ', 'ê');

//   return corrigido;
// }

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
      prato:(json['prato'] as String),
      foto: json['foto'],
      descricao: (json['descricao'] as String),
      linkReceita: json['linkreceita'] ?? '',
    );
  }
}
