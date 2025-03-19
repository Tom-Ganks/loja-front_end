import 'package:flutter/material.dart';
import 'package:projeto_flutter/presentation/pages/home_page.dart';
import 'package:projeto_flutter/services/api_services.dart';
import 'package:projeto_flutter/viewmodel/produto_viewmodel.dart';
import 'package:provider/provider.dart';
import 'data/repository/produto_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProdutoViewmodel(ProdutoRepository(ApiServices())),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja API',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        //  '/login': (context) => const LoginPage(),
        // '/carrinho': (context) => const CarrinhoPage(),
      },
    );
  }
}
