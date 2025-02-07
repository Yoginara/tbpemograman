import 'package:flutter/material.dart';
import 'package:dio_contact/model/fish_model.dart';
import 'package:dio_contact/services/api_services.dart';

class FishListScreen extends StatefulWidget {
  @override
  _FishListScreenState createState() => _FishListScreenState();
}

class _FishListScreenState extends State<FishListScreen> {
  final ApiServices apiServices = ApiServices();

  FishModel? selectedFish;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kelaminController = TextEditingController();

  void _startEdit(FishModel fish) {
    setState(() {
      selectedFish = fish;
      _namaController.text = fish.namaIkan;
      _jenisController.text = fish.jenisIkan;
      _hargaController.text = fish.hargaIkan.toString();
      _kelaminController.text = fish.jenisKelamin;
    });
  }

  void _saveEdit() async {
    if (_formKey.currentState!.validate()) {
      final updatedFish = FishInput(
        namaIkan: _namaController.text,
        jenisIkan: _jenisController.text,
        hargaIkan: _hargaController.text,
        jenisKelamin: _kelaminController.text,
      );

      await apiServices.putFish(selectedFish!.id, updatedFish);
      _refreshData();
    }
  }

  void _deleteFish(String id) async {
    bool confirmDelete = await _showDeleteDialog();
    if (confirmDelete) {
      await apiServices.deleteFish(id);
      _refreshData();
    }
  }

  void _refreshData() {
    setState(() {
      selectedFish = null; // Menyembunyikan form edit saat refresh
    });
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hapus Ikan'),
            content: const Text('Apakah Anda yakin ingin menghapus ikan ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Ikan Betta'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Iterable<FishModel>?>(
              future: apiServices.getAllFish(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Terjadi kesalahan'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: const Text('Tidak ada data ikan'));
                }

                final fishList = snapshot.data!;

                return ListView.builder(
                  itemCount: fishList.length,
                  itemBuilder: (context, index) {
                    final fish = fishList.elementAt(index);
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const Icon(Icons.storage,
                            color: Colors.blueAccent, size: 40),
                        title: Text(fish.namaIkan,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Jenis: ${fish.jenisIkan}'),
                            Text('Harga: Rp${fish.hargaIkan}'),
                            Text('Kelamin: ${fish.jenisKelamin}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green), 
                              onPressed: () => _startEdit(fish),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteFish(fish.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (selectedFish != null) _buildEditForm(),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Edit Ikan",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama Ikan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _jenisController,
                  decoration: const InputDecoration(labelText: 'Jenis Ikan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Jenis tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _hargaController,
                  decoration: const InputDecoration(labelText: 'Harga Ikan'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Harga tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: _kelaminController,
                  decoration: const InputDecoration(labelText: 'Kelamin Ikan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Kelamin tidak boleh kosong' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFish = null;
                        });
                      },
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: _saveEdit,
                      child: const Text('Simpan'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
