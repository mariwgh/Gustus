import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  //pacote para abrir links
import 'package:http/http.dart' as http;          // pacote para conexão com api
import 'dart:convert';

import 'usuario.dart';
import 'prato.dart';
import 'wishlist.dart';
import 'degustado.dart';
import 'favorito.dart';


// api teste
class ConexaoAPI<T> {
  final List<T>? data;
  final String? token;

  ConexaoAPI(this.data, this.token);

  // Este factory construtor é para a resposta de login (só tem token)
  factory ConexaoAPI.fromJson(Map<String, dynamic> json) {
    return ConexaoAPI(null, json['token']);
  }

  //get Usuarios de exemplo
  static Future<ConexaoAPI> getUsuarios() async {
    try {
      final response = await http.get(Uri.parse('https://gustus.onrender.com/usuarios'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // converte cada mapa em um objeto Usuario
        final usuarios = jsonData.map((e) => Usuario.fromJson(e)).toList();

        return ConexaoAPI(usuarios, null);
      } else {
        throw Exception('Falha ao carregar os dados. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }

  // entrar -> rafaelly
  static Future<ConexaoAPI> postLogin(String email, String senha) async{
    try{
      final response = await http.post(
        Uri.parse('https://gustus.onrender.com/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'email': email,
          'senha': senha,
        }),
      );
      if (response.statusCode == 200){
        return ConexaoAPI.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao carregar os dados. Status: ${response.statusCode}');
      }
    }
    catch(erro){
      throw Exception("Erro ao conectar ou ao carregar dados: $erro");
    }
  }

  // cadastrar -> rafaelly

  // pegar todos os produtos -> mariana
  static Future<ConexaoAPI> getProdutos() async {
    try {
      final response = await http.get(Uri.parse('https://gustus.onrender.com/produtos'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // converte cada mapa em um objeto Usuario
        final produtos = jsonData.map((e) => Prato.fromJson(e)).toList();

        return ConexaoAPI(produtos, null);
      } else {
        throw Exception('Falha ao carregar os dados. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }

  // pegar somente 1 produto -> mariana

  // pegar favoritos de um certo usuário -> rafaelly
  // adicionar favoritos -> rafaelly
  // remover favoritos -> rafaelly

  // pegar wishlist de um certo usuário -> mariana
  // adicionar wishlist -> mariana
  // remover wishlist -> mariana

  // pegar degustados de um certo usuário -> mariana
  // adicionar degustados -> mariana

  // pesquisar -> mariana

  // avaliar -> rafaelly

  // ver receita -> rafaelly

  // alterar configurações -> rafaelly
  // excluir conta -> rafaelly

}