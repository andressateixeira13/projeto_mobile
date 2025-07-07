class Ambiente {
  final int id;
  final String rua;
  final String cep;
  final String bairro;
  final String numero;
  final String sala;
  final String complemento;
  final String predio;
  final String setor;

  Ambiente({
    required this.id,
    required this.rua,
    required this.cep,
    required this.bairro,
    required this.numero,
    required this.sala,
    required this.complemento,
    required this.predio,
    required this.setor,
  });

  factory Ambiente.fromJson(Map<String, dynamic> json) {
    return Ambiente(
      id: json['codAmb'],
      rua: json['rua'] ?? '',
      cep: json['cep'] ?? '',
      bairro: json['bairro'] ?? '',
      numero: json['numero'] ?? '',
      sala: json['sala'] ?? '',
      complemento: json['complemento'] ?? '',
      predio: json['predio'] ?? '',
      setor: json['setor'] ?? '',
    );
  }
}
