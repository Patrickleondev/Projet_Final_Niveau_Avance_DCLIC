import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class MedicalRecordService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Database? _database;
  final bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Initialiser la base de données SQLite
  Future<void> initializeDatabase() async {
    if (_database != null) return;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'sanoc_medical.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table des dossiers médicaux
    await db.execute('''
      CREATE TABLE medical_records (
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        doctorName TEXT,
        hospitalName TEXT,
        recordType TEXT NOT NULL,
        isSynced INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Table des consultations
    await db.execute('''
      CREATE TABLE consultations (
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        doctorId TEXT NOT NULL,
        doctorName TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        isSynced INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Table des médicaments
    await db.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT,
        isActive INTEGER DEFAULT 1,
        isSynced INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Table des résultats d'analyses
    await db.execute('''
      CREATE TABLE lab_results (
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        testName TEXT NOT NULL,
        result TEXT,
        normalRange TEXT,
        date TEXT NOT NULL,
        laboratory TEXT,
        isSynced INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Gérer les mises à jour de base de données
  }

  // CRUD pour les dossiers médicaux
  Future<void> addMedicalRecord({
    required String patientId,
    required String title,
    required String description,
    required DateTime date,
    String? doctorName,
    String? hospitalName,
    required String recordType,
  }) async {
    await initializeDatabase();
    
    final record = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'patientId': patientId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'recordType': recordType,
      'isSynced': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    // Sauvegarder en local
    await _database!.insert('medical_records', record);

    // Tenter de synchroniser avec Firestore
    try {
      await _syncMedicalRecordToFirestore(record);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de synchronisation: $e');
      }
    }

    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getMedicalRecords(String patientId) async {
    await initializeDatabase();
    
    final records = await _database!.query(
      'medical_records',
      where: 'patientId = ?',
      whereArgs: [patientId],
      orderBy: 'date DESC',
    );

    return records;
  }

  Future<void> updateMedicalRecord(String recordId, Map<String, dynamic> updates) async {
    await initializeDatabase();
    
    updates['updatedAt'] = DateTime.now().toIso8601String();
    updates['isSynced'] = 0;

    await _database!.update(
      'medical_records',
      updates,
      where: 'id = ?',
      whereArgs: [recordId],
    );

    // Tenter de synchroniser
    try {
      final record = await _database!.query(
        'medical_records',
        where: 'id = ?',
        whereArgs: [recordId],
      );
      
      if (record.isNotEmpty) {
        await _syncMedicalRecordToFirestore(record.first);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de synchronisation: $e');
      }
    }

    notifyListeners();
  }

  Future<void> deleteMedicalRecord(String recordId) async {
    await initializeDatabase();
    
    await _database!.delete(
      'medical_records',
      where: 'id = ?',
      whereArgs: [recordId],
    );

    // Supprimer de Firestore
    try {
      await _firestore.collection('medical_records').doc(recordId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de suppression Firestore: $e');
      }
    }

    notifyListeners();
  }

  // Synchronisation avec Firestore
  Future<void> _syncMedicalRecordToFirestore(Map<String, dynamic> record) async {
    final firestoreRecord = Map<String, dynamic>.from(record);
    firestoreRecord.remove('isSynced'); // Ne pas synchroniser ce champ
    
    await _firestore
        .collection('medical_records')
        .doc(record['id'])
        .set(firestoreRecord, SetOptions(merge: true));

    // Marquer comme synchronisé
    await _database!.update(
      'medical_records',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [record['id']],
    );
  }

  // Synchronisation complète
  Future<void> syncAllRecords(String patientId) async {
    await initializeDatabase();
    
    // Récupérer tous les enregistrements non synchronisés
    final unsyncedRecords = await _database!.query(
      'medical_records',
      where: 'patientId = ? AND isSynced = 0',
      whereArgs: [patientId],
    );

    for (final record in unsyncedRecords) {
      try {
        await _syncMedicalRecordToFirestore(record);
      } catch (e) {
        if (kDebugMode) {
          print('Erreur de synchronisation pour ${record['id']}: $e');
        }
      }
    }

    // Récupérer les données de Firestore
    try {
      final snapshot = await _firestore
          .collection('medical_records')
          .where('patientId', isEqualTo: patientId)
          .get();

      for (final doc in snapshot.docs) {
        final firestoreData = doc.data();
        firestoreData['id'] = doc.id;
        firestoreData['isSynced'] = 1;

        // Vérifier si l'enregistrement existe en local
        final localRecord = await _database!.query(
          'medical_records',
          where: 'id = ?',
          whereArgs: [doc.id],
        );

        if (localRecord.isEmpty) {
          // Nouvel enregistrement de Firestore
          await _database!.insert('medical_records', firestoreData);
        } else {
          // Mettre à jour l'enregistrement local
          await _database!.update(
            'medical_records',
            firestoreData,
            where: 'id = ?',
            whereArgs: [doc.id],
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération Firestore: $e');
      }
    }

    notifyListeners();
  }

  // Méthodes pour les consultations
  Future<void> addConsultation({
    required String patientId,
    required String doctorId,
    required String doctorName,
    required DateTime date,
    required String time,
    String? notes,
  }) async {
    await initializeDatabase();
    
    final consultation = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'date': date.toIso8601String(),
      'time': time,
      'status': 'scheduled',
      'notes': notes,
      'isSynced': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await _database!.insert('consultations', consultation);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getConsultations(String patientId) async {
    await initializeDatabase();
    
    return await _database!.query(
      'consultations',
      where: 'patientId = ?',
      whereArgs: [patientId],
      orderBy: 'date DESC, time DESC',
    );
  }

  // Méthodes pour les médicaments
  Future<void> addMedication({
    required String patientId,
    required String name,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    await initializeDatabase();
    
    final medication = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'patientId': patientId,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': 1,
      'isSynced': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await _database!.insert('medications', medication);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getActiveMedications(String patientId) async {
    await initializeDatabase();
    
    return await _database!.query(
      'medications',
      where: 'patientId = ? AND isActive = 1',
      whereArgs: [patientId],
      orderBy: 'startDate DESC',
    );
  }

  // Fermer la base de données
  Future<void> closeDatabase() async {
    await _database?.close();
    _database = null;
  }

  @override
  void dispose() {
    closeDatabase();
    super.dispose();
  }
}
