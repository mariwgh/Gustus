import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pacote para abrir links
import 'package:http/http.dart' as http; // Pacote para conexão com api
import 'dart:convert';

import 'usuario.dart';
import 'prato.dart';
import 'wishlist.dart';
import 'degustado.dart';
import 'favorito.dart';


// api teste
class ConexaoAPI<T> {
  // Use um tipo genérico <T> para o dado
  final String? token;

  // Variável estática para armazenar o token JWT globalmente
  static String? _globalToken;

  // Método público para definir o token (chamado após o login)
  static void setToken(String? token) {
    _globalToken = token;
  }

  // Método para obter o token (chamado em qualquer requisição autenticada)
  static String? getToken() {
    return _globalToken;
  }

  final List<T>? data; // Novo campo para armazenar a lista de objetos (T)

  // Construtor atualizado para aceitar o token e a lista de dados
  ConexaoAPI({this.token, this.data});

  // Factory para decodificar apenas o token (usado no login)
  factory ConexaoAPI.fromJson(Map<String, dynamic> json) {
    return ConexaoAPI(
      token: json['token'],
      data: null, // Não há lista de dados nesta resposta
    );
  }

  // --- Métodos da API ---

  // get Usuarios de exemplo
  // O retorno agora especifica que o "data" será uma lista de "Usuario"
  /*
  static Future<ConexaoAPI<Usuario>> getUsuarios() async {
    try {
      final response = await http.get(
        Uri.parse('https://gustus-ws.onrender.com/usuarios'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // converte cada mapa em um objeto Usuario
        final List<Usuario> usuarios = jsonData
            .map((e) => Usuario.fromJson(e))
            .toList();

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          return ConexaoAPI<Usuario>(
            data: null, // Ou o usuário, se retornado
            token: token, // Retorna o token para a tela de login para feedback
          );
        }

        // Retorna o objeto com a lista de usuários no campo 'data'
        return ConexaoAPI<Usuario>(data: usuarios, token: null);
      } else {
        throw Exception(
          'Falha ao carregar os dados. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }
  */

