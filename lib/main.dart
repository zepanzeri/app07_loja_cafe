import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'model/Cafe.dart';

Future<void> main() async {
  //Registrar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/principal',
    routes: {
      '/principal': (context) => TelaPrincipal(),
      '/cadastro': (context) => TelaCadastro(),
    },
  ));

  //
  // Teste do FIRESTORE
  //
  /*
  var db = FirebaseFirestore.instance;
  //Adicionar um novo documento a coleção
  db.collection('cafes').add(
    {
      'nome'  : 'Café Fatec Ribeirão Preto 1kg',
      'preco' : '19,58',
    }
  );
  */

}

//
// TELA PRINCIPAL
//
class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

  //Referenciar a coleção nomeada "cafes"
  late CollectionReference cafes;

  @override
  void initState(){
    super.initState();
    cafes = FirebaseFirestore.instance.collection('cafes');
  }

  //Aparência do item do ListView
  Widget exibirDocumento(item){

    //Converter um DOCUMENTO em um OBJETO
    Cafe cafe = Cafe.fromJson(item.data(), item.id);

    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: Text(cafe.nome, style: TextStyle(fontSize: 24)),
        subtitle: Text('R\$ ${cafe.preco}', style: TextStyle(fontSize: 22)),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: (){
            //
            // Apagar um documento
            //


          },
        ),

      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Café Store'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      backgroundColor: Colors.brown[50],

      //
      // EXIBIR os documentos da coleção de "cafes"
      //
      body: Container(
        padding: EdgeInsets.all(30),
        
        child: StreamBuilder<QuerySnapshot>(

          //fonte de dados
          stream: cafes.snapshots(),

          //definir a aparência dos documentos que serão exibidos
          builder: (context,snapshot){

            switch(snapshot.connectionState){

              case ConnectionState.none:
                return Center(child:Text('Erro ao conectar ao Firestore'));

              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());

              default:
                final dados = snapshot.requireData;

                return ListView.builder(
                  itemCount: dados.size,
                  itemBuilder: (context, index){
                    return exibirDocumento(dados.docs[index]);
                  }
                );


            }
            
          }
        ),

      ),




      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.brown,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro');
        },
      ),
    );
  }
}

//
// TELA CADASTRO
//
class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  var txtNome = TextEditingController();
  var txtPreco = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Café Store'),
        centerTitle: true,
        backgroundColor: Colors.brown,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.brown[50],
      body: Container(
        padding: EdgeInsets.all(30),
        child: ListView(children: [
          TextField(
            controller: txtNome,
            style: TextStyle(color: Colors.brown, fontSize: 36),
            decoration: InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(color: Colors.brown, fontSize: 22),
            ),
          ),
          SizedBox(height: 30),
          TextField(
            controller: txtPreco,
            style: TextStyle(color: Colors.brown, fontSize: 36),
            decoration: InputDecoration(
              labelText: 'Preço',
              labelStyle: TextStyle(color: Colors.brown, fontSize: 22),
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 150,
                child: OutlinedButton(
                  child: Text('salvar'),
                  onPressed: () {},
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 150,
                child: OutlinedButton(
                  child: Text('cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
