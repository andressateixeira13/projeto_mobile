class Activity {
  final int id;
  final String nomeAtiv;
  final String descricao;
  final String? data;
  final String? situacao;
  final String? descricaoSituacao;
  final String? foto;
  final String? feedback;
  final int? tipoAtividade;
  final int? funcionario;
  final int? ambiente;

  Activity({
    required this.id,
    required this.nomeAtiv,
    required this.descricao,
    required this.data,
    required this.situacao,
    required this.descricaoSituacao,
    required this.foto,
    required this.feedback,
    required this.tipoAtividade,
    required this.funcionario,
    required this.ambiente,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      nomeAtiv: json['nomeAtiv'] ?? 'Sem nome',
      descricao: json['descricao'] ?? 'Sem descrição',
      data: json['data']?.toString(), // Garante String ou null
      situacao: json['situacao']?.toString(), // idem
      descricaoSituacao: json['descricaoSituacao']?.toString(),
      foto: json['foto']?.toString(),
      feedback: json['feedback']?.toString(),
      tipoAtividade: json['tipoAtividade'],
      funcionario: json['funcionario'],
      ambiente: json['ambiente'],
    );
  }

}
