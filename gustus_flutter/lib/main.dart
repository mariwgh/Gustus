import 'package:flutter/material.dart';
import 'package:gustus_flutter/prato.dart';
import 'package:url_launcher/url_launcher.dart';  //pacote para abrir links
import 'package:http/http.dart' as http;          // pacote para conexão com api
import 'dart:convert';
import 'conexaoAPI.dart';

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
    return MaterialApp(home: TelaBloqueio(), debugShowCheckedModeBanner: false);
  }
}


/*
// api teste
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  ConexaoAPI? apiInstance;  // instância da api que vai carregar os dados
  bool loading = true;      // indica se os dados estão sendo carregados
  String? error;            // armazena a mensagem de erro, se houver

  // chamado automaticamente quando o widget é criado
  @override
  void initState() {
    super.initState();
    // inicializa a api e carrega os dados assim que o widget entra na tela
    _initApi();
  }

  // função assíncrona para inicializar a api e tratar erros
  Future<void> _initApi() async {
    // atualiza o estado para mostrar o loading
    setState(() => loading = true);

    try {
      // tenta criar a instância da api (busca os dados do backend)
      apiInstance = await ConexaoAPI.getUsuarios();

      // limpa qualquer erro anterior
      error = null;
    } catch (e) {
      // em caso de erro, imprime no console
      print('erro ao carregar api: $e');

      // armazena a mensagem de erro para exibir na tela
      error = e.toString();
    }

    // atualiza o estado para esconder o loading
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // enquanto os dados estão carregando,
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("usuários")),
        body: Center(child: CircularProgressIndicator()), // mostra um indicador de progresso
      );
    }

    // quando o carregamento termina, pega os dados da api
    final data = apiInstance!.data;

    return Scaffold(
      appBar: AppBar(title: Text("usuários")),
      body: Column(
        children: [
          // se houver erro, exibe na tela
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'erro: $error',
                style: TextStyle(color: Colors.red),
              ),
            ),

          // botão para recarregar os dados da api
          ElevatedButton(
            onPressed: _initApi,
            child: Text('fetch data'),
          ),

          SizedBox(height: 20),

          // lista de usuários ou mensagem caso esteja vazia
          Expanded(
            child: data.isEmpty
            ? Center(child: Text('nenhum dado encontrado'))
            : ListView.builder(
                itemCount: data.length,       //tamanho da lista
                itemBuilder: (context, index) {
                  final u = data[index];      // cada usuário da lista
                  return ListTile(
                    title: Text(u.usuario),  // nome do usuário
                    subtitle: Text(u.email), // e-mail do usuário
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
*/


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


class MostraProdutos extends StatefulWidget {
  const MostraProdutos({super.key, required this.produtos});

  final List<Prato> produtos;

  @override
  _MostraProdutosState createState() => _MostraProdutosState();
}

class _MostraProdutosState extends State<MostraProdutos> {
  //_MostraProdutosState(this.produtos); // lista de 'maps' como parametro, ou seja cada elemento da lista tem um nome de tabela (string) com um dado (string), como no exemplo

