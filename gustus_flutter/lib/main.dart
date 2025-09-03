import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Este é o primeiro método que o projeto executa.
void main() {
  // Inicia a aplicação com a classe MyApp.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp é o widget raiz que define o tema e a navegação.
    return MaterialApp(home: TelaBloqueio());
  }
}

// widgets reutilizável 
class BaseBloqueio extends StatelessWidget {
  final Widget child;

  const BaseBloqueio({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 43, 64, 1.0),

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

          // Centraliza o conteúdo (o Container) na tela.
          Center(
            child: Container(
              width: 300.0,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.4), // Fundo translúcido.
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: child, // O child agora fica dentro do Container
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
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaInicial()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/home.png", 
                      height: MediaQuery.of(context).size.height * 0.05,
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

          Positioned.fill(
            top: 80,
            child: child,
          ),
          
          //SizedBox(height: 50),

          //child

        ],
      ),
    );
  }
}

class MostraProdutos extends StatelessWidget {
  // Aqui você poderia receber uma lista de produtos futuramente
  final List<Map<String, String>> produtos; // parametr0

  const MostraProdutos({Key? key, this.produtos = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se não tiver produtos (API não pronta), usamos alguns de exemplo
    final listaProdutos = [
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
      shrinkWrap: true,                               // importante quando está dentro de outra coluna
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          // duas colunas
        mainAxisSpacing: 150,
        crossAxisSpacing: 150,
        childAspectRatio: 1,        // mantém quadrado
      ),
      itemCount: listaProdutos.length,
      itemBuilder: (context, index) {
        final produto = listaProdutos[index];

        return GestureDetector(
          onTap: () {
            // Navega para a TelaProduto passando os dados
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
              final largura = constraints.maxWidth;
              final altura = constraints.maxHeight;

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
                    Positioned(
                      top: -altura * 0.15,    // 15% saindo pra cima
                      right: -largura * 0.15, // 15% saindo pro lado
                      child: Image.network(
                        produto["imagem"]!,
                        width: largura * 0.4, // metade do container
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(largura * 0.05), // 5% de padding
                        child: Text(
                          produto["nome"]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: largura * 0.08, // fonte proporcional
                            fontWeight: FontWeight.bold,
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
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseBloqueio(
      // texto e botoes
      child: Column(
        mainAxisSize: MainAxisSize.min,             // ocupa o mínimo de espaço vertical.
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            "Gustus",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 25),

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


class TelaCadastro extends StatefulWidget {
  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
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

  // função que será chamada quando o botão "Cadastrar" for pressionado e definira as variaveis
  void _cadastrarUsuario() {
    final String usuario = _userController.text;
    final String email = _emailController.text;
    final String senha = _passwordController.text;
    //ai aqui ele chama outra funcao q manda as variaveis p banco de dado
  }

  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseBloqueio(
      // texto e botoes
      child: Column(
        mainAxisSize: MainAxisSize.min,             // ocupa o mínimo de espaço vertical.
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            "Cadastro",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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

          // botao de cadastrar
          ElevatedButton(
            onPressed: () {
              _cadastrarUsuario();
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


class TelaLogin extends StatefulWidget {
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  // declarando controladores para pegar o texto de cada campo.
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // limpa os controladores quando a tela é chamada
  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // função que será chamada quando o botão "Cadastrar" for pressionado e definira as variaveis
  void _verificarUsuario() {
    final String usuario = _userController.text;
    final String senha = _passwordController.text;
    //ai aqui ele chama outra funcao q manda as variaveis p banco de dado
  }

  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseBloqueio(
      // texto e botoes
      child: Column(
        mainAxisSize: MainAxisSize.min,             // ocupa o mínimo de espaço vertical.
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseInicial(
      child: MostraProdutos(),
      //child: MostraProdutos(produtos: [],),
    );
  }
}


class TelaProduto extends StatelessWidget{
  final String nome;
  final String imagem;
  final String descricao;
  final String linkReceita;

  const TelaProduto({Key? key, required this.nome, required this.imagem, required this.descricao, required this.linkReceita}) : super(key: key);

  void abrirPaginaWeb(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // abre no navegador
        );
      } else {
        throw 'Não foi possível abrir $url';
      }
    } catch (e) {
      print('Erro ao tentar abrir o URL: $e'); // Imprime o erro no console
    }
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // espaça os elementos
                    children: [
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 30,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border, // coração vazio
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
                  
                Align(
                  alignment: Alignment.centerRight, // joga para a direita
                  child: FractionalTranslation(
                    translation: const Offset(0.3, 0.3), // metade para fora
                    child: Container(
                      width: largura * 0.7,
                      height: largura * 0.7, // Altura da imagem para um bom aspecto
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imagem),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              height: MediaQuery.of(context).size.height * 0.5, // metade da tela
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column (
                children: [
                  Text(
                    descricao,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: () {
                      abrirPaginaWeb(linkReceita);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // fundo transparente
                      foregroundColor: Colors.black,       // cor do texto e ícone
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black), // borda preta
                      ),
                      elevation: 0, // remove sombra
                    ),
                    child: const Text("Receita",),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(child: ElevatedButton(
                        onPressed: () {
                          abrirPaginaWeb(linkReceita);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // fundo transparente
                          foregroundColor: Colors.black,       // cor do texto e ícone
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black), // borda preta
                          ),
                          elevation: 0, // remove sombra
                        ),
                        child: const Text("Wishlist/Remover",),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(child: ElevatedButton(
                        onPressed: () {
                          abrirPaginaWeb(linkReceita);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // fundo transparente
                          foregroundColor: Colors.black,       // cor do texto e ícone
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.black), // borda preta
                          ),
                          elevation: 0, // remove sombra
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
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseInicial(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _pesquisaController,
              decoration: InputDecoration(
                hintText: "Pesquisar",
                prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 0, 0, 1)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 1)),
            ),
          ),
          Expanded(
            child: MostraProdutos(), // faz o GridView ocupar o resto da tela
          ),
        ],
      ),
    );
  }
}


class TelaConta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseInicial(
      child: Column(

      ),
    );
  }
}


class TelaConfiguracoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseBloqueio(
      child: Column(

      ),
    );
  }
}


class TelaWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseInicial(
      child: Column(
        children: [
          Text(
            "Wishlist",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseInicial(
      child: Column(
        children: [
          Text(
            "Degustados",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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


//tela avaliar