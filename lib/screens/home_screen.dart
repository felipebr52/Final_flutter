import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  BancoService bancoProduto = BancoService();
  List<ProdutoModel> _listaCompra = [];

  @override
  void initState(){
    super.initState();
    _carregarListaCompra();
  }

  void abrirFormulario({ProdutoModel? produto}){
    //talvez volto aqui
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(produto == null? "Adicionar Produto":"Editar Produto"),
          content: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Nome do Produto"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Descrição do Produto"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Preço do Produto"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Quantidade do Produto"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Categoria do Produto"),
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
                  id: produto?.id,
                  nome:nomeProdutoController.text,
                  descricao:descricaoProdutoController.text, 
                  preco:double.parse(precoProdutoController.text),
                  quantidade:int.parse(quantidadeProdutoController.text),
                );
                print(produto)
                _salvarProduto(dadosProduto);
              },
              child: Text("Salvar")
            )
          ],
        );
      },
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
                title:Text(produto.nomeProduto),
                subtitle:Text("R\$ ${produto.preco}-${preco-quantidade}"),
                leading: Icon(icon, color: Colors.blue[500]),
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
          onPressed: _adicionarProduto,
          child: const Icon(Icons.add),
        ),

      );
    
  }
}