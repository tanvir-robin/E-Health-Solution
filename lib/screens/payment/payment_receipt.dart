import 'dart:io';
import 'dart:math';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class PaymentReceipt {
  // Method to generate PDF
  Future<File> generateReceiptPdf(Map<String, dynamic> paymentData) async {
    try {
      EasyLoading.show(status: 'Generating PDF...');

      // Create a PDF document
      final pdf = pw.Document();
      final currentTime = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

      // Generate a random invoice ID
      final String invoiceId = _generateInvoiceId();

      // Formatting
      String formattedDate = dateFormat.format(currentTime);
      String paymentDate = paymentData['tran_date'];
      String transactionId = paymentData['tran_id'];
      String amount = paymentData['amount'].toString();
      String cardType = paymentData['card_type'];
      String bankTranId = paymentData['bank_tran_id'];

      // Add watermark "PAID"
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                // Watermark
                pw.Positioned(
                  top: 100,
                  left: 100,
                  child: pw.Transform.rotate(
                    angle: pi / 4,
                    child: pw.Opacity(
                      opacity: 0.2,
                      child: pw.Text(
                        'PAID',
                        style: pw.TextStyle(
                          fontSize: 100,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                // Main content
                pw.Center(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SmileNest',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text('Dhaka, Bangladesh'),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'Payment Receipt',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text('Invoice ID: $invoiceId'),
                      pw.Text('Generated On: $formattedDate'),
                      pw.SizedBox(height: 20),
                      pw.Divider(),
                      pw.SizedBox(height: 10),
                      pw.Text('Transaction Date: $paymentDate'),
                      pw.Text('Transaction ID: $transactionId'),
                      pw.Text('Bank Transaction ID: $bankTranId'),
                      pw.Text('Card Type: $cardType'),
                      pw.SizedBox(height: 10),
                      pw.Text('Total Amount Paid: $amount BDT',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 20),
                      pw.Divider(),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'Thank you for your payment!',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Save PDF to device
      final outputDir = await getTemporaryDirectory();
      final outputFile =
          File('${outputDir.path}/payment_receipt_$invoiceId.pdf');
      await outputFile.writeAsBytes(await pdf.save());

      EasyLoading.dismiss(); // Dismiss loading after PDF generation
      return outputFile;
    } catch (e) {
      EasyLoading.showError('Error generating PDF');
      throw Exception('Failed to generate PDF');
    }
  }

  // Method to display the PDF
  Future<void> displayPdf(File pdfFile) async {
    await OpenFile.open(pdfFile.path);
  }

  // Helper method to generate random invoice ID
  String _generateInvoiceId() {
    final random = Random();
    return 'INV-${random.nextInt(900000) + 100000}';
  }
}
