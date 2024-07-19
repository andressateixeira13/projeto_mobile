class Activity {
  final int id;
  final String nomeAtiv;
  final String descricao;
  final String data;
  final int tipoAtividade;
  final int funcionario;
  final int ambiente;

  Activity({
    required this.id,
    required this.nomeAtiv,
    required this.descricao,
    required this.data,
    required this.tipoAtividade,
    required this.funcionario,
    required this.ambiente,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      nomeAtiv: json['nomeAtiv'],
      descricao: json['descricao'],
      data: json['data'],
      tipoAtividade: json['tipoAtividade'],
      funcionario: json['funcionario'],
      ambiente: json['ambiente'],
    );
  }
}
