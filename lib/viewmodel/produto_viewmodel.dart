import 'package:flutter/material.dart';
import 'package:projeto_flutter/data/repository/produto_repository.dart';
import '../data/models/model.dart';

class ProdutoViewmodel with ChangeNotifier {
  final ProdutoRepository _produtoRepository;
  List<Produto> _produtos = [];
  List<Produto> _carrinho = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _token;
  String? _username;
  String? _errorMessage;
  int _paginaAtual = 1;
  bool _temMaisPaginas = true;
  int _totalPaginas = 1;

  ProdutoViewmodel(this._produtoRepository);

  List<Produto> get produtos => _produtos;
  List<Produto> get carrinho => _carrinho;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoggedIn => _token != null;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  bool get temMaisPaginas => _temMaisPaginas;
  int get paginaAtual => _paginaAtual;
  int get totalPaginas => _totalPaginas;

  // carrega produtos iniciais
  Future<void> carregarProdutos() async {
    _isLoading = true;
    _paginaAtual = 1;
    _temMaisPaginas = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var resposta = await _produtoRepository.fetchProdutos(page: _paginaAtual);
      _produtos = resposta['produtos'];

      // Verificase ha mais paginas
      _temMaisPaginas = resposta['nextPage'] != null;

      // Calcula o total de paginas (assumindo 10 produtos por pagina)
      int count = resposta['count'];
      int produtosPorPagina = 10;
      _totalPaginas = (count / produtosPorPagina).ceil();
    } catch (e) {
      print(e);
      _errorMessage = 'Erro ao carregar produtos: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Carrega mais produtos conforme a paginacao
  Future<void> carregarPagina(int pagina) async {
    _produtos = [];
    print('Carregando página: $pagina');
    if (pagina <= 0 || pagina > _totalPaginas || _isLoadingMore) return;

    _paginaAtual = pagina;
    _isLoadingMore = true;
    notifyListeners();

    try {
      var resposta = await _produtoRepository.fetchProdutos(page: _paginaAtual);
      print('Produtos carregados: ${resposta['produtos']}');
      if (pagina == 1) {
        _produtos = resposta['produtos'];
      } else {
        _produtos.addAll(resposta['produtos']);
      }
      _temMaisPaginas = resposta['nextPage'] != null;
      print('Tem mais paginas: $_temMaisPaginas');
    } catch (e) {
      _errorMessage = 'Erro ao carregar produtos: $e';
      print(_errorMessage);
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Adiciona um produto ao carrinho
  void adicionarAoCarrinho(Produto produto) {}
}
