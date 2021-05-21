class Cafe{
  late String id;
  late String nome;
  late String preco;

  // Contrutor
  Cafe(this.id, this.nome, this.preco);

  // Coverter documento em objeto
  Cafe.fromJson(Map<String, dynamic> mapa, String id){
    this.id = id;
    this.nome = mapa['nome'];
    this.preco = mapa['preco'];
  }
  
  //Converter um OBJETO em um DOCUMENTO
  Map<String,dynamic> toJson(){
    return {
      'id'    : this.id,
      'nome'  : this.nome,
      'preco' : this.preco,
    };
  }

}