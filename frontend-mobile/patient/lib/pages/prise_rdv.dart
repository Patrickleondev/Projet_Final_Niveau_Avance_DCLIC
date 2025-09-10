import 'package:flutter/material.dart';

class AppointmentBookingPage extends StatefulWidget {
  final Function(Map<String, String>) onAppointmentConfirmed;

  const AppointmentBookingPage({
    super.key,
    required this.onAppointmentConfirmed,
  });

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  int _currentStep = 0;
  String? _selectedSpecialty = "Cardiologie";
  String? _selectedDoctor;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _specialties = ["Cardiologie", "Neurologie"];
  final List<Map<String, dynamic>> _doctors = [
    {
      "name": "Dr. Folly James",
      "specialty": "Cardiologie",
      "languages": "Français, Anglais",
    },
    {
      "name": "Dr. Keli Maxime",
      "specialty": "Cardiologie",
      "languages": "Français",
    },
    {
      "name": "Dr. Nanga Fulbert",
      "specialty": "Cardiologie",
      "languages": "Français, Anglais, Espagnol",
    },
  ];

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
    }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _confirmAppointment() {
    if (_selectedSpecialty != null &&
        _selectedDoctor != null &&
        _selectedDate != null &&
        _selectedTime != null) {
      final appointment = {
        "specialty": _selectedSpecialty!,
        "doctor": _selectedDoctor!,
        "date": "${_selectedDate!.toLocal()}".split(' ')[0],
        "time": _selectedTime!.format(context),
      };

      widget.onAppointmentConfirmed(appointment);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez compléter toutes les étapes.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prendre un rendez-vous",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Barre de progression
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                _buildProgressStep(1, _currentStep >= 0),
                _buildProgressDivider(),
                _buildProgressStep(2, _currentStep >= 1),
                _buildProgressDivider(),
                _buildProgressStep(3, _currentStep >= 2),
                _buildProgressDivider(),
                _buildProgressStep(4, _currentStep >= 3),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Contenu des étapes
          Expanded(child: _buildStepContent()),
          // Boutons Suivant/Précédent
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Précédent"),
                  ),
                ElevatedButton(
                  onPressed:
                      _currentStep == 3 ? _confirmAppointment : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_currentStep == 3 ? "Confirmer" : "Suivant"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, bool isActive) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isActive ? Colors.deepOrange : Colors.grey[300],
      child: Text(
        "$step",
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressDivider() {
    return Expanded(child: Container(height: 2, color: Colors.grey[300]));
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildSpecialtySelection();
      case 1:
        return _buildDoctorSelection();
      case 2:
        return _buildDateSelection();
      case 3:
        return _buildTimeSelection();
      default:
        return Container();
    }
  }

  Widget _buildSpecialtySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Choisir une spécialité",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              _specialties.map((specialty) {
                final isSelected = _selectedSpecialty == specialty;
                return ChoiceChip(
                  label: Text(specialty),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedSpecialty = specialty;
                    });
                  },
                  selectedColor: Colors.deepOrange,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildDoctorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Choisir un médecin",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _doctors.length,
            itemBuilder: (context, index) {
              final doctor = _doctors[index];
              final isSelected = _selectedDoctor == doctor["name"];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/homme-serieux.jpg",
                    ),
                  ),
                  title: Text(doctor["name"]!),
                  subtitle: Text(
                    "${doctor["specialty"]} • ${doctor["languages"]}",
                  ),
                  trailing:
                      isSelected
                          ? const Icon(
                            Icons.check_circle,
                            color: Colors.deepOrange,
                          )
                          : null,
                  onTap: () {
                    setState(() {
                      _selectedDoctor = doctor["name"];
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Choisir une date",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: _pickDate,
            child: Text(
              _selectedDate == null
                  ? "Sélectionner une date"
                  : "${_selectedDate!.toLocal()}".split(' ')[0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Choisir une heure",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: _pickTime,
            child: Text(
              _selectedTime == null
                  ? "Sélectionner une heure"
                  : _selectedTime!.format(context),
            ),
          ),
        ),
      ],
    );
  }
}
