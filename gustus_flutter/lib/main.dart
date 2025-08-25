import 'package:flutter/material.dart';

//é o 1o metodo que o projeto executa
void main() {
  //faz o launch da 1a classe
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  //construtor da classe
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Gustus"),
        ),
        body: Center(
          child: Container(
            width: 300.00,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(0, 77, 77, 170),
                  blurRadius: 100,
                  offset: Offset(0, 5),
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Camarão",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                  color: Colors.deepPurple
                )),

                Text("Macarrão"),
                Text("Salsicha")
              ],
            ),

          ),
        ),
      )
    );

  }

}
