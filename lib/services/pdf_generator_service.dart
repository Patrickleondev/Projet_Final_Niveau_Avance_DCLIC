import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PDFGeneratorService {
  static Future<String?> generateMedicalRecordPDF({
    required String patientName,
    required String patientEmail,
    required List<Map<String, String>> treatments,
    required List<Map<String, String>> analyses,
    required List<Map<String, String>> consultations,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // En-tête
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'SanoC - Santé Communautaire',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.deepOrange,
                      ),
                    ),
                    pw.Text(
                      'Dossier Médical',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Informations patient
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Informations Patient',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.deepOrange,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Nom: $patientName'),
                    pw.Text('Email: $patientEmail'),
                    pw.Text('Date de génération: ${DateTime.now().toString().split(' ')[0]}'),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Traitements en cours
              if (treatments.isNotEmpty) ...[
                pw.Text(
                  'Traitements en cours',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepOrange,
                  ),
                ),
                pw.SizedBox(height: 10),
                ...treatments.map((treatment) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        treatment['title'] ?? 'Traitement',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      if (treatment['description'] != null)
                        pw.Text(treatment['description']!),
                      if (treatment['date'] != null)
                        pw.Text('Date: ${treatment['date']}'),
                    ],
                  ),
                )),
                pw.SizedBox(height: 20),
              ],
              
              // Résultats d'analyses
              if (analyses.isNotEmpty) ...[
                pw.Text(
                  'Résultats d\'analyses',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepOrange,
                  ),
                ),
                pw.SizedBox(height: 10),
                ...analyses.map((analysis) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        analysis['title'] ?? 'Analyse',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      if (analysis['date'] != null)
                        pw.Text('Date: ${analysis['date']}'),
                    ],
                  ),
                )),
                pw.SizedBox(height: 20),
              ],
              
              // Consultations passées
              if (consultations.isNotEmpty) ...[
                pw.Text(
                  'Consultations passées',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepOrange,
                  ),
                ),
                pw.SizedBox(height: 10),
                ...consultations.map((consultation) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        consultation['title'] ?? 'Consultation',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      if (consultation['date'] != null)
                        pw.Text('Date: ${consultation['date']}'),
                    ],
                  ),
                )),
              ],
            ];
          },
        ),
      );

      // Sauvegarder le PDF
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'dossier_medical_${patientName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsBytes(await pdf.save());
      
      return file.path;
    } catch (e) {
      print('Erreur lors de la génération du PDF: $e');
      return null;
    }
  }

  static Future<bool> openPDF(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      return result.type == ResultType.done;
    } catch (e) {
      print('Erreur lors de l\'ouverture du PDF: $e');
      return false;
    }
  }
}
