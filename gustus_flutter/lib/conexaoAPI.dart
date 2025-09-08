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
  final List<T> data;

  ConexaoAPI(this.data);

  //get Usuarios de exemplo
  static Future<ConexaoAPI> getUsuarios() async {
    try {
      final response = await http.get(Uri.parse('https://gustus.onrender.com/usuarios'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // converte cada mapa em um objeto Usuario
        final usuarios = jsonData.map((e) => Usuario.fromJson(e)).toList();

        return ConexaoAPI(usuarios);
      } else {
        throw Exception('Falha ao carregar os dados. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar ou carregar dados: $e');
    }
  }

  //post login

  //post cadastro

  //get ver favoritos

  //post add favoritos

  //delete favoritos

  //get ver wishlist

  //post add wishlist

  //delete wishlist

  //get ver degustar

  //post avaliar

  //get ver receita
}