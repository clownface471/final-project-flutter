import 'package:final_project_flutter/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptPage extends StatelessWidget {
  final OrderItem order;

  const ReceiptPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Struk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () => _printDoc(context),
            tooltip: 'Cetak Struk',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildReceiptContent(context),
      ),
    );
  }

  Widget _buildReceiptContent(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Myop-Myup Dessert',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Text('Jl. Kue Manis No. 123, Kota Bahagia'),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ID Transaksi:'),
                Text(order.id.substring(0, 8), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tanggal:'),
                Text(DateFormat('d MMM yyyy, HH:mm').format(order.dateTime)),
              ],
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            const Text('DAFTAR PRODUK:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order.products.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${item.quantity}x ${item.dessert.name}'),
                  ),
                  Text(currencyFormatter.format(item.totalPrice)),
                ],
              ),
            )),
            const SizedBox(height: 16),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(
                  currencyFormatter.format(order.totalAmount),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Terima Kasih!',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _printDoc(BuildContext context) async {
    final doc = pw.Document();
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final fontData = await rootBundle.load("assets/fonts/PatrickHand-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final textStyle = pw.TextStyle(font: ttf, fontSize: 12);
    final boldStyle = pw.TextStyle(font: ttf, fontSize: 14, fontWeight: pw.FontWeight.bold);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Myop-Myup Dessert',
                  style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text('Jl. Kue Manis No. 123, Kota Bahagia', style: textStyle),
              ),
              pw.SizedBox(height: 12),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('ID Transaksi:', style: textStyle),
                  pw.Text(order.id.substring(0, 8), style: textStyle),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tanggal:', style: textStyle),
                  pw.Text(DateFormat('d/M/y HH:mm').format(order.dateTime), style: textStyle),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text('DAFTAR PRODUK:', style: boldStyle),
              pw.SizedBox(height: 4),
              ...order.products.map((item) => pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text('${item.quantity}x ${item.dessert.name}', style: textStyle),
                  ),
                  pw.Text(currencyFormatter.format(item.totalPrice), style: textStyle),
                ],
              )),
              pw.SizedBox(height: 8),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL', style: boldStyle),
                  pw.Text(
                    currencyFormatter.format(order.totalAmount),
                    style: boldStyle,
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 16),
              pw.Center(
                child: pw.Text(
                  'Terima Kasih!',
                  style: pw.TextStyle(font: ttf, fontSize: 14, fontStyle: pw.FontStyle.italic),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }
}

