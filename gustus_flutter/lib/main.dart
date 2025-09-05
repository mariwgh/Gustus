import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; //pacote para abrir links

// main é o primeiro método que o projeto executa
void main() {
  // inicia a aplicação com a classe MyApp.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //construtor da classe
  const MyApp({super.key});

  // construi um widget nesse contexto
  @override
  Widget build(BuildContext context) {
    // MaterialApp é o widget raiz que define o tema e a navegação.
    return MaterialApp(home: TelaBloqueio());
  }
}

// widgets reutilizável 
class BaseBloqueio extends StatelessWidget {
  //final indica que a variável child só pode ser inicializada uma única vez e não pode ser alterado depois
  //child pode ser qualquer outro widget do Flutter que será aninhado dentro de outro 
  final Widget child;

  //construtor da classe e precisa necessariamente ter um child
  const BaseBloqueio({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 43, 64, 1.0),

      //stack é um tipo de layout mais flexível
      body: Stack(
        children: [
          // imagem de fundo com opacidade.
          Opacity(
            opacity: 1, 
            child: Image.asset(
              "assets/fundo.png",
              fit: BoxFit.cover,        //vai encaixar na tela
              height: double.infinity,
              width: double.infinity,
            ),
          ),

          // centraliza o conteúdo (o Container) na tela.
          Center(
            child: Container(
              width: 300.0,                                         //nao tem unidade de medida nada aqui
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.4),  // fundo translúcido.
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,                                 //sombra desfocada
                    offset: const Offset(0, 5),                     //direcao da sombra
                  ),
                ],
              ),

              child: child,           //virao aqui o resto da tela (child) como filho (child) do container
            ),
          )
        ],
      ),
    );
  }
}

class BaseInicial extends StatelessWidget {
  final Widget child;

