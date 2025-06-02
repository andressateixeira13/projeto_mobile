import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:projeto_mobile/activity.dart';

class UpdateActivityPage extends StatefulWidget {
  final String activityName;
  final Activity activity;

  UpdateActivityPage({required this.activityName, required this.activity});

  @override
  _UpdateActivityPageState createState() => _UpdateActivityPageState();
}

class _UpdateActivityPageState extends State<UpdateActivityPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descricaoController = TextEditingController();
  String _situacao = 'Concluída';
  List<XFile> _images = [];

  Future<void> _pickImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images.addAll(pickedImages);
      });
    }
  }

  Future<void> _enviarRetorno() async {
    if (_images.isEmpty || _descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos e adicione uma foto.')),
      );
      return;
    }

    try {
      final uri = Uri.parse('http://10.0.2.2:8080/retornos');
      final request = http.MultipartRequest('POST', uri)
        ..fields['atividadeId'] = widget.activity.id.toString()
        ..fields['descricao'] = _descricaoController.text
        ..fields['situacao'] = _situacao;

      File imageFile = File(_images.first.path);
      request.files.add(await http.MultipartFile.fromPath('foto', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Retorno enviado com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar retorno: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.activityName),
        backgroundColor: Colors.blueGrey,
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
              controller: _descricaoController,
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
              onPressed: _enviarRetorno,
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
