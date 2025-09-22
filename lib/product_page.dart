import 'dart:async';
import 'package:final_project_flutter/cart_page.dart';
import 'package:final_project_flutter/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'dessert.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Dessert> _allDesserts = [];
  List<Dessert> _filteredDesserts = [];
  List<Dessert> _displayedDesserts = [];

  bool _isLoading = true;
  String? _errorMessage;

  final int _pageSize = 10; 
  int _currentPage = 0;
  bool _isLoadingMore = false; 
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchDesserts();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchDesserts() async {
    try {
      final desserts = await ApiService().fetchDesserts();
      setState(() {
        _allDesserts = desserts;
        _filteredDesserts = desserts;
        _isLoading = false;
        _loadMoreDesserts();  
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat menu, coba lagi nanti.';
        _isLoading = false;
      });
    }
  }

  void _loadMoreDesserts() {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final listToPaginate = _isSearching ? _filteredDesserts : _allDesserts;
      final int startIndex = _currentPage * _pageSize;
      int endIndex = startIndex + _pageSize;

      if (startIndex < listToPaginate.length) {
        if (endIndex > listToPaginate.length) {
          endIndex = listToPaginate.length;
        }
        setState(() {
          _displayedDesserts.addAll(listToPaginate.getRange(startIndex, endIndex));
          _currentPage++;
        });
      }
      setState(() {
        _isLoadingMore = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreDesserts();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredDesserts = _allDesserts.where((dessert) {
        return dessert.name.toLowerCase().contains(query);
      }).toList();
      
      _currentPage = 0;
      _displayedDesserts.clear();
      _loadMoreDesserts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Myop-Myup'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Badge(
              label: Text(cart.itemCount.toString()),
              isLabelVisible: cart.itemCount > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CartPage()));
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari dessert...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_displayedDesserts.isEmpty && !_isLoadingMore) {
      return Center(
        child: Text(
          _isSearching ? 'Dessert tidak ditemukan' : 'Menu Kosong',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    return AnimationLimiter(
      child: GridView.builder(
        controller: _scrollController, 
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _displayedDesserts.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _displayedDesserts.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final dessert = _displayedDesserts[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _buildDessertCard(dessert),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDessertCard(Dessert dessert) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Card(
      shadowColor: Colors.black.withAlpha((255 * 0.1).round()),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                dessert.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.no_photography, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dessert.name,
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Rp ${dessert.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        cart.addItem(dessert);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${dessert.name} ditambahkan ke keranjang!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

