import 'package:flutter/material.dart';

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

// Widget reutilizável para o fundo e o container central.
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

          Positioned(
            top: 80, // distância do topo
            left: 0,
            right: 0,
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
  final List<Map<String, String>> produtos;

  const MostraProdutos({Key? key, this.produtos = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se não tiver produtos (API não pronta), usamos alguns de exemplo
    final listaProdutos = produtos.isNotEmpty ? produtos: [
      {
        "nome": "Risoto de camarão",
        "imagem":
            "https://raw.githubusercontent.com/mariwgh/Gustus/refs/heads/main/imagens/risoto-de-camarao.png",
      },
      {
        "nome": "Ratatouille",
        "imagem":
            "https://raw.githubusercontent.com/mariwgh/Gustus/refs/heads/main/imagens/ratatouille.png",
      },
      {
        "nome": "Sushi",
        "imagem":
            "https://raw.githubusercontent.com/mariwgh/Gustus/refs/heads/main/imagens/sushi.png",
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,              // importante quando está dentro de outra coluna
      physics: const NeverScrollableScrollPhysics(), // para não conflitar com scroll externo
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          // duas colunas
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,        // mantém quadrado
      ),
      itemCount: listaProdutos.length,
      itemBuilder: (context, index) {
        final produto = listaProdutos[index];

        return Container(
          padding: const EdgeInsets.all(20.0),
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
                top: -40,
                right: -40,
                child: Image.network(
                  produto["imagem"]!,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  produto["nome"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
    );
  }
}


class TelaPesquisar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TelaBloqueio retorna um Scaffold, que fornece a estrutura básica.
    return BaseInicial(
      child: Column(

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

//tela produto
//tela wishlist
//tela degustados
//tela avaliar