import 'package:flutter/material.dart';
import 'package:dio_contact/services/api_services.dart';
import 'package:dio_contact/model/fish_model.dart';

class FishFormScreen extends StatefulWidget {
  const FishFormScreen({super.key});

  @override
  _FishFormScreenState createState() => _FishFormScreenState();
}

class _FishFormScreenState extends State<FishFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  String? _jenisIkan;
  String? _jenisKelamin;
  final ApiServices _apiService = ApiServices();

  final List<String> jenisIkanList = [
    'Plakat',
    'Halfmoon',
    'Crowntail',
    'Giant'
  ];
  final List<String> jenisKelaminList = ['Jantan', 'Betina'];

  void _resetForm() {
    _formKey.currentState?.reset(); // Reset validasi form
    _namaController.clear();
    _hargaController.clear();

    setState(() {
      _jenisIkan = null;
      _jenisKelamin = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Menutup keyboard

      FishInput fish = FishInput(
        namaIkan: _namaController.text,
        jenisIkan: _jenisIkan!,
        hargaIkan: _hargaController.text,
        jenisKelamin: _jenisKelamin!,
      );

      var response = await _apiService.postFish(fish);
      print(response);

      if (response != null && mounted) {
        // Tampilkan dialog sukses
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Berhasil"),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 50),
                  SizedBox(height: 10),
                  Text("Data ikan berhasil disimpan!"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        // Reset form setelah dialog ditutup
        _resetForm();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Ikan Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Ikan'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              DropdownButtonFormField<String>(
                value: _jenisIkan,
                decoration: const InputDecoration(labelText: 'Jenis Ikan'),
                items: jenisIkanList.map((String jenis) {
                  return DropdownMenuItem<String>(
                    value: jenis,
                    child: Text(jenis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisIkan = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih jenis ikan' : null,
              ),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga Ikan'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Harga harus diisi' : null,
              ),
              DropdownButtonFormField<String>(
                value: _jenisKelamin,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: jenisKelaminList.map((String jenis) {
                  return DropdownMenuItem<String>(
                    value: jenis,
                    child: Text(jenis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih jenis kelamin' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Simpan'),
                  ),
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
