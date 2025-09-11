import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileAttachmentService {
  static final ImagePicker _imagePicker = ImagePicker();

  // Sélectionner une image depuis la galerie ou l'appareil photo
  static Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Erreur sélection image: $e');
      return null;
    }
  }

  // Sélectionner un fichier PDF ou autre document
  static Future<File?> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          return File(file.path!);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Erreur sélection document: $e');
      return null;
    }
  }

  // Copier un fichier vers le répertoire de l'application
  static Future<File?> copyFileToAppDirectory(File sourceFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(sourceFile.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFileName = '${timestamp}_$fileName';
      final newPath = path.join(directory.path, 'attachments', newFileName);
      
      // Créer le dossier attachments s'il n'existe pas
      final attachmentsDir = Directory(path.dirname(newPath));
      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      return await sourceFile.copy(newPath);
    } catch (e) {
      debugPrint('Erreur copie fichier: $e');
      return null;
    }
  }

  // Obtenir l'icône d'un fichier selon son extension
  static IconData getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.txt':
        return Icons.text_snippet;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Icons.image;
      default:
        return Icons.attach_file;
    }
  }

  // Obtenir la couleur d'un fichier selon son extension
  static Color getFileColor(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    
    switch (extension) {
      case '.pdf':
        return Colors.red;
      case '.doc':
      case '.docx':
        return Colors.blue;
      case '.txt':
        return Colors.grey;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  // Formater la taille d'un fichier
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Supprimer un fichier
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur suppression fichier: $e');
      return false;
    }
  }
}
