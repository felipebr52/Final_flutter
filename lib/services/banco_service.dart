import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/produto_model.dart';




class BancoService {
  Database? bancoDeDados;

  Future<Database> abriBanco() async {
    if (bancoDeDados != null) {
      //diferente
      return bancoDeDados!;
    }

    // data/user/0/com.seuapp/databases/produtos.db
    final caminho = join(await getDatabasesPath(), 'produtos.db');
    bancoDeDados = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE produtos(
               idProduto INTEGER PRIMARY KEY AUTOINCREMENT,
               nomeProduto TEXT,
               categoriaProduto TEXT,
               precoProduto REAL,
               quantidadeProduto INTEGER,
                statusProduto TinyINT(1)
            )''');
      },
    );
    return bancoDeDados!;
          
      }


  
   Future<List<ProdutoModel>> obterprodutos() async {
    try {
      final db = await abriBanco();
      final List<Map<String, dynamic>> dados = await db.query("produtos");
      final lista = dados.map((item) => ProdutoModel.fromMap(item)).toList();
      return lista;
    } catch (erro) {
      print(erro.toString());
      return [];
    }
  }

  Future<int> inserirProduto(ProdutoModel produto) async {
    try {
      final db = await abriBanco();
      final id = await db.insert('produtos', produto.toMap());
      return id;
    } catch (erro) {
      return 0;
    }
  }

  Future<int> atualizarProduto(ProdutoModel produto) async {
    try {
      final db = await abriBanco();
      final valores = Map<String, dynamic>.from(produto.toMap());
      valores.remove('idProduto');
      final id = await db.update(
        'produtos',
        valores,
        where: 'idProduto = ?',
        whereArgs: [produto.idProduto],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (erro) {
      print(erro.toString());
      return 0;
    }
  }

  Future<int> deletarProduto(int id) async {
    final db = await abriBanco();
    return await db.delete('produtos', where: 'idProduto = ?', whereArgs: [id]);
  }
  
  
}
  
  
  
  
  
  
  
  
  
  
  
  

