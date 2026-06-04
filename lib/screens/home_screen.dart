import 'package:flutter/material.dart';
import '../services/banco_service.dart';
import '../model/produto_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  BancoService bancoProduto = BancoService();
  List<ProdutoModel> _listaCompra = [];
  final idProdutoController = TextEditingController();
  final categoriaProdutoController = TextEditingController();
  final nomeProdutoController = TextEditingController();
  final descricaoProdutoController = TextEditingController();
  final precoProdutoController = TextEditingController();
  final quantidadeProdutoController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _carregarListaCompra();
  }

  void abrirFormulario(ProdutoModel? produto){
    //talvez volto aqui
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(produto == null? "Adicionar Produto":"Editar Produto"),
          content: SingleChildScrollView(
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Nome do Produto"),
                  controller: nomeProdutoController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Descrição do Produto"),
                  controller: descricaoProdutoController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Preço do Produto"),
                  controller: precoProdutoController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Quantidade do Produto"),
                  controller: quantidadeProdutoController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Categoria do Produto"),
                  // opcional: adicione controller se quiser salvar categoria
                )
              ],
            )
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                final dadosProduto=ProdutoModel(
                  idProduto: produto?.idProduto,
                      nomeProduto: nomeProdutoController.text,
                      categoriaProduto: categoriaProdutoController.text,  
                      precoProduto: double.tryParse(precoProdutoController.text) ?? 0.0,
                      quantidadeProduto: int.tryParse(quantidadeProdutoController.text) ?? 0,
                );
                print(produto);
                _salvarProduto(dadosProduto);
              },
              child: Text("Salvar")
            )
          ],
        );
      },
    );
  }

  void _editarProduto(int index) {
    final produto = _listaCompra[index];
    nomeProdutoController.text = produto.nomeProduto;
    descricaoProdutoController.text = produto.categoriaProduto ?? "";
    precoProdutoController.text = produto.precoProduto.toString();
    quantidadeProdutoController.text = produto.quantidadeProduto.toString();
    abrirFormulario(produto);
  }

  void _excluirProduto(int index) async {
    final produto = _listaCompra[index];
    if (produto.idProduto != null) {
      await bancoProduto.deletarProduto(produto.idProduto!);
      _carregarListaCompra();
    }
  }

  @override
  void dispose() {
    nomeProdutoController.dispose();
    descricaoProdutoController.dispose();
    precoProdutoController.dispose();
    quantidadeProdutoController.dispose();
    super.dispose();
  }

  void _carregarListaCompra() async {
    final produtos = await bancoProduto.obterprodutos();
    setState(() {
      _listaCompra = produtos;
    });
  }

  void _salvarProduto(ProdutoModel produto) async {
    bool modoedicao = produto.idProduto == null;

    if(modoedicao){
      await bancoProduto.inserirProduto(produto);
    }else{
      await bancoProduto.atualizarProduto(produto);
    }
    _carregarListaCompra();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(modoedicao? "Produto adicionado com sucesso!":"Produto atualizado com sucesso!"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: RefreshIndicator(
        onRefresh: ()async => _carregarListaCompra(),
        child: _listaCompra.isEmpty?Center(child:Text("não há itens na lista de compras!!")):ListView.builder(
          itemCount: _listaCompra.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child:ListTile(
                title:Text(_listaCompra[index].nomeProduto),
                subtitle:Text("R\$ ${_listaCompra[index].precoProduto}-${_listaCompra[index].quantidadeProduto}"),
                leading: Icon(Icons.shopping_cart, color: Colors.blue[500]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        _editarProduto(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _excluirProduto(index);
                      },
                    ),
                  ],
                ),
              ),
            );
            },
        ), 
        ),

        drawer: Container(),
        endDrawer: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed:() =>abrirFormulario(null),
          child: const Icon(Icons.add),
        ),

      );
    
  }
}