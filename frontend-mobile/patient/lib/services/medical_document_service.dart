import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class MedicalDocumentService {
  static const String _baseUrl = 'https://api.sanoc.com'; // URL de votre API
  
  // Générer un PDF de dossier médical
  static Future<String?> generateMedicalRecordPDF({
    required String userId,
    required Map<String, dynamic> medicalData,
  }) async {
    try {
      // Simuler la génération d'un PDF (remplacer par votre API)
      final response = await http.post(
        Uri.parse('$_baseUrl/medical-record/generate-pdf'),
        headers: {'Content-Type': 'application/json'},
        body: {
          'userId': userId,
          'medicalData': medicalData,
        },
      );

      if (response.statusCode == 200) {
        return response.body; // URL du PDF généré
      }
      return null;
    } catch (e) {
      debugPrint('Erreur génération PDF: $e');
      return null;
    }
  }

  // Télécharger un document médical
  static Future<bool> downloadDocument({
    required String documentUrl,
    required String fileName,
  }) async {
    try {
      // Demander la permission d'écriture
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }

      // Télécharger le fichier
      final response = await http.get(Uri.parse(documentUrl));
      if (response.statusCode == 200) {
        // Obtenir le répertoire de téléchargement
        final directory = await getExternalStorageDirectory();
        if (directory == null) return false;

        final downloadsDir = Directory('${directory.path}/Download');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        // Sauvegarder le fichier
        final file = File(path.join(downloadsDir.path, fileName));
        await file.writeAsBytes(response.bodyBytes);
        
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur téléchargement: $e');
      return false;
    }
  }

  // Ouvrir un PDF avec l'application système
  static Future<bool> openPDF(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      return result.type == ResultType.done;
    } catch (e) {
      debugPrint('Erreur ouverture PDF: $e');
      return false;
    }
  }

  // Créer un PDF de dossier médical local (simulation)
  static Future<String?> createLocalMedicalRecordPDF({
    required Map<String, dynamic> medicalData,
  }) async {
    try {
      // Obtenir le répertoire des documents
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'dossier_medical_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = path.join(directory.path, fileName);

      // Créer un PDF simple (simulation)
      // Dans un vrai projet, utilisez une bibliothèque comme pdf: ^3.10.7
      final pdfContent = _generatePDFContent(medicalData);
      
      final file = File(filePath);
      await file.writeAsString(pdfContent);
      
      return filePath;
    } catch (e) {
      debugPrint('Erreur création PDF local: $e');
      return null;
    }
  }

  // Générer le contenu PDF (simulation)
  static String _generatePDFContent(Map<String, dynamic> medicalData) {
    return '''
DOSSIER MÉDICAL - SANOC
========================

Informations personnelles:
- Nom: ${medicalData['name'] ?? 'N/A'}
- Âge: ${medicalData['age'] ?? 'N/A'}
- Groupe sanguin: ${medicalData['bloodType'] ?? 'N/A'}

Traitements en cours:
${medicalData['treatments']?.map((t) => '- $t').join('\n') ?? 'Aucun'}

Analyses récentes:
${medicalData['analyses']?.map((a) => '- $a').join('\n') ?? 'Aucune'}

Consultations:
${medicalData['consultations']?.map((c) => '- $c').join('\n') ?? 'Aucune'}

Généré le: ${DateTime.now().toString()}
''';
  }

  // Obtenir la liste des documents médicaux
  static Future<List<Map<String, dynamic>>> getMedicalDocuments(String userId) async {
    try {
      // Simuler l'appel API
      final response = await http.get(
        Uri.parse('$_baseUrl/medical-documents/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parser la réponse JSON
        final List<dynamic> documents = response.body as List<dynamic>;
        return documents.cast<Map<String, dynamic>>();
      }
      
      // Retourner des données de test
      return [
        {
          'id': '1',
          'title': 'Analyse sanguine',
          'date': '15 février 2025',
          'type': 'blood_analysis',
          'url': 'https://example.com/analysis1.pdf',
        },
        {
          'id': '2',
          'title': 'Radiographie thorax',
          'date': '3 janvier 2025',
          'type': 'xray',
          'url': 'https://example.com/xray1.pdf',
        },
      ];
    } catch (e) {
      debugPrint('Erreur récupération documents: $e');
      return [];
    }
  }
}
