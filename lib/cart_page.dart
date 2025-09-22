import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'order_provider.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      bottomNavigationBar: cart.items.isEmpty ? null : const CheckoutCard(),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( 
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 20),
                Text(
                  'Keranjangmu masih kosong, nih!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 120),
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items.values.toList()[i];
                final currencyFormatter = NumberFormat.currency(
                    locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Dismissible(
                    key: ValueKey(item.dessert.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                    onDismissed: (direction) {
                      Provider.of<CartProvider>(context, listen: false)
                          .removeItem(item.dessert.id);
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(item.dessert.imageUrl),
                      ),
                      title: Text(item.dessert.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Total: ${currencyFormatter.format(item.totalPrice)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 22),
                            onPressed: () {
                              cart.removeSingleItem(item.dessert.id);
                            },
                          ),
                          Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 22),
                            onPressed: () {
                              cart.addItem(item.dessert);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({super.key});

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.all(15),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total Harga:',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(cart.totalAmount),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: (cart.totalAmount <= 0 || _isProcessing)
                  ? null
                  : () async {
                      setState(() {
                        _isProcessing = true;
                      });

                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);

                      try {
                        await Provider.of<OrderProvider>(context, listen: false)
                            .addOrder(cart.items.values.toList(), cart.totalAmount);
                        cart.clear();

                        if (!mounted) return;
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Pesanan berhasil dibuat!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        navigator.pop();
                      } catch (e) {
                        if (!mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content:
                                Text('Gagal membuat pesanan: ${e.toString()}'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      } finally {
                        if (mounted) {
                           setState(() {
                            _isProcessing = false;
                          });
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              icon: _isProcessing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send), 
              label: Text(_isProcessing ? 'PROSES...' : 'CHECKOUT'),
            ),
          ],
        ),
      ),
    );
  }
}

