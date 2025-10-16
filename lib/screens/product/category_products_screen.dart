import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../constants/app_constants.dart';
import 'product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _sortBy = 'name';
  String _sortOrder = 'asc';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load products from API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      setState(() {
        _products = [
          // Sample data for demonstration
          ProductModel(
            id: '1',
            name: 'Qoramol yemi Premium',
            description: 'Yuqori sifatli qoramol yemi',
            price: 15000.0,
            categoryId: widget.category.id,
            categoryName: widget.category.name,
            images: [],
            unit: 'kg',
            weight: 1.0,
            stock: 50,
            rating: 4.5,
            reviewCount: 25,
            tags: ['premium', 'qoramol'],
            isAvailable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          ProductModel(
            id: '2',
            name: 'Qoramol yemi Standart',
            description: 'Standart qoramol yemi',
            price: 12000.0,
            categoryId: widget.category.id,
            categoryName: widget.category.name,
            images: [],
            unit: 'kg',
            weight: 1.0,
            stock: 30,
            rating: 4.2,
            reviewCount: 18,
            tags: ['standart', 'qoramol'],
            isAvailable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mahsulotlarni yuklashda xatolik: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<ProductModel> get _filteredProducts {
    List<ProductModel> filtered = _products;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }

    // Sort
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return _sortOrder == 'asc' 
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name);
        case 'price':
          return _sortOrder == 'asc'
              ? a.price.compareTo(b.price)
              : b.price.compareTo(a.price);
        case 'rating':
          return _sortOrder == 'asc'
              ? a.rating.compareTo(b.rating)
              : b.rating.compareTo(a.rating);
        default:
          return 0;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                if (value == 'name_asc') {
                  _sortBy = 'name';
                  _sortOrder = 'asc';
                } else if (value == 'name_desc') {
                  _sortBy = 'name';
                  _sortOrder = 'desc';
                } else if (value == 'price_asc') {
                  _sortBy = 'price';
                  _sortOrder = 'asc';
                } else if (value == 'price_desc') {
                  _sortBy = 'price';
                  _sortOrder = 'desc';
                } else if (value == 'rating_asc') {
                  _sortBy = 'rating';
                  _sortOrder = 'asc';
                } else if (value == 'rating_desc') {
                  _sortBy = 'rating';
                  _sortOrder = 'desc';
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'name_asc',
                child: Text('Nomi A-Z'),
              ),
              const PopupMenuItem(
                value: 'name_desc',
                child: Text('Nomi Z-A'),
              ),
              const PopupMenuItem(
                value: 'price_asc',
                child: Text('Narxi pastdan yuqoriga'),
              ),
              const PopupMenuItem(
                value: 'price_desc',
                child: Text('Narxi yuqoridan pastga'),
              ),
              const PopupMenuItem(
                value: 'rating_asc',
                child: Text('Reyting pastdan yuqoriga'),
              ),
              const PopupMenuItem(
                value: 'rating_desc',
                child: Text('Reyting yuqoridan pastga'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredProducts.isEmpty
              ? _buildEmptyState()
              : _buildProductsGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty ? 'Qidiruv natijasi topilmadi' : 'Mahsulotlar yo\'q',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Boshqa kalit so\'z bilan qidiring'
                : 'Bu kategoriyada hali mahsulotlar qo\'shilmagan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Text('Qidiruvni tozalash'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey.shade100,
                ),
                child: product.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          product.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.image, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} ${AppConstants.currencySymbol}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.unit,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mahsulotlarni qidirish'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Mahsulot nomini kiriting...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
              Navigator.pop(context);
            },
            child: const Text('Tozalash'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Yopish'),
          ),
        ],
      ),
    );
  }
}
