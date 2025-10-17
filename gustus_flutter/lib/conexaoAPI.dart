import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pacote para abrir links
import 'package:http/http.dart' as http; // Pacote para conexão com api
import 'dart:convert';

import 'usuario.dart';
import 'prato.dart';
import 'wishlist.dart';
import 'degustado.dart';
import 'favorito.dart';


class ConexaoAPI<T> {
  // Use um tipo genérico <T> para o dado
  final String? token;

  static bool _atualizou = false;

  // Variável estática para armazenar o token JWT globalmente
  static String? _globalToken;

  // Método público para definir o token (chamado após o login)
  static void setToken(String? token) {
    _globalToken = token;
  }

  static bool getAtualizou() {
    return _atualizou;
  }

  // Método para obter o token (chamado em qualquer requisição autenticada)
  static String? getToken() {
    print('Token sendo usado: $_globalToken');
    return _globalToken;
  }

  final List<T>? data; // lista de objetos (T)

  // Construtor
  ConexaoAPI({this.token, this.data});

  // Factory para decodificar apenas o token (usado no login)
  factory ConexaoAPI.fromJson(Map<String, dynamic> json) {
    return ConexaoAPI(
      token: json['token'],
      data: null, // Não há lista de dados nesta resposta
    );
  }

  ////////////////////////Métodos da API///////////////

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

  /////////////////////////////////////////////////////

  // entrar -> rafaelly
  static Future<ConexaoAPI<dynamic>> postLogin(
    String email,
    String senha,
  ) async {
    // O retorno usa <dynamic> porque esta resposta só contém o token

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
  static Future<void> postCadastro(
    String user,
    String email,
    String senha,
  ) async {
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
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ?? 'Erro desconhecido.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao tentar realizar o cadastro: $erro");
    }
  }

  /////////////////////////////////////////////////////

  // pegar todos os produtos -> mariana
  static Future<ConexaoAPI<Prato>> getProdutos() async {
    // O retorno agora especifica que o "data" será uma lista de "Prato"

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

  /////////////////////////////////////////////////////

  // pegar favoritos de um certo usuário -> rafaelly
  static Future<ConexaoAPI<Prato>> getFavoritos() async {
    final token = getToken(); // Pega o token estático

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.');
    }

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

        List<int> pratoIds = responseData
            .map((e) => e['idprato'] as int)
            .toList();

        final List<Future<Prato>> pratosDetalhes = pratoIds.map((id) async {
          final responsePrato = await http.get(
            Uri.parse('https://gustus-ws.onrender.com/produto?prato=$id'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (responsePrato.statusCode == 200) {
            final dynamic decodedBody = json.decode(responsePrato.body);

            // *Correção para List/Map (Problema comum da API)*
            if (decodedBody is List && decodedBody.isNotEmpty) {
              final Map<String, dynamic> jsonPrato = decodedBody[0];
              return Prato.fromJson(jsonPrato);
            } else if (decodedBody is Map<String, dynamic>) {
              return Prato.fromJson(decodedBody);
            } else {
              throw Exception(
                'Resposta da API inesperada ou prato $id não encontrado.',
              );
            }
          } else {
            throw Exception(
              'Falha ao carregar o Prato $id. Status: ${responsePrato.statusCode}',
            );
          }
        }).toList();

        final List<Prato> produtos = await Future.wait(pratosDetalhes);

        return ConexaoAPI<Prato>(data: produtos, token: null);
      } else {
        // Trata os erros específicos que a API pode retornar
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao buscar favoritos.';

        // Lança uma exceção com a mensagem vinda da API
        throw Exception(mensagem);
      }
    } catch (erro) {
      // Captura erros de conexão ou exceções lançadas acima
      throw Exception("Erro ao buscar favoritos: $erro");
    }
  }

  // verificar favoritos -> rafaelly
  static Future<bool> isFavorito(String nomePrato, String token) async {
    try {
      // Constrói a URL com o parâmetro de query
      final uri = Uri.parse(
        'https://gustus-ws.onrender.com/favSN',
      ).replace(queryParameters: {'nomePrato': nomePrato});

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // Se a lista retornada não estiver vazia, significa que o item é um favorito.
        return responseData.isNotEmpty;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao verificar favorito.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao verificar favorito: $erro");
    }
  }

