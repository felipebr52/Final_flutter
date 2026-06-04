class ProdutoModel {
  final String nomeProduto;
  final int quantidadeProduto;
  final double precoProduto;
  final int? idProduto;
  final String? categoriaProduto;
  final int? statusProduto;

  ProdutoModel({
    this.idProduto,
    required this.nomeProduto,
    required this.quantidadeProduto,
    required this.precoProduto,
    this.categoriaProduto,
    this.statusProduto,
  });

  //fabrica factory (transformo objeto do banco em Map)
  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      nomeProduto: map['nomeProduto'],
      quantidadeProduto: map['quantidadeProduto'],
      precoProduto: map['precoProduto'],
      idProduto: map['idProduto'],
      categoriaProduto: map['categoriaProduto'],
      statusProduto: map['statusProduto'],
    );
  }
  // Map para objeto
  Map<String, dynamic> toMap() {
    return {
      'nomeProduto': nomeProduto,
      'quantidadeProduto': quantidadeProduto,
      'precoProduto': precoProduto,
      'idProduto': idProduto,
      'categoriaProduto': categoriaProduto,
      'statusProduto': statusProduto,
    };
  }
}