import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateActivityPage extends StatefulWidget {
  final String activityName;

  UpdateActivityPage({required this.activityName});

  @override
  _UpdateActivityPageState createState() => _UpdateActivityPageState();
}

class _UpdateActivityPageState extends State<UpdateActivityPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  Future<void> _pickImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images.addAll(pickedImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.activityName),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Atualizar Atividade',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Adicionar Fotos'),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _images.map((image) {
                return Image.file(
                  File(image.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement update logic
              },
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
