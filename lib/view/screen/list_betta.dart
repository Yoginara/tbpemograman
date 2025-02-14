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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
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
        } else {
          success = await apiServices.putFish(selectedFish!.id, newFish);
        }

        if (success) {
          Navigator.pop(context); // **Tutup modal bottom sheet**
          _refreshFishList();
          _showSnackbar("Data berhasil disimpan!", success: true);
        } else {
          _showSnackbar("Gagal menyimpan data!", success: false);
        }
      } catch (e) {
        _showSnackbar("Terjadi kesalahan!", success: false);
      }
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Anda yakin ingin menghapus?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFish(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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

  void _showFishForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Tambah / Edit Ikan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(namaController, "Nama Ikan"),
                  _buildTextField(jenisController, "Jenis Ikan"),
                  _buildTextField(
                    hargaController,
                    "Harga Ikan",
                    keyboardType: TextInputType.number,
                    isNumeric: true,
                  ),
                  _buildTextField(kelaminController, "Jenis Kelamin"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    child: Text(selectedFish == null
                        ? "Tambah Ikan"
                        : "Simpan Perubahan"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text,
      bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Masukkan $label";
          }
          if (isNumeric && !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return "Masukkan angka yang valid";
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Ikan"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshFishList,
          ),
        ],
      ),
      body: FutureBuilder<Iterable<FishModel>?>(
        future: fishListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data ikan"));
          } else {
            final fishList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: fishList.length,
              itemBuilder: (context, index) {
                final fish = fishList.elementAt(index);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: ListTile(
                    title: Text(fish.namaIkan,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "Jenis: ${fish.jenisIkan} | Harga: Rp${fish.hargaIkan}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(fish.id),
                    ),
                    onTap: () {
                      setState(() {
                        selectedFish = fish;
                        namaController.text = fish.namaIkan;
                        jenisController.text = fish.jenisIkan;
                        hargaController.text = fish.hargaIkan;
                        kelaminController.text = fish.jenisKelamin;
                      });
                      _showFishForm();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _showFishForm,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
