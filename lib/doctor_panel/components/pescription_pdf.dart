import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

Future<File> generatePrescriptionPDF(String patientName, String complaint,
    String doctorName, String prescriptionDetails) async {
  final pdf = pw.Document();

  // Define styles for the PDF
  final titleStyle = pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold);
  final subtitleStyle =
      pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold);
  final bodyStyle = const pw.TextStyle(fontSize: 14);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Stack(
        children: [
          // Watermark
          pw.Positioned.fill(
            child: pw.Opacity(
              opacity: 0.1, // Adjust opacity for the watermark
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'SmileNest',
                  style: pw.TextStyle(
                    fontSize: 60,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Main content
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text('SmileNest Prescription', style: titleStyle),
              pw.SizedBox(height: 20),
              pw.Text('Patient Name: $patientName', style: bodyStyle),
              pw.Text('Doctor: $doctorName', style: bodyStyle),
              pw.Text(
                'Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                style: bodyStyle,
              ),
              pw.SizedBox(height: 20),

              // Complaint
              pw.Text('Complaint:', style: subtitleStyle),
              pw.Text(complaint, style: bodyStyle),
              pw.SizedBox(height: 20),

              // Prescription Details
              pw.Text('Prescription:', style: subtitleStyle),
              pw.Text(prescriptionDetails, style: bodyStyle),

              // Closing
              pw.SizedBox(height: 30),
              pw.Text(
                'Please follow the prescription instructions and feel free to contact us for any queries.',
                style: bodyStyle,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  // Save the PDF file
  final directory = await getApplicationDocumentsDirectory();
  final filePath =
      '${directory.path}/prescription_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return file;
}