  // a lista sera dada como vazia se nada for passado
  //_MostraProdutosState({Key? key, this.produtos = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      padding: const EdgeInsets.all(50),
      shrinkWrap: true,                 // importante quando está dentro de outra coluna, pois dimensiona-se para o tamanho mínimo sem brigas com outros elementos
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,              // duas colunas
        mainAxisSpacing: 150,           //espaco
        crossAxisSpacing: 150,          //espaco
        childAspectRatio: 1,            // mantém quadrado
      ),
      itemCount: widget.produtos.length,  //quantos items terao na tabela
      itemBuilder: (context, index) {
        final produto = widget.produtos[index];   // percorre cada elemento da lista o transformando em produto

        //cada produto é clicável, e quando clica, vai para a tela de seu produto com mais informacoes
        return GestureDetector(
          onTap: () {
            // navega para a TelaProduto passando os dados (parametros) que serao mostrados
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaProduto(
                  nome: produto.prato,
                  imagem: produto.foto,
                  descricao: produto.descricao,
                  linkReceita: produto.linkReceita,
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
                        produto.foto,
                        width: largura * 0.4,   // 40% do container
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,            //alinha para baixo a esquerda
                      child: Padding(
                        padding: EdgeInsets.all(largura * 0.05),  // 5% de padding
                        child: Text(
                          produto.prato,
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
 void _cadastrarUsuario() async {
  final String usuario = _userController.text;
  final String email = _emailController.text;
  final String senha = _passwordController.text;

  print("entrou no método");
  // Validação para garantir que os campos não estão vazios
  if (usuario.isEmpty || email.isEmpty || senha.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, preencha todos os campos.')),
    );
    return; // Para a execução
  }

  try {
    print("entrou no try");
    await ConexaoAPI.postCadastro(usuario, email, senha);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cadastro realizado com sucesso! Faça o login.')),
    );
    print("na teoria cadastro feito com sucesso");
    //usar pushReplacement é uma boa prática aqui para que o usuário não consiga "voltar" para a tela de cadastro.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TelaLogin()),
    );

  } 
  catch (erro) {
    print("caiu no catch");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro: ${erro.toString().replaceAll("Exception: ", "")}'),
        backgroundColor: Colors.red,
      ),
    );
  }
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // limpa os controladores quando a tela é chamada
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // função que será chamada quando o botão "Entrar" for pressionado e definira as variaveis
  void _verificarUsuario() async {
    String email = _emailController.text;
    String senha = _passwordController.text;

    try {
      final conexao = await ConexaoAPI.postLogin(email, senha);

      if(conexao.token != null){
        print(conexao.token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TelaInicial()),
        );
      }

      else {
        // Se o token for nulo (login falhou), exibe uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("E-mail ou senha incorretos.")),
        );
      }
    } catch (e) {
      // Se houver qualquer erro na conexão, exibe uma mensagem
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao fazer login. Tente novamente.")),
      );
      print("Erro de login: $e");
    }
  }

  @override
  void initState() {
    super.initState();
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
            controller: _emailController,                        //define a variavel que sera usada para ir para o bd
            decoration: InputDecoration(                        //decoracao de lugar que digita
              labelText: "E-mail",                                //texto do campo para digitar
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
              _verificarUsuario();    
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


class TelaInicial extends StatefulWidget {
  @override
  State<TelaInicial> createState() => _TelaInicialState(); 
}

class _TelaInicialState extends State<TelaInicial> {
  List<Prato> _produtos = []; 
  
  // indicador de carregamento
  bool _isLoading = true; 
  String? _errorMessage; 

  @override
  void initState() {
    super.initState();
    // NÃO CHAME _fetchProdutos() DIRETAMENTE.
    // CHAME A FUNÇÃO QUE VERIFICA O TOKEN PRIMEIRO
    _checkTokenAndFetch(); 
  }

  // Novo método: Verifica o token antes de tentar buscar dados
  Future<void> _checkTokenAndFetch() async {
    // Tenta pegar o token global estático.
    try{
      final token = ConexaoAPI.getToken(); 
      if (token == null) {
        // Se a tela abriu sem token (sem ter feito login), exibe uma mensagem.
        if (mounted) {
            setState(() {
              _isLoading = false;
              //_errorMessage = "Por favor, faça o login para ver os produtos.";
            });
          }
      }
    }
    catch(e){
      _errorMessage = e.toString();
      print(_errorMessage);
    }
   
    // Se há token, procede com a busca de produtos
    await _fetchProdutos(); 
    return;
  }

  Future<void> _fetchProdutos() async {
    try {
      // O resultado é do tipo ConexaoAPI<Prato>
      final apiResponse = await ConexaoAPI.getProdutos(); 
      
      // Verifica se o widget ainda está montado antes de chamar setState
      if (mounted) {
        setState(() {
          // Acesse a lista de Prato corretamente no campo 'data'
          // Se o 'data' for nulo (ex: a API retornou lista vazia), use []
          _produtos = apiResponse.data ?? []; 
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      if (mounted) {
         setState(() {
            _isLoading = false;
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostra um indicador de carregamento enquanto espera
      return Center(child: CircularProgressIndicator());
    }
    
    // Se o carregamento terminou, exibe o conteúdo
    return BaseInicial(
      child: MostraProdutos(produtos: _produtos), 
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
  bool _isFavorito = false;
    void _adicionarOuRemoverFavoritos() async {
    final token = ConexaoAPI.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado para favoritar.')),
      );
      return;
    }

    try {
      // Se o item já é um favorito, chama a API para remover
      if (_isFavorito) {
        await ConexaoAPI.removeFavorito(widget.nome, token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removido dos favoritos!')),
        );
      }
      // Se não for, chama a API para adicionar
      else {
        await ConexaoAPI.addFavorito(widget.nome, token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicionado aos favoritos!')),
        );
      }

      // Atualiza o estado da variável e redesenha a tela com o novo ícone
      if (mounted) {
        setState(() {
          _isFavorito = !_isFavorito; // Inverte o valor (true vira false e vice-versa)
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  void _verificarStatusFavorito() async {

    String nomePrato = widget.nome;
    String? token = ConexaoAPI.getToken();

    if (token != null) {
      try {
        bool resultado = await ConexaoAPI.isFavorito(widget.nome, token);

        if (resultado == true) {
          print("Este prato JÁ É um favorito!");
          setState(() {
            _isFavorito = true;
          });
        } else {
          print("Este prato NÃO é um favorito.");
          setState(() {
            _isFavorito = false;
          });
        }
      } 
      catch (e) {
        print("Erro ao verificar favorito: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Assim que a tela carrega, verifica se o prato já é um favorito
    _verificarStatusFavorito();
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
                      // tem que arrumar uma outra imagem para quando for favorito o coração estar cheio
                      // faz com que o coracao seja clicavel
                      GestureDetector(            
                        onTap: () {
                          _adicionarOuRemoverFavoritos();
                        },
                        child: Positioned(
                          top: 20,
                          right: 30,
                          child: Icon(
                            _isFavorito ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorito ? Colors.red : Colors.white,
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
  List<Prato> _produtos = []; 
  final TextEditingController _pesquisaController = TextEditingController();
    
  // indicador de carregamento
  bool _isLoading = true; 
  String? _errorMessage; 

  @override
  void initState() {
    super.initState();
    // Chame a função que busca os produtos
    // e atualize o estado
    _checkTokenAndFetch();
  }

  // Novo método: Verifica o token antes de tentar buscar dados
  Future<void> _checkTokenAndFetch() async {
    // Tenta pegar o token global estático.
    try{
      final token = ConexaoAPI.getToken(); 

      if (token == null) {
        // Se a tela abriu sem token (sem ter feito login), exibe uma mensagem.
        if (mounted) {
          setState(() {
            _isLoading = false;
            //_errorMessage = "Por favor, faça o login para ver os produtos.";
          });
        }
      }
    }
    catch(e){
      _errorMessage = e.toString();
      print(_errorMessage);
    }
   
    // Se há token, procede com a busca de produtos
    await _fetchProdutos(); 
    return;
  }

  Future<void> _fetchProdutos() async {
    try {
      // O resultado é do tipo ConexaoAPI<Prato>
      final apiResponse = await ConexaoAPI.getPesquisa(_pesquisaController.text); 
      
      // Verifica se o widget ainda está montado antes de chamar setState
      if (mounted) {
        setState(() {
          // Acesse a lista de Prato corretamente no campo 'data'
          // Se o 'data' for nulo (ex: a API retornou lista vazia), use []
          _produtos = apiResponse.data ?? []; 
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      if (mounted) {
         setState(() {
            _isLoading = false;
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostra um indicador de carregamento enquanto espera
      return Center(child: CircularProgressIndicator());
    }

    return BaseInicial(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _pesquisaController,          // para passarmos como parametro da lista de produtos
              
              onChanged: (text) {
                _fetchProdutos(); 
              },
              // Opcional: Chama a busca ao pressionar 'Enter'
              onSubmitted: (_) => _fetchProdutos(), 

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
            child: MostraProdutos(produtos: _produtos), 
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaFavoritos())
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
                            "Favoritos",
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
                  MostraProdutos( produtos: [],),
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
                  MostraProdutos( produtos: [],),
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
                  MostraProdutos(produtos: [],),
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


class TelaFavoritos extends StatefulWidget {
  @override
  State<TelaFavoritos> createState() => _TelaFavoritosState(); 
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  List<Prato> _produtos = []; 
  
  // indicador de carregamento
  bool _isLoading = true; 
  String? _errorMessage; 

  @override
  void initState() {
    super.initState();
    // NÃO CHAME _fetchProdutos() DIRETAMENTE.
    // CHAME A FUNÇÃO QUE VERIFICA O TOKEN PRIMEIRO
    _checkTokenAndFetch(); 
  }

  // Novo método: Verifica o token antes de tentar buscar dados
  Future<void> _checkTokenAndFetch() async {
    // Tenta pegar o token global estático.
    try{
      final token = ConexaoAPI.getToken(); 

      if (token == null) {
        // Se a tela abriu sem token (sem ter feito login), exibe uma mensagem.
        if (mounted) {
          setState(() {
            _isLoading = false;
            //_errorMessage = "Por favor, faça o login para ver os produtos.";
          });
        }
      }
    }
    catch(e){
      _errorMessage = e.toString();
      print(_errorMessage);
    }
   
    // Se há token, procede com a busca de produtos
    await _fetchProdutos(); 
    return;
  }

  Future<void> _fetchProdutos() async {
    try {
      // O resultado é do tipo ConexaoAPI<Prato>
      final apiResponse = await ConexaoAPI.getFavoritos(); 
      
      // Verifica se o widget ainda está montado antes de chamar setState
      if (mounted) {
        setState(() {
          // Acesse a lista de Prato corretamente no campo 'data'
          // Se o 'data' for nulo (ex: a API retornou lista vazia), use []
          _produtos = apiResponse.data ?? []; 
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      if (mounted) {
         setState(() {
            _isLoading = false;
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostra um indicador de carregamento enquanto espera
      return Center(child: CircularProgressIndicator());
    }

    // Estado de Erro ou Lista Vazia
    if (_errorMessage != null || _produtos.isEmpty) {
      String message = _errorMessage ?? "A sua Wishlist está vazia.";
      
      // Verifica se a Wishlist está vazia (caso não tenha dado erro)
      if (_produtos.isEmpty && _errorMessage == null) {
          message = "Sua lista de favoritos está vazia.";
      }

      return BaseInicial(
          child: Center(
              child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
              ),
          ),
      );
    }

    return BaseInicial(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ 
                Text(
                  "Favoritos",
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

          MostraProdutos(produtos: _produtos,),
        ]
      )
    );
  }
}


class TelaWishlist extends StatefulWidget {
  @override
  State<TelaWishlist> createState() => _TelaWishlistState(); 
}

class _TelaWishlistState extends State<TelaWishlist> {
  List<Prato> _produtos = []; 
  
  // indicador de carregamento
  bool _isLoading = true; 
  String? _errorMessage; 

  @override
  void initState() {
    super.initState();
    // NÃO CHAME _fetchProdutos() DIRETAMENTE.
    // CHAME A FUNÇÃO QUE VERIFICA O TOKEN PRIMEIRO
    _checkTokenAndFetch(); 
  }

  // Novo método: Verifica o token antes de tentar buscar dados
  Future<void> _checkTokenAndFetch() async {
    // Tenta pegar o token global estático.
    try{
      final token = ConexaoAPI.getToken(); 

      if (token == null) {
        // Se a tela abriu sem token (sem ter feito login), exibe uma mensagem.
        if (mounted) {
          setState(() {
            _isLoading = false;
            //_errorMessage = "Por favor, faça o login para ver os produtos.";
          });
        }
      }
    }
    catch(e){
      _errorMessage = e.toString();
      print(_errorMessage);
    }
   
    // Se há token, procede com a busca de produtos
    await _fetchProdutos(); 
    return;
  }

  Future<void> _fetchProdutos() async {
    try {
      // O resultado é do tipo ConexaoAPI<Prato>
      final apiResponse = await ConexaoAPI.getWishlist(); 
      
      // Verifica se o widget ainda está montado antes de chamar setState
      if (mounted) {
        setState(() {
          // Acesse a lista de Prato corretamente no campo 'data'
          // Se o 'data' for nulo (ex: a API retornou lista vazia), use []
          _produtos = apiResponse.data ?? []; 
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      if (mounted) {
         setState(() {
            _isLoading = false;
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostra um indicador de carregamento enquanto espera
      return Center(child: CircularProgressIndicator());
    }

    // Estado de Erro ou Lista Vazia
    if (_errorMessage != null || _produtos.isEmpty) {
      String message = _errorMessage ?? "A sua Wishlist está vazia.";
      
      // Verifica se a Wishlist está vazia (caso não tenha dado erro)
      if (_produtos.isEmpty && _errorMessage == null) {
          message = "Sua Wishlist está vazia.";
      }

      return BaseInicial(
          child: Center(
              child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
              ),
          ),
      );
    }

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

          MostraProdutos(produtos: _produtos,),
        ]
      )
    );
  }
}


class TelaDegustados extends StatefulWidget {
  @override
  State<TelaDegustados> createState() => _TelaDegustadosState(); 
}

class _TelaDegustadosState extends State<TelaDegustados> {
  List<Prato> _produtos = []; 
  
  // indicador de carregamento
  bool _isLoading = true; 
  String? _errorMessage; 

  @override
  void initState() {
    super.initState();
    // NÃO CHAME _fetchProdutos() DIRETAMENTE.
    // CHAME A FUNÇÃO QUE VERIFICA O TOKEN PRIMEIRO
    _checkTokenAndFetch(); 
  }

  // Novo método: Verifica o token antes de tentar buscar dados
  Future<void> _checkTokenAndFetch() async {
    // Tenta pegar o token global estático.
    try{
      final token = ConexaoAPI.getToken(); 

      if (token == null) {
        // Se a tela abriu sem token (sem ter feito login), exibe uma mensagem.
        if (mounted) {
          setState(() {
            _isLoading = false;
            //_errorMessage = "Por favor, faça o login para ver os produtos.";
          });
        }
      }
    }
    catch(e){
      _errorMessage = e.toString();
      print(_errorMessage);
    }
   
    // Se há token, procede com a busca de produtos
    await _fetchProdutos(); 
    return;
  }

  Future<void> _fetchProdutos() async {
    try {
      // O resultado é do tipo ConexaoAPI<Prato>
      final apiResponse = await ConexaoAPI.getDegustados(); 
      
      // Verifica se o widget ainda está montado antes de chamar setState
      if (mounted) {
        setState(() {
          // Acesse a lista de Prato corretamente no campo 'data'
          // Se o 'data' for nulo (ex: a API retornou lista vazia), use []
          _produtos = apiResponse.data ?? []; 
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      if (mounted) {
         setState(() {
            _isLoading = false;
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostra um indicador de carregamento enquanto espera
      return Center(child: CircularProgressIndicator());
    }

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

          MostraProdutos(produtos: _produtos,),
        ]
      )
    );
  }
}


class TelaAvaliar extends StatefulWidget {
  @override
  State<TelaAvaliar> createState() => _TelaAvaliar();
}

class _TelaAvaliar extends State<TelaAvaliar> {
  // declarando controladores para pegar o texto de cada campo.
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  int estrelasSelecionadas = 0; // adicionar como variável da State

  // limpa os controladores quando a tela é chamada
  @override
  void dispose() {
    _userController.dispose();
    _notaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // função que será chamada quando o botão "Cadastrar" for pressionado e definira as variaveis
  void _salvarAvaliacao() {
    final String usuario = _userController.text;
    final String nota = _notaController.text;
    final String descricao = _descricaoController.text;
    //ai aqui ele chama outra funcao q manda as variaveis p banco de dado
  }

  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseInicial(
      child: BaseBloqueio(
        child: Column(
          mainAxisSize: MainAxisSize.min,             // ocupa o mínimo de espaço vertical.
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ 
                Text(
                  "Degustar",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ]
            ),
            const SizedBox(height: 20),

            //nota
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      estrelasSelecionadas = index + 1;  // define quantas estrelas estão selecionadas
                      _notaController.text = estrelasSelecionadas.toString(); // atualiza o TextField
                    });
                  },
                  icon: Icon(
                    index < estrelasSelecionadas ? Icons.star : Icons.star_border,
                    color: const Color.fromARGB(255, 255, 255, 255), // cor da estrela cheia
                    size: 36,
                  ),
                );
              }),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: "Descrição",
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

            // botao de salvar
            ElevatedButton(
              onPressed: () {
                _salvarAvaliacao();
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
              child: const Text("Degustado"),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
