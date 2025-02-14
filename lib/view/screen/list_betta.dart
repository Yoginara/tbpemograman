import 'package:flutter/material.dart';
import 'package:dio_contact/model/fish_model.dart';
import 'package:dio_contact/services/api_services.dart';

class FishListScreen extends StatefulWidget {
  const FishListScreen({super.key});

  @override
  _FishListScreenState createState() => _FishListScreenState();
}

class _FishListScreenState extends State<FishListScreen> {
  final ApiServices apiServices = ApiServices();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController jenisController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController kelaminController = TextEditingController();

  FishModel? selectedFish;
  late Future<Iterable<FishModel>?> fishListFuture;

  @override
  void initState() {
    super.initState();
    fishListFuture = apiServices.getAllFish();
  }

  void _refreshFishList() {
    setState(() {
      fishListFuture = apiServices.getAllFish();
      namaController.clear();
      jenisController.clear();
      hargaController.clear();
      kelaminController.clear();
      selectedFish = null;
    });
  }

  void _showSnackbar(String message, {bool success = true}) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FishInput newFish = FishInput(
        namaIkan: namaController.text,
        jenisIkan: jenisController.text,
        hargaIkan: hargaController.text,
        jenisKelamin: kelaminController.text,
      );

      bool success;
      try {
        if (selectedFish == null) {
          success = await apiServices.postFish(newFish);
          _showSnackbar(
              success ? "Data berhasil disimpan!" : "Gagal menyimpan data!",
              success: success);
        } else {
          success = await apiServices.putFish(selectedFish!.id, newFish);
          _showSnackbar(
              success ? "Data berhasil diperbarui!" : "Gagal memperbarui data!",
              success: success);
        }

        if (success) _refreshFishList();
      } catch (e) {
        _showSnackbar("Terjadi kesalahan!", success: false);
      }
    }
  }

  void _deleteFish(String id) async {
    try {
      bool success = await apiServices.deleteFish(id);
      _showSnackbar(
          success ? "Data berhasil dihapus!" : "Gagal menghapus data!",
          success: success);
      if (success) _refreshFishList();
    } catch (e) {
      _showSnackbar("Terjadi kesalahan!", success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Ikan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshFishList,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: "Nama Ikan"),
                    validator: (value) =>
                        value!.isEmpty ? "Masukkan nama ikan" : null,
                  ),
                  TextFormField(
                    controller: jenisController,
                    decoration: const InputDecoration(labelText: "Jenis Ikan"),
                    validator: (value) =>
                        value!.isEmpty ? "Masukkan jenis ikan" : null,
                  ),
                  TextFormField(
                    controller: hargaController,
                    decoration: const InputDecoration(
                      labelText: "Harga Ikan",
                      prefixText: "Rp ",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Masukkan harga ikan";
                      }
                      if (double.tryParse(value) == null) {
                        return "Harga harus berupa angka";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: kelaminController,
                    decoration:
                        const InputDecoration(labelText: "Jenis Kelamin"),
                    validator: (value) =>
                        value!.isEmpty ? "Masukkan jenis kelamin" : null,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(selectedFish == null
                        ? "Tambah Ikan"
                        : "Simpan Perubahan"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Iterable<FishModel>?>(
              future: fishListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada data ikan"));
                } else {
                  final fishList = snapshot.data!;
                  return ListView.builder(
                    itemCount: fishList.length,
                    itemBuilder: (context, index) {
                      final fish = fishList.elementAt(index);
                      return Card(
                        child: ListTile(
                          title: Text(fish.namaIkan),
                          subtitle: Text(
                              "Jenis: ${fish.jenisIkan} | Harga: ${fish.hargaIkan}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    selectedFish = fish;
                                    namaController.text = fish.namaIkan;
                                    jenisController.text = fish.jenisIkan;
                                    hargaController.text = fish.hargaIkan;
                                    kelaminController.text = fish.jenisKelamin;
                                  });
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteFish(fish.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