  const BaseInicial({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 43, 64, 1),

      body: Stack(
        children: [
          // background com opacidade.
          Opacity(
            opacity: 1, 
            child: Image.asset(
              "assets/fundo.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,   // centraliza horizontalmente
              children: [

                //home
                ElevatedButton(
                  //quando pressionado navega para a tela inicial
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaInicial()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,  // botao transparente
                    shadowColor: Colors.transparent,      // botao sem sombra
                    elevation: 0,                           // nao tem elevacao -> nao tem sombra
                  ),
                  child: ClipRRect(           //usado para recortar (ou "clipar") seu widget filho em um retângulo com cantos arredondados
                    child: Image.asset(
                      "assets/home.png", 
                      height: MediaQuery.of(context).size.height * 0.05,  // a altura é 5% da media do tamanho da altura da tela
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
                //search
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaPesquisar()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/search.png", 
                      height: MediaQuery.of(context).size.height * 0.05,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
                //profile
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaConta()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/profile.png", 
                      height: MediaQuery.of(context).size.height * 0.05,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
                //settings
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaConfiguracoes()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/settings.png", 
                      height: MediaQuery.of(context).size.height * 0.05,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // o resto do conteudo sera posicionado completamente p preencherr a tela com uma distancia de 80 do topo
          Positioned.fill(
            top: 80,
            child: child,
          ),
        ],
      ),
    );
  }
}

class MostraProdutos extends StatelessWidget {
  // aqui recebe uma lista de produtos futuramente
  final List<Map<String, String>> produtos; // lista de 'maps' como parametro, ou seja cada elemento da lista tem um nome de tabela (string) com um dado (string), como no exemplo

  // a lista sera dada como vazia se nada for passado
  const MostraProdutos({Key? key, this.produtos = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // exemplo de lista de produtos
    final produtos = [
      {
        "nome": "Risoto de camarão",
        "imagem": "https://raw.githubusercontent.com/mariwgh/Gustus/refs/heads/main/imagens/risoto-de-camarao.png",
        "descricao": "Esse prato popular tem suas raízes na história do risoto italiano, que surgiu na região da Lombardia durante o século XI, influenciado pelos sarracenos.",
        "linkReceita": "https://www.tudogostoso.com.br/receita/185493-risoto-de-camarao-sem-frescura.html"
      },
      {
        "nome": "Ratatouille",
        "imagem": "https://raw.githubusercontent.com/mariwgh/Gustus/refs/heads/main/imagens/ratatouille.png",
        "descricao": "Esse prato popular tem suas raízes na história do risoto italiano, que surgiu na região da Lombardia durante o século XI, influenciado pelos sarracenos.",
        "linkReceita": "https://www.tudogostoso.com.br/receita/185493-risoto-de-camarao-sem-frescura.html"
      },
      {
        "nome": "Sushi",
        "imagem": "https://raw.githubusercontent.com/mariwgh/Gustus/refs/heads/main/imagens/sushi.png",
        "descricao": "Esse prato popular tem suas raízes na história do risoto italiano, que surgiu na região da Lombardia durante o século XI, influenciado pelos sarracenos.",
        "linkReceita": "https://www.tudogostoso.com.br/receita/185493-risoto-de-camarao-sem-frescura.html"
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(50),
      shrinkWrap: true,                 // importante quando está dentro de outra coluna, pois dimensiona-se para o tamanho mínimo sem brigas com outros elementos
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,              // duas colunas
        mainAxisSpacing: 150,           //espaco
        crossAxisSpacing: 150,          //espaco
        childAspectRatio: 1,            // mantém quadrado
      ),
      itemCount: produtos.length,  //quantos items terao na tabela
      itemBuilder: (context, index) {
        final produto = produtos[index];   // percorre cada elemento da lista o transformando em produto

        //cada produto é clicável, e quando clica, vai para a tela de seu produto com mais informacoes
        return GestureDetector(
          onTap: () {
            // navega para a TelaProduto passando os dados (parametros) que serao mostrados
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaProduto(
                  nome: produto["nome"]!,
                  imagem: produto["imagem"]!,
                  descricao: produto["descricao"]!,
                  linkReceita: produto["linkReceita"]!,
                ),
              ),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final largura = constraints.maxWidth; //informa o tamanho máximo e mínimo de largura e altura que o widget pai permite para este LayoutBuilder
              final altura = constraints.maxHeight;

              // a caixa que contem os dados de cada produto
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.4),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(1, 5),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //imagem do produto em sua vez da lista
                    Positioned(
                      top: -altura * 0.15,      // 15% saindo pra cima
                      right: -largura * 0.15,   // 15% saindo pro lado
                      child: Image.network(     //imagem da internet
                        produto["imagem"]!,
                        width: largura * 0.4,   // 40% do container
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,            //alinha para baixo a esquerda
                      child: Padding(
                        padding: EdgeInsets.all(largura * 0.05),  // 5% de padding
                        child: Text(
                          produto["nome"]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: largura * 0.08,             // fonte proporcional 8%
                            fontWeight: FontWeight.bold,          //negrito
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        );
      },
    );
  }
}


class TelaBloqueio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica
    return BaseBloqueio(
      // texto e botoes
      child: Column(
        mainAxisSize: MainAxisSize.min,               // ocupa o mínimo de espaço vertical.
        mainAxisAlignment: MainAxisAlignment.center,  //alinha no centro

        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, //usei row  so para poder colocar o texto a esquerda
              children: [
                const Text(
                  "Gustus",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),                 //espaco vertical entre um elemento e outro

          // botao de entrar
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaLogin()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(188, 192, 198, 1),
              foregroundColor: Colors.black,            //cor do texto e icone que estiverem dentro do btoao
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black.withOpacity(0.1),
              elevation: 5,                               //elevacao de 5, forma uma sombra maior
            ),
            child: const Text("Entrar"),
          ),
          const SizedBox(height: 15),

          // botao de cadastrar
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaCadastro()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(188, 192, 198, 1),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black.withOpacity(0.1),
              elevation: 5,
            ),
            child: const Text("Cadastrar"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}


class TelaCadastro extends StatefulWidget {                  // estado mutável dos campos que o usuario digita
  @override
  State<TelaCadastro> createState() => _TelaCadastroState(); //objeto de estado deve ser gerenciado para TelaCadastro
}

class _TelaCadastroState extends State<TelaCadastro> {
  // declarando controladores para pegar o texto de cada campo -> controlam e obtem o texto digitado em campos de entrada de texto
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // limpa os controladores quando a tela é chamada
  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // função que será chamada quando o botão "Cadastrar" for pressionado e definira as variaveis
  void _cadastrarUsuario() {
    final String usuario = _userController.text;
    final String email = _emailController.text;
    final String senha = _passwordController.text;
    // aqui ele chama outra funcao q manda as variaveis p banco de dados
  }

  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica
    return BaseBloqueio(
      child: Column(
        mainAxisSize: MainAxisSize.min,               // ocupa o mínimo de espaço vertical.
        mainAxisAlignment: MainAxisAlignment.center,  //alinha no centro

        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, //usei row  so para poder colocar o texto a esquerda
              children: [
                const Text(
                  "Cadastro",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _userController,                        //define a variavel que sera usada para ir para o bd
            decoration: InputDecoration(                        //decoracao de lugar que digita
              labelText: "User",                                //texto do campo para digitar
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(              //a borda sera em baixo, como uma linha para escrever
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(              //e quando o usuario clicar, essa borda sera assim (igual)
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "E-mail",
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 25),

          // botao de cadastrar
          ElevatedButton(
            onPressed: () {
              _cadastrarUsuario();                            //funcao que chamara a API
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaInicial()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(188, 192, 198, 1),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black.withOpacity(0.1),
              elevation: 5,
            ),
            child: const Text("Cadastrar"),
          ),
          const SizedBox(height: 25),

          // ja tem conta?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Já tem uma conta?",
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaLogin()),
                  );
                },
                child: const Text(
                  "Entrar",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}


class TelaLogin extends StatefulWidget {                  // estado mutável dos campos que o usuario digita
  @override
  State<TelaLogin> createState() => _TelaLoginState();    //objeto de estado deve ser gerenciado para TelaLogin
}

class _TelaLoginState extends State<TelaLogin> {
  // declarando controladores para pegar o texto de cada campo -> controlam e obtem o texto digitado em campos de entrada de texto
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // limpa os controladores quando a tela é chamada
  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // função que será chamada quando o botão "Entrar" for pressionado e definira as variaveis
  void _verificarUsuario() {
    final String usuario = _userController.text;
    final String senha = _passwordController.text;
    // aqui ele chama outra funcao q manda as variaveis p banco de dados
  }

  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseBloqueio(
      // texto e botoes
      child: Column(
        mainAxisSize: MainAxisSize.min,               // ocupa o mínimo de espaço vertical.
        mainAxisAlignment: MainAxisAlignment.center,  //alinha no centro

        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, //usei row  so para poder colocar o texto a esquerda
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _userController,                        //define a variavel que sera usada para ir para o bd
            decoration: InputDecoration(                        //decoracao de lugar que digita
              labelText: "User",                                //texto do campo para digitar
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(              //a borda sera em baixo, como uma linha para escrever
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(              //e quando o usuario clicar, essa borda sera assim (igual)
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 25),

          // botao de entrar
          ElevatedButton(
            onPressed: () {
              _verificarUsuario();                              //funcao que chamara a API
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaInicial()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(188, 192, 198, 1),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black.withOpacity(0.1),
              elevation: 5,
            ),
            child: const Text("Entrar"),
          ),
          const SizedBox(height: 25),

          // nao tem conta?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Não tem uma conta?",
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaCadastro()),
                  );
                },
                child: const Text(
                  "Cadastrar",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}


class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseInicial(
      child: MostraProdutos(),
      //child: MostraProdutos(produtos: [],), -> quando tiver a api, passar como parametro
    );
  }
}


class TelaProduto extends StatefulWidget {
  // parametros necessarios para poder apresentar o produto
  final String nome;
  final String imagem;
  final String descricao;
  final String linkReceita;

  //construtor que pede os parametros
  const TelaProduto({Key? key, required this.nome, required this.imagem, required this.descricao, required this.linkReceita}) : super(key: key);

  @override
  State<TelaProduto> createState() => _TelaProduto();
}

class _TelaProduto extends State<TelaProduto>{

  void _adicionarOuRemoverFavoritos() {   // a implementar
    final String usuario;
    widget.nome;          //com widget pois o pega o parametro da classe q ele extende
  }

  void abrirPaginaWeb(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // abre no navegador
        );
      } 
      else {
        throw 'Não foi possível abrir $url';
      }
    } 
    catch (e) {
      print('Erro ao tentar abrir o URL: $e'); // imprime o erro no console
    }
  }

  void _removerOuAdicionarWishlist() {    // a implementar
    final String usuario;
    widget.nome;          //com widget pois o pega o parametro da classe q ele extende
  }

 @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return BaseInicial(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none, // permite que a imagem saia do Stack
              children: [
                
                Padding(
                  padding: EdgeInsetsGeometry.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  // espaça os elementos
                    children: [
                      // posiciona o nome do produto 
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          widget.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // faz com que o coracao seja clicavel
                      GestureDetector(            
                        onTap: () {
                          _adicionarOuRemoverFavoritos();
                        },
                        child: Positioned(
                          top: 20,
                          right: 30,
                          child: Icon(
                            Icons.favorite_border, // coração vazio
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      )
                    ]
                  ),
                ),
                  
                // imagem do produto
                Align(
                  alignment: Alignment.centerRight,       // joga para a direita
                  child: FractionalTranslation(
                    translation: const Offset(0.3, 0.3),  // metade para fora
                    child: Container(
                      width: largura * 0.7,
                      height: largura * 0.7,              // altura da imagem para um bom aspecto
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.imagem),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // box/container cinza que fica em baixo com descricao e botoes
            Container(
              height: MediaQuery.of(context).size.height * 0.5,   // metade da tela
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.4),
                borderRadius: BorderRadius.only(                 // bordas somente em cima
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column (
                children: [
                  // descricao
                  Text(
                    widget.descricao,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // botao de receita
                  ElevatedButton(
                    onPressed: () {
                      abrirPaginaWeb(widget.linkReceita);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,            // fundo transparente
                      foregroundColor: Colors.black,                  // cor do texto e ícone
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black),  // borda preta
                      ),
                      elevation: 0,                                     // remove sombra
                    ),
                    child: const Text("Receita",),
                  ),
                  const SizedBox(height: 15),

                  // linha que fica os ultimos dois botoes
                  Row(
                    children: [
                      //botao wishlist
                      Expanded(                  // preenche o espaço disponível proporcionalmente
                        child: ElevatedButton(
                          onPressed: () {
                            _removerOuAdicionarWishlist();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,            // fundo transparente
                            foregroundColor: Colors.black,                  // cor do texto e ícone
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.black),  // borda preta
                            ),
                            elevation: 0,                                     // remove sombra
                          ),
                          child: const Text("Wishlist/Remover",),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // botao degustar que leva p tela de avaliar
                      Expanded(child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TelaAvaliar())
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,            // fundo transparente
                          foregroundColor: Colors.black,                  // cor do texto e ícone
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black),  // borda preta
                          ),
                          elevation: 0,                                     // remove sombra
                        ),
                        child: const Text("Degustar",),
                        ),
                      ),
                    ],
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TelaPesquisar extends StatefulWidget {
  @override
  State<TelaPesquisar> createState() => _TelaPesquisarState();
}

class _TelaPesquisarState extends State<TelaPesquisar> {
  final TextEditingController _pesquisaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseInicial(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _pesquisaController,          // para passarmos como parametro da lista de produtos
              decoration: InputDecoration(
                hintText: "Pesquisar",                  // texto que funciona como hint (dica) para sugerir o que o usuario deve escrever no campo input
                prefixIcon: Icon(                       // icone de lupa do proprio flutter
                  Icons.search, 
                  color: const Color.fromARGB(255, 0, 0, 1)),
                filled: true,                           // preenche com a cor absixo
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 1)
              ),
            ),
          ),
          Expanded(                                     // faz o GridView de mostraProdutos ocupar o resto da tela
            child: MostraProdutos(), 
          ),
        ],
      ),
    );
  }
}


class TelaConta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseInicial(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Conta",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                children: [
                  //favoritos
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 96, 106, 121),       // cor de fundo do container
                      border: Border(
                        top: BorderSide(color: Colors.white, width: 2),     // temos borda so em cima e em baixo
                        bottom: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    child: Row(         // container fica como linha 
                      children: [
                        Text(
                          "Favoritos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MostraProdutos(),
                  const SizedBox(height: 25),
                
                  //wishlist
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaWishlist())
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 96, 106, 121), // cor de fundo
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 2),
                          bottom: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Wishlist",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),               // empurra o ícone para a direita
                          const Icon(
                            Icons.arrow_forward_ios,    // seta horizontal
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  MostraProdutos(),
                  const SizedBox(height: 25),

                  //degustados
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaDegustados())
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 96, 106, 121), // cor de fundo
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 2),
                          bottom: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Degustados",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),             // empurra o ícone para a direita
                          const Icon(
                            Icons.arrow_forward_ios,  // seta horizontal
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  MostraProdutos(),
                ],
              )
            ),
          ]
        ),
      ),
    );
  }
}