  // adicionar favoritos -> rafaelly
  static Future<void> postFavorito(String nome, String token) async {
    try {
      final uri = Uri.parse(
        'https://gustus-ws.onrender.com/add-favoritos',
      ).replace(queryParameters: {'nomePrato': nome});

      final response = await http.post(
        uri, // Usa a URI com o parâmetro de consulta
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      // A API retorna 200 em caso de sucesso
      if (response.statusCode == 200) {
        print('Prato adicionado aos favoritos com sucesso!');
        return;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao adicionar favorito.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao adicionar favorito: $erro");
    }
  }

  // remover favoritos -> rafaelly
  static Future<void> deleteFavorito(String nome, String token) async {
    try {
      final uri = Uri.parse(
        'https://gustus-ws.onrender.com/delete-favoritos',
      ).replace(queryParameters: {'nomePrato': nome});

      final response = await http.delete(
        uri, // Usa a URI com o parâmetro de consulta
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Prato removido dos favoritos com sucesso!');
        return;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao remover favorito.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao remover favorito: $erro");
    }
  }

  /////////////////////////////////////////////////////

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

  // verificar wishlist -> mariana
  static Future<bool> isWishlist(String nomePrato, String token) async {
    try {
      // Constrói a URL com o parâmetro de query
      final uri = Uri.parse(
        'https://gustus-ws.onrender.com/wishSN',
      ).replace(queryParameters: {'nomePrato': nomePrato});

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // Se a lista retornada não estiver vazia, significa que o item é um favorito.
        return responseData.isNotEmpty;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao verificar wishlist.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao verificar wishlist: $erro");
    }
  }

  // adicionar wishlist -> mariana
  static Future<void> postWishlist(String nome, String token) async {
    try {
      final uri = Uri.parse(
        'https://gustus-ws.onrender.com/add-wishlist',
      ).replace(queryParameters: {'nomePrato': nome});

      final response = await http.post(
        uri, // Usa a URI com o parâmetro de consulta
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      // A API retorna 200 em caso de sucesso
      if (response.statusCode == 200) {
        print('Prato adicionado aos wishlist com sucesso!');
        return;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao adicionar wishlist.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao adicionar wishlist: $erro");
    }
  }

  // remover wishlist -> mariana
  static Future<void> deleteWishlist(String nome, String token) async {
    try {
      final uri = Uri.parse(
        'https://gustus-ws.onrender.com/delete-wishlist',
      ).replace(queryParameters: {'nomePrato': nome});

      final response = await http.delete(
        uri, // Usa a URI com o parâmetro de consulta
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Prato removido dos wishlist com sucesso!');
        return;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao remover wishlist.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao remover wishlist: $erro");
    }
  }

  /////////////////////////////////////////////////////

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

  // verificar degustados -> mariana
  static Future<bool> isDegustados(String nomePrato, String token) async {
    try {
      // Constrói a URL com o parâmetro de query
      final uri = Uri.parse(
        'https://gustus-ws.onrender.com/deguSN',
      ).replace(queryParameters: {'nomePrato': nomePrato});

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // Se a lista retornada não estiver vazia, significa que o item é um favorito.
        return responseData.isNotEmpty;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao verificar degustados.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao verificar degustados: $erro");
    }
  }

  // adicionar degustados/avaliar -> mariana
  static Future<void> postAvaliar(
    String nomePrato,
    int nota,
    String? descricao,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://gustus-ws.onrender.com/add-degustar?nomePrato=$nomePrato&nota=$nota&descricao=$descricao'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200|| response.statusCode == 201) {
        print('Avaliação registrada com sucesso!');
        return;
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao registrar avaliação.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao registrar avaliação: $erro");
    }
  }

  /////////////////////////////////////////////////////

  // pesquisar -> mariana
  static Future<ConexaoAPI<Prato>> getPesquisa(String pesquisa) async {
    final token = getToken();

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

  /////////////////////////////////////////////////////

  // alterar configurações -> rafaelly
  static Future<void> putConfiguracoes(
    String novoEmail,
    String novaSenha,
    String novoUsuario,
  ) async {
    final token = getToken();

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.');
    }

    try {
      final uri = Uri.parse('https://gustus-ws.onrender.com/atualizar-config')
          .replace(
            queryParameters: {
              'email': novoEmail,
              'senha': novaSenha,
              'usuario': novoUsuario,
            },
          );

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Autenticação
        },
      );

      if (response.statusCode == 200) {
        if (novoEmail != "") {
          setToken(""); //limpa o token e obriga o user a fazer um novo login
          print('E-mail atualizado com sucesso!');
        } else {
          print('Configurações do usuário atualizadas com sucesso!');
        }
        _atualizou = true;
        return;
      } else if (response.statusCode == 400) {
        _atualizou = false;
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem = responseData['mensagem'] ?? 'E-mail inválido.';
        throw Exception(mensagem);
      } else {
        _atualizou = false;
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao atualizar as configurações.';
        throw Exception(mensagem);
      }
    } catch (erro) {
      throw Exception("Erro ao atualizar configurações: $erro");
    }
  }

  // excluir conta -> rafaelly
  static Future<void> deleteConta() async {
    try {
      final token = getToken();
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
        final String mensagem =
            responseData['mensagem'] ??
            'Erro desconhecido ao tentar deletar a conta.';

        // Lança uma exceção com a mensagem vinda da API
        throw Exception(mensagem);
      }
    } catch (erro) {
      // Captura erros de conexão ou exceções lançadas acima
      throw Exception("Erro ao tentar deletar a conta: $erro");
    }
  }

  // sair conta -> rafaelly
  static Future<void> sairConta() async {
    setToken("");
  }

}
