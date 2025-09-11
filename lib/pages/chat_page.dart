import 'package:flutter/material.dart';
import 'teleconsultation_page.dart';
import '../services/file_attachment_service.dart';
import 'dart:io';

class ChatPage extends StatefulWidget {
  final String doctorName;
  final String doctorAvatar;

  const ChatPage({
    super.key,
    required this.doctorName,
    required this.doctorAvatar,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Bonjour! Comment puis-je vous aider aujourd'hui?",
      "isDoctor": true,
      "time": "09:30",
    },
    {
      "text": "J'ai des questions concernant ma prescription.",
      "isDoctor": false,
      "time": "09:31",
    },
    {
      "text": "Bien sûr, je vous écoute. Quelle est votre question?",
      "isDoctor": true,
      "time": "09:32",
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "text": _messageController.text.trim(),
          "isDoctor": false,
          "time": TimeOfDay.now().format(context),
        });
        _messageController.clear();
      });
    }
  }

  Future<void> _attachImage() async {
    final file = await FileAttachmentService.pickImage();
    if (file != null) {
      final copiedFile = await FileAttachmentService.copyFileToAppDirectory(file);
      if (copiedFile != null) {
        setState(() {
          _messages.add({
            "text": "Image envoyée",
            "isDoctor": false,
            "time": TimeOfDay.now().format(context),
            "attachment": {
              "type": "image",
              "path": copiedFile.path,
              "fileName": copiedFile.path.split('/').last,
            },
          });
        });
      }
    }
  }

  Future<void> _attachDocument() async {
    final file = await FileAttachmentService.pickDocument();
    if (file != null) {
      final copiedFile = await FileAttachmentService.copyFileToAppDirectory(file);
      if (copiedFile != null) {
        setState(() {
          _messages.add({
            "text": "Document envoyé",
            "isDoctor": false,
            "time": TimeOfDay.now().format(context),
            "attachment": {
              "type": "document",
              "path": copiedFile.path,
              "fileName": copiedFile.path.split('/').last,
            },
          });
        });
      }
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                _attachImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(context);
                _attachImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file, color: Colors.orange),
              title: const Text('Joindre un document'),
              onTap: () {
                Navigator.pop(context);
                _attachDocument();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _attachImageFromCamera() async {
    final file = await FileAttachmentService.pickImage(fromCamera: true);
    if (file != null) {
      final copiedFile = await FileAttachmentService.copyFileToAppDirectory(file);
      if (copiedFile != null) {
        setState(() {
          _messages.add({
            "text": "Photo envoyée",
            "isDoctor": false,
            "time": TimeOfDay.now().format(context),
            "attachment": {
              "type": "image",
              "path": copiedFile.path,
              "fileName": copiedFile.path.split('/').last,
            },
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.doctorAvatar),
              radius: screenHeight * 0.02,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctorName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "En ligne",
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Liste des messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment:
                      message["isDoctor"]
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          message["isDoctor"]
                              ? Colors.grey[200]
                              : Colors.red[100],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft:
                            message["isDoctor"]
                                ? const Radius.circular(0)
                                : const Radius.circular(10),
                        bottomRight:
                            message["isDoctor"]
                                ? const Radius.circular(10)
                                : const Radius.circular(0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message["attachment"] != null) ...[
                          _buildAttachmentWidget(message["attachment"]),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          message["text"],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message["time"],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bouton pour démarrer la téléconsultation
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TeleconsultationPage(
                          doctorName: widget.doctorName,
                          doctorSpecialty:
                              "Cardiologue", // Exemple de spécialité
                          doctorAvatar: widget.doctorAvatar,
                          isVideoCall: false, nurseAvatar: 'assets/images/infirmiere.png', // Set to true or false as needed
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Démarrer la téléconsultation",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Champ d'envoi de message
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: _showAttachmentOptions,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Écrivez un message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.red),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentWidget(Map<String, dynamic> attachment) {
    final type = attachment['type'];
    final fileName = attachment['fileName'];
    final path = attachment['path'];

    if (type == 'image') {
      return Container(
        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.broken_image, size: 40),
              );
            },
          ),
        ),
      );
    } else {
      // Document
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FileAttachmentService.getFileIcon(fileName),
              color: FileAttachmentService.getFileColor(fileName),
              size: 24,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                fileName,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
  }
}
