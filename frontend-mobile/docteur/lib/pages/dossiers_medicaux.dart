import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/medical_record_service.dart';
import '../services/appointment_service.dart';

class DossierMedicalPage extends StatefulWidget {
  final Map<String, dynamic> patient;

  const DossierMedicalPage({super.key, required this.patient});

  @override
  State<DossierMedicalPage> createState() => _DossierMedicalPageState();
}

class _DossierMedicalPageState extends State<DossierMedicalPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  Stream<QuerySnapshot>? _medicalRecordsStream;
  Stream<QuerySnapshot>? _appointmentsStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPatientData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final medicalRecordService = context.read<MedicalRecordService>();
      final appointmentService = context.read<AppointmentService>();
      
      final records = medicalRecordService.getPatientMedicalRecords(widget.patient['patientId']);
      final appointments = appointmentService.getPatientAppointments(widget.patient['patientId']);
      
      setState(() {
        _medicalRecordsStream = records;
        _appointmentsStream = appointments;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;
    final name = patient['name'] ?? 'Patient inconnu';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Dossier de $name",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.red),
            onPressed: () => _showAddRecordDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(text: "Informations"),
            Tab(text: "Dossier médical"),
            Tab(text: "Rendez-vous"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPatientInfo(patient),
                _buildMedicalRecords(),
                _buildAppointments(),
              ],
            ),
    );
  }

  Widget _buildPatientInfo(Map<String, dynamic> patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations personnelles
          _buildInfoCard(
            title: "Informations Personnelles",
            children: [
              _buildInfoRow("Nom complet", patient['name'] ?? 'Non renseigné'),
              _buildInfoRow("Âge", "${patient['age'] ?? 0} ans"),
              _buildInfoRow("Groupe sanguin", patient['bloodGroup'] ?? 'Non renseigné'),
              _buildInfoRow("Téléphone", patient['phoneNumber'] ?? 'Non renseigné'),
              _buildInfoRow("Adresse", patient['address'] ?? 'Non renseignée'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Informations médicales
          _buildInfoCard(
            title: "Informations Médicales",
            children: [
              _buildInfoRow("Allergies", patient['allergies'] ?? 'Aucune connue'),
              _buildInfoRow("Médicaments actuels", patient['currentMedications'] ?? 'Aucun'),
              _buildInfoRow("Antécédents", patient['medicalHistory'] ?? 'Aucun'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Statistiques
          _buildStatsCard(),
        ],
      ),
    );
  }

  Widget _buildMedicalRecords() {
    if (_medicalRecords.isEmpty) {
      return _buildEmptyState(
        icon: Icons.folder_open,
        title: "Aucun dossier médical",
        subtitle: "Les dossiers médicaux apparaîtront ici",
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPatientData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _medicalRecords.length,
        itemBuilder: (context, index) {
          final record = _medicalRecords[index];
          return _buildMedicalRecordCard(record);
        },
      ),
    );
  }

  Widget _buildAppointments() {
    if (_appointments.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today,
        title: "Aucun rendez-vous",
        subtitle: "Les rendez-vous apparaîtront ici",
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPatientData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          final appointment = _appointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistiques",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  "Dossiers médicaux",
                  "${_medicalRecords.length}",
                  Icons.folder,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  "Rendez-vous",
                  "${_appointments.length}",
                  Icons.calendar_today,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordCard(Map<String, dynamic> record) {
    final date = (record['date'] as Timestamp).toDate();
    final dateStr = DateFormat('dd/MM/yyyy').format(date);
    final title = record['title'] ?? 'Dossier médical';
    final type = record['recordType'] ?? 'consultation';
    final diagnosis = record['diagnosis'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getRecordIcon(type),
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _getRecordTypeLabel(type),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (diagnosis.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                diagnosis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final date = (appointment['date'] as Timestamp).toDate();
    final dateStr = DateFormat('dd/MM/yyyy').format(date);
    final time = DateFormat('HH:mm').format(date);
    final type = appointment['type'] ?? 'Consultation';
    final status = appointment['status'] ?? 'pending';

    Color statusColor;
    String statusText;
    
    switch (status) {
      case 'confirmed':
        statusColor = Colors.green;
        statusText = 'Confirmé';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'En attente';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Annulé';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusText = 'Terminé';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Inconnu';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '$dateStr à $time',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRecordIcon(String type) {
    switch (type) {
      case 'consultation':
        return Icons.medical_services;
      case 'examen':
        return Icons.science;
      case 'prescription':
        return Icons.medication;
      case 'resultat':
        return Icons.assignment;
      default:
        return Icons.folder;
    }
  }

  String _getRecordTypeLabel(String type) {
    switch (type) {
      case 'consultation':
        return 'Consultation';
      case 'examen':
        return 'Examen médical';
      case 'prescription':
        return 'Prescription';
      case 'resultat':
        return 'Résultat d\'analyse';
      default:
        return 'Dossier médical';
    }
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un dossier médical'),
        content: const Text('Cette fonctionnalité sera disponible prochainement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}