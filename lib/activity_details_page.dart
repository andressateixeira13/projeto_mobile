import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'activity.dart';
import 'update_activity_page.dart';
import 'ambiente.dart';
import 'user_session.dart';

class ActivityDetailsPage extends StatefulWidget {
  final Activity activity;

  ActivityDetailsPage({required this.activity});

  @override
  _ActivityDetailsPageState createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  late String token;
  Ambiente? ambiente;
  LatLng? coordenadas;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    UserSession.getToken().then((value) {
      token = value ?? '';
      _loadAmbiente();
    });
  }

  Future<void> _loadAmbiente() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/ambiente/${widget.activity.ambiente}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Ambiente amb = Ambiente.fromJson(data);

        List<geocoding.Location> locs = [];

        try {
          locs = await geocoding.locationFromAddress(amb.complemento)
              .timeout(Duration(seconds: 15));
        } catch (_) {
          try {
            locs = await geocoding.locationFromAddress(amb.cep)
                .timeout(Duration(seconds: 15));
          } catch (e) {
            debugPrint('Erro ao buscar coordenadas: $e');
          }
        }

        setState(() {
          ambiente = amb;
          coordenadas = locs.isNotEmpty
              ? LatLng(locs.first.latitude, locs.first.longitude)
              : null;
          isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar ambiente');
      }
    } catch (e) {
      debugPrint('Erro ao carregar ambiente ou coordenadas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Uint8List?> _carregarImagem() async {
    try {
      final url = widget.activity.foto!.replaceFirst('localhost', '10.0.2.2');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint('Erro HTTP imagem: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao carregar imagem: $e');
    }
    return null;
  }

  Widget _buildInfoText(String label, String? value) {
    if (value == null || value.trim().isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text('$label: $value', style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRetorno = widget.activity.situacao != null ||
        widget.activity.descricaoSituacao != null ||
        widget.activity.foto != null;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.activity.nomeAtiv),
        backgroundColor: Colors.blueGrey,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ambiente == null
          ? Center(child: Text("Erro ao carregar ambiente"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((widget.activity.feedback ?? '').isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Text(
                  'Feedback: ${widget.activity.feedback}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoText('Descrição', widget.activity.descricao),
                  _buildInfoText(
                    'Endereço',
                    '${ambiente!.rua}, ${ambiente!.numero}, Sala ${ambiente!.sala}, '
                        '${ambiente!.bairro}, ${ambiente!.setor}, Prédio ${ambiente!.predio}, CEP ${ambiente!.cep}',
                  ),
                  _buildInfoText('Data', widget.activity.data),
                  SizedBox(height: 16),
                  if (coordenadas != null)
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: coordenadas!,
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('ambiente'),
                              position: coordenadas!,
                              infoWindow:
                              InfoWindow(title: widget.activity.nomeAtiv),
                            ),
                          },
                        ),
                      ),
                    )
                  else
                    Text('Não foi possível exibir o mapa.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (hasRetorno)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueGrey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.activity.situacao != null)
                      _buildInfoText('Situação', widget.activity.situacao),
                    if (widget.activity.descricaoSituacao != null)
                      _buildInfoText('Descrição da Situação',
                          widget.activity.descricaoSituacao),
                    if (widget.activity.foto != null && widget.activity.foto!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: FutureBuilder<Uint8List?>(
                          future: _carregarImagem(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError || snapshot.data == null) {
                              return Text('Erro ao carregar imagem.');
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  // Abre imagem em tela cheia
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      backgroundColor: Colors.black,
                                      insetPadding: EdgeInsets.zero,
                                      child: Stack(
                                        children: [
                                          InteractiveViewer(
                                            child: Center(
                                              child: Image.memory(
                                                snapshot.data!,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 20,
                                            right: 20,
                                            child: IconButton(
                                              icon: Icon(Icons.close, color: Colors.white, size: 30),
                                              onPressed: () => Navigator.of(context).pop(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    snapshot.data!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateActivityPage(
                activityName: widget.activity.nomeAtiv,
                activity: widget.activity,
              ),
            ),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
