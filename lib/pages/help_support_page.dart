import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  
  List<FAQItem> _faqItems = [];
  List<FAQItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _initializeFAQ();
    _filteredItems = _faqItems;
  }

  void _initializeFAQ() {
    _faqItems = [
      FAQItem(
        question: 'Comment prendre un rendez-vous ?',
        answer: 'Pour prendre un rendez-vous, allez dans l\'onglet "Rendez-vous" et cliquez sur "Nouveau RDV". Sélectionnez votre médecin, la date et l\'heure souhaitées.',
        category: 'Rendez-vous',
      ),
      FAQItem(
        question: 'Comment consulter mon dossier médical ?',
        answer: 'Votre dossier médical est accessible dans l\'onglet "Dossier médical". Vous pouvez y voir vos analyses, traitements et consultations passées.',
        category: 'Dossier médical',
      ),
      FAQItem(
        question: 'Comment modifier mes informations personnelles ?',
        answer: 'Allez dans votre profil, puis cliquez sur l\'icône de modification à côté de chaque information que vous souhaitez changer.',
        category: 'Profil',
      ),
      FAQItem(
        question: 'Comment recevoir des rappels de médicaments ?',
        answer: 'Dans l\'onglet "Rappels", vous pouvez ajouter vos médicaments et programmer des rappels personnalisés.',
        category: 'Rappels',
      ),
      FAQItem(
        question: 'Comment participer aux dons de sang ?',
        answer: 'Consultez l\'onglet "Dons de sang" pour voir les campagnes disponibles et vous inscrire aux collectes.',
        category: 'Dons de sang',
      ),
      FAQItem(
        question: 'Comment contacter le support technique ?',
        answer: 'Vous pouvez nous contacter via cette page d\'aide, par email à support@sanoc.app ou par téléphone au +33 1 23 45 67 89.',
        category: 'Support',
      ),
      FAQItem(
        question: 'Mon application ne se connecte pas, que faire ?',
        answer: 'Vérifiez votre connexion internet, redémarrez l\'application, ou contactez le support si le problème persiste.',
        category: 'Problèmes techniques',
      ),
      FAQItem(
        question: 'Comment supprimer mon compte ?',
        answer: 'Allez dans les paramètres de votre profil, section "Sécurité", puis "Supprimer le compte". Cette action est irréversible.',
        category: 'Compte',
      ),
    ];
  }

  void _filterFAQ(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _faqItems;
      } else {
        _filteredItems = _faqItems.where((item) {
          return item.question.toLowerCase().contains(query.toLowerCase()) ||
                 item.answer.toLowerCase().contains(query.toLowerCase()) ||
                 item.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nous contacter'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Votre email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Sujet',
                  prefixIcon: Icon(Icons.subject),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Votre message',
                  prefixIcon: Icon(Icons.message),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendMessage();
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_emailController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Simuler l'envoi du message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message envoyé avec succès !'),
        backgroundColor: Colors.green,
      ),
    );

    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aide et support',
          style: TextStyle(
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
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFAQ,
              decoration: InputDecoration(
                hintText: 'Rechercher dans la FAQ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterFAQ('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Boutons d'action rapide
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showContactDialog,
                    icon: const Icon(Icons.email),
                    label: const Text('Contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'support@sanoc.app'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email copié dans le presse-papiers')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copier email'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Liste FAQ
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun résultat trouvé',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return _buildFAQItem(_filteredItems[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          item.category,
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              item.answer,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
