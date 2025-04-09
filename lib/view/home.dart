import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/logoucs.png'),
            width: 200,
            height: 200,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Livro de Receitas",
            ),
          ),
        ],
      ),
    );
  }
}
