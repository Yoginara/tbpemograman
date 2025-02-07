import 'package:flutter/material.dart';
import 'package:dio_contact/model/fish_model.dart';
import 'package:dio_contact/services/api_services.dart';

class EditFishScreen extends StatefulWidget {
  final FishModel fish;

  EditFishScreen({required this.fish});

  @override
  _EditFishScreenState createState() => _EditFishScreenState();
}

class _EditFishScreenState extends State<EditFishScreen> {
  final ApiServices apiServices = ApiServices();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _jenisController;
  late TextEditingController _hargaController;
  late TextEditingController _kelaminController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.fish.namaIkan);
    _jenisController = TextEditingController(text: widget.fish.jenisIkan);
    _hargaController =
        TextEditingController(text: widget.fish.hargaIkan.toString());
    _kelaminController = TextEditingController(text: widget.fish.jenisKelamin);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _hargaController.dispose();
    _kelaminController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      FishInput updatedFish = FishInput(
        namaIkan: _namaController.text,
        jenisIkan: _jenisController.text,
        hargaIkan: _hargaController.text,
        jenisKelamin: _kelaminController.text,
      );

      await apiServices.putFish(widget.fish.id, updatedFish);
      Navigator.pop(
          context, true); // Kembali ke layar sebelumnya dengan status sukses
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Ikan')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Ikan'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _jenisController,
                decoration: InputDecoration(labelText: 'Jenis Ikan'),
                validator: (value) =>
                    value!.isEmpty ? 'Jenis tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga Ikan'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _kelaminController,
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                validator: (value) =>
                    value!.isEmpty ? 'Kelamin tidak boleh kosong' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