  // entrar -> rafaelly
  // O retorno usa <dynamic> porque esta resposta só contém o token
  static Future<ConexaoAPI<dynamic>> postLogin(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('https://gustus-ws.onrender.com/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{'email': email, 'senha': senha}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? token = responseData['token'];
        setToken(token);
        // Usa o fromJson para extrair o token
        return ConexaoAPI<dynamic>.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao autenticar. Status: ${response.statusCode}');
      }
    } catch (erro) {
      throw Exception("Erro ao conectar ou ao carregar dados: $erro");
    }
  }

  // cadastrar -> rafaelly
 static Future<void> postCadastro(String user, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('https://gustus-ws.onrender.com/cadastrar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'user': user,
          'email': email,
          'senha': senha,
        }),
      );
      if (response.statusCode == 201) {
        print('Usuário cadastrado com sucesso!');
        return;
      } 
      else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'Erro desconhecido.';
        throw Exception(mensagem);
      }
    } catch (erro) {

      throw Exception("Erro ao tentar realizar o cadastro: $erro");
    }
  }
}

  // pegar todos os produtos -> mariana
  // O retorno agora especifica que o "data" será uma lista de "Prato"
  static Future<ConexaoAPI<Prato>> getProdutos() async {
    final token = getToken(); // Pega o token estático

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.');
    }

    try {
      final response = await http.get(
        Uri.parse('https://gustus-ws.onrender.com/produtos'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Envia o token para autenticação
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Prato> produtos = jsonData
            .map((e) => Prato.fromJson(e))
            .toList();

        return ConexaoAPI<Prato>(data: produtos, token: null);
      } else {
        throw Exception(
          'Falha ao carregar os dados. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }

  // pegar favoritos de um certo usuário -> rafaelly
    static Future<List<Favorito>> getFavoritos(String token) async {
    try {
      final response = await http.get(
        // URL do seu endpoint para ver os favoritos
        Uri.parse('https://gustus-ws.onrender.com/ver-favoritos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // O token é essencial para o middleware 'verificarToken'
          'Authorization': 'Bearer $token',
        },
      );

      // A API retorna 200 em caso de sucesso
      if (response.statusCode == 200) {
        // Decodifica a resposta JSON, que é uma lista de objetos
        final List<dynamic> responseData = json.decode(response.body);
        
        // Converte a lista de mapas JSON em uma lista de objetos Favorito
        return responseData.map((json) => Favorito.fromJson(json)).toList();
      } else {
        // Trata os erros específicos que a API pode retornar
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'Erro desconhecido ao buscar favoritos.';
        
        // Lança uma exceção com a mensagem vinda da API
        throw Exception(mensagem);
      }
    } catch (erro) {
      // Captura erros de conexão ou exceções lançadas acima
      throw Exception("Erro ao buscar favoritos: $erro");
    }
  }
  
  // adicionar favoritos -> rafaelly
  static Future<List<Favorito>> getFavoritos(String token) async {
    try {
      final response = await http.get(
        // URL do seu endpoint para ver os favoritos
        Uri.parse('https://gustus-ws.onrender.com/ver-favoritos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      // A API retorna 200 em caso de sucesso
      if (response.statusCode == 200) {
        // Decodifica a resposta JSON, que é uma lista de objetos
        final List<dynamic> responseData = json.decode(response.body);
        
        // Converte a lista de mapas JSON em uma lista de objetos Favorito
        return responseData.map((json) => Favorito.fromJson(json)).toList();
      } else {
        // Trata os erros específicos que a API pode retornar
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'Erro desconhecido ao buscar favoritos.';
        
        // Lança uma exceção com a mensagem vinda da API
        throw Exception(mensagem);
      }
    } catch (erro) {
      // Captura erros de conexão ou exceções lançadas acima
      throw Exception("Erro ao buscar favoritos: $erro");
    }
  }

  // adicionar favoritos -> rafaelly
  static Future<void> addFavorito(int idPrato, String token) async {
    try {
      final response = await http.post(
        // URL do seu endpoint para adicionar favoritos
        Uri.parse('https://gustus-ws.onrender.com/add-favoritos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // O token é essencial para o middleware 'verificarToken'
          'Authorization': 'Bearer $token',
        },
        // Envia o id do prato no corpo da requisição
        body: json.encode(<String, dynamic>{
          'idPrato': idPrato,
        }),
      );

      // A API retorna 200 em caso de sucesso
      if (response.statusCode == 200) {
        print('Prato adicionado aos favoritos com sucesso!');
        return;
      } else {
        // Trata os erros específicos que a API pode retornar
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'Erro desconhecido ao adicionar favorito.';
        
        // Lança uma exceção com a mensagem vinda da API
        throw Exception(mensagem);
      }
    } catch (erro) {
      // Captura erros de conexão ou exceções lançadas acima
      throw Exception("Erro ao adicionar favorito: $erro");
    }
  }
  // remover favoritos -> rafaelly
  static Future<void> removeFavorito(int idPrato, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('https://gustus-ws.onrender.com/delete-favoritos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(<String, dynamic>{
          'idPrato': idPrato,
        }),
      );

      if (response.statusCode == 200) {
        print('Prato removido dos favoritos com sucesso!');
        return;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'Erro desconhecido ao remover favorito.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao remover favorito: $erro");
    }
  }

  // pegar wishlist de um certo usuário -> mariana
  static Future<ConexaoAPI<Prato>> getWishlist() async {
    final token = getToken(); // Pega o token estático

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.');
    }

    try {
      final response = await http.get(
        Uri.parse('https://gustus-ws.onrender.com/ver-wishlist'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Envia o token para autenticação
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<int> pratoIds = jsonData
            .map((e) => e['idprato'] as int)
            .toList();

        // PEGAR OS DETALHES DOS PRATOS DE ACORDO COM (N Chamadas API)
        final List<Future<Prato>> pratosDetalhes = pratoIds.map((id) async {
          final responsePrato = await http.get(
            Uri.parse('https://gustus-ws.onrender.com/produto?prato=$id'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (responsePrato.statusCode == 200) {
            final List<dynamic> jsonList = json.decode(responsePrato.body);
            final Map<String, dynamic> jsonPrato = jsonList[0];
            return Prato.fromJson(jsonPrato);
          } else {
            throw Exception(
              'Falha ao carregar o Prato $id. Status: ${responsePrato.statusCode}',
            );
          }
        }).toList();

        // Aguarda todas as buscas de detalhes terminarem em paralelo
        final List<Prato> produtos = await Future.wait(pratosDetalhes);

        return await ConexaoAPI<Prato>(data: produtos, token: null);
      } else {
        throw Exception(
          'Falha ao carregar os dados. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }

  // adicionar wishlist -> mariana
  // remover wishlist -> mariana

  // pegar degustados de um certo usuário -> mariana
  static Future<ConexaoAPI<Prato>> getDegustados() async {
    final token = getToken(); // Pega o token estático

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.');
    }

    try {
      final response = await http.get(
        Uri.parse('https://gustus-ws.onrender.com/ver-degustar'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Envia o token para autenticação
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<int> pratoIds = jsonData
            .map((e) => e['idprato'] as int)
            .toList();

        // PEGAR OS DETALHES DOS PRATOS DE ACORDO COM (N Chamadas API)
        final List<Future<Prato>> pratosDetalhes = pratoIds.map((id) async {
          final responsePrato = await http.get(
            Uri.parse('https://gustus-ws.onrender.com/produto?prato=$id'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (responsePrato.statusCode == 200) {
            final List<dynamic> jsonList = json.decode(responsePrato.body);
            final Map<String, dynamic> jsonPrato = jsonList[0];
            return Prato.fromJson(jsonPrato);
          } else {
            throw Exception(
              'Falha ao carregar o Prato $id. Status: ${responsePrato.statusCode}',
            );
          }
        }).toList();

        // Aguarda todas as buscas de detalhes terminarem em paralelo
        final List<Prato> produtos = await Future.wait(pratosDetalhes);

        return await ConexaoAPI<Prato>(data: produtos, token: null);
      } else {
        throw Exception(
          'Falha ao carregar os dados. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }

  // adicionar degustados -> mariana

  // pesquisar -> mariana
  static Future<ConexaoAPI<Prato>> getPesquisa(String pesquisa) async {
    final token = getToken(); // Pega o token estático

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.');
    }

    try {
      final response = await http.get(
        Uri.parse('https://gustus-ws.onrender.com/pesquisar?prato=$pesquisa'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Envia o token para autenticação
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Prato> produtos = jsonData
            .map((e) => Prato.fromJson(e))
            .toList();

        return ConexaoAPI<Prato>(data: produtos, token: null);
      } else {
        throw Exception(
          'Falha ao carregar os dados. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }

  // avaliar -> rafaelly
  static Future<void> avaliarPrato(int idPrato, int nota, String? descricao, String token) async {
    try {
      final response = await http.put(
        Uri.parse('https://gustus-ws.onrender.com/avaliar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(<String, dynamic>{
          'idPrato': idPrato,
          'nota': nota,
          'descricao': descricao,
        }),
      );

      if (response.statusCode == 200) {
        print('Avaliação registrada com sucesso!');
        return;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'Erro desconhecido ao registrar avaliação.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao registrar avaliação: $erro");
    }
  }
  // alterar configurações -> rafaelly
  // excluir conta -> rafaelly
 static Future<void> deleteAccount(String token) async {
    try {
      final response = await http.delete(
        // URL do seu endpoint para deletar a conta
        Uri.parse('https://gustus-ws.onrender.com/delete-conta'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // O token é essencial para o middleware 'verificarToken'
          'Authorization': 'Bearer $token',
        },
      );

      // A API retorna 200 em caso de sucesso na remoção
      if (response.statusCode == 200) {
        print('Conta deletada com sucesso!');
        // Ação bem-sucedida, não precisa retornar nada.
        return;
      } else {
        // Trata os erros específicos que a API pode retornar
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'Erro desconhecido ao tentar deletar a conta.';
        
        // Lança uma exceção com a mensagem vinda da API
        throw Exception(mensagem);
      }
    } catch (erro) {
      // Captura erros de conexão ou exceções lançadas acima
      throw Exception("Erro ao tentar deletar a conta: $erro");
    }
  }
