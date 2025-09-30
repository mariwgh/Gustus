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
        Uri.parse('https://gustus.onrender.com/usuarios'),
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
  static Future<ConexaoAPI<dynamic>> postLogin(String email, String senha,) async {
    try {
      final response = await http.post(
        Uri.parse('https://gustus.onrender.com/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'email': email, 
          'senha': senha
        }),
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

  // pegar todos os produtos -> mariana
  // O retorno agora especifica que o "data" será uma lista de "Prato"
  static Future<ConexaoAPI<Prato>> getProdutos() async {
    final token = getToken(); // Pega o token estático

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.'); 
    }

    try {
      final response = await http.get(
        Uri.parse('https://gustus.onrender.com/produtos'),
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
  // adicionar favoritos -> rafaelly
  // remover favoritos -> rafaelly

  // pegar wishlist de um certo usuário -> mariana
  static Future<ConexaoAPI<Prato>> getWishlist() async {
    final token = getToken(); // Pega o token estático

    if (token == null) {
      throw Exception('Token de autenticação não encontrado. Faça o login.'); 
    }

    try {
      final response = await http.get(
        Uri.parse('https://gustus.onrender.com/ver-wishlist'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Envia o token para autenticação
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<int> pratoIds = jsonData.map((e) => e['idprato'] as int).toList();
        
        // PEGAR OS DETALHES DOS PRATOS DE ACORDO COM (N Chamadas API)
        final List<Future<Prato>> pratosDetalhes = pratoIds.map((id) async {
          final responsePrato = await http.get(
            Uri.parse('https://gustus.onrender.com/produto?idprato=$id'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (responsePrato.statusCode == 200) {
              final Map<String, dynamic> jsonPrato = json.decode(responsePrato.body);
              return Prato.fromJson(jsonPrato); 
          } else {
              throw Exception('Falha ao carregar o Prato $id. Status: ${responsePrato.statusCode}');
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
        Uri.parse('https://gustus.onrender.com/ver-degustar'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Envia o token para autenticação
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<int> pratoIds = jsonData.map((e) => e['idprato'] as int).toList();
        
        // PEGAR OS DETALHES DOS PRATOS DE ACORDO COM (N Chamadas API)
        final List<Future<Prato>> pratosDetalhes = pratoIds.map((id) async {
          final responsePrato = await http.get(
            Uri.parse('https://gustus.onrender.com/produto?idprato=$id'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (responsePrato.statusCode == 200) {
              final Map<String, dynamic> jsonPrato = json.decode(responsePrato.body);
              return Prato.fromJson(jsonPrato); 
          } else {
              throw Exception('Falha ao carregar o Prato $id. Status: ${responsePrato.statusCode}');
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

  // avaliar -> rafaelly

  // alterar configurações -> rafaelly
  // excluir conta -> rafaelly
}