class TelaConfiguracoes extends StatefulWidget {
  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoes();
}

class _TelaConfiguracoes extends State<TelaConfiguracoes> {
  // declarando controladores para pegar o texto de cada campo.
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // limpa os controladores quando a tela é chamada
  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _sairConta() {
    // a implementar
  }

  _excluirConta() {
    // a implementar
  }

  // função que será chamada quando o botão "Salvar" for pressionado e definira as variaveis
  void _salvarUsuario() {
    final String usuario = _userController.text;
    final String email = _emailController.text;
    final String senha = _passwordController.text;
    // aqui ele chama outra funcao q manda as variaveis p banco de dados
  }

  @override
  Widget build(BuildContext context) {
    return BaseInicial(
      child: BaseBloqueio(
        child: Column(
          mainAxisSize: MainAxisSize.min,             // ocupa o mínimo de espaço vertical.

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ 
                Text(
                  "Configurações",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ]
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: "User",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 25),

            //botao sair
            ElevatedButton(
              onPressed: () {
                _sairConta();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaBloqueio()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,                                  // fundo transparente
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),            // cor do texto e ícone
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),  // borda preta
                ),
                elevation: 0,                                                           // remove sombra
              ),
              child: const Text("Sair",),
            ),
            const SizedBox(height: 15),

            //botao excluir conta
            ElevatedButton(
              onPressed: () {
                _excluirConta();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaBloqueio()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, 
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),  
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)), 
                ),
                elevation: 0,
              ),
              child: const Text("Excluir conta",),
            ),
            const SizedBox(height: 15),

            // botao de salvar
            ElevatedButton(
              onPressed: () {
                _salvarUsuario();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaInicial()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(188, 192, 198, 1),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.black.withOpacity(0.1),
                elevation: 5,
              ),
              child: const Text("Salvar"),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}


class TelaWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseInicial(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ 
                Text(
                  "Wishlist",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          MostraProdutos(),
          //child: MostraProdutos(produtos: [],),]
        ]
      )
    );
  }
}


class TelaDegustados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseInicial(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ 
                Text(
                  "Degustados",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          MostraProdutos(),
          //child: MostraProdutos(produtos: [],),]
        ]
      )
    );
  }
}


