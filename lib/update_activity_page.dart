import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'user_session.dart';
import 'activity.dart';

class UpdateActivityPage extends StatefulWidget {
  final String activityName;
  final Activity activity;

  UpdateActivityPage({required this.activityName, required this.activity});

  @override
  _UpdateActivityPageState createState() => _UpdateActivityPageState();
}

class _UpdateActivityPageState extends State<UpdateActivityPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descricaoSituacaoController = TextEditingController();
  String _situacaoSelecionada = 'REALIZADA';
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
    if (_descricaoSituacaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    try {
      final token = await UserSession.getToken();
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token de autenticação não encontrado.')),
        );
        return;
      }

      final uri = Uri.parse('http://10.0.2.2:8080/atividades/${widget.activity.id}/retornos');
      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['situacao'] = _situacaoSelecionada
        ..fields['descricaoSituacao'] = _descricaoSituacaoController.text;

      if (_images.isNotEmpty) {
        final imageFile = File(_images.first.path);
        request.files.add(await http.MultipartFile.fromPath('foto', imageFile.path));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Body: $responseBody');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Retorno atualizado com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar retorno. Verifique sua conexão ou tente novamente.')),
      );
    }
  }

  @override
  void dispose() {
    _descricaoSituacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.activityName),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Atualizar Atividade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _situacaoSelecionada,
              decoration: InputDecoration(
                labelText: 'Situação',
                border: OutlineInputBorder(),
              ),
              items: ['REALIZADA', 'NÃO REALIZADA']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _situacaoSelecionada = value);
                }
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descricaoSituacaoController,
              decoration: InputDecoration(
                labelText: 'Descrição da Situação',
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
