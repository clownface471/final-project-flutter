import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_project_flutter/order_provider.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Terjadi kesalahan!'));
          } else {
            return Consumer<OrderProvider>(
              builder: (ctx, orderData, child) => orderData.orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long, 
                            size: 100,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Belum ada transaksi',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Yuk, mulai belanja dessert!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) {
                        final order = orderData.orders[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            title: Text(
                              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                                  .format(order.totalAmount), 
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            subtitle: Text(DateFormat('d MMMM yyyy, HH:mm').format(order.dateTime)),
                            children: order.products.map((prod) {
                              return ListTile(
                                dense: true,
                                title: Text(prod.dessert.name),
                                trailing: Text('${prod.quantity}x'),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
            );
          }
        },
      ),
    );
  }
}

