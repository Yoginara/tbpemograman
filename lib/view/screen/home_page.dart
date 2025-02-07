import 'package:dio_contact/services/auth_manager.dart';
import 'package:dio_contact/view/screen/login_page.dart';
import 'package:dio_contact/view/widget/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:dio_contact/model/fish_model.dart';
import 'package:dio_contact/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _jenisCtl = TextEditingController();
  final _hargaCtl = TextEditingController();
  final _jeniskelaminCtl = TextEditingController();
  String _result = '-';
  final ApiServices _dataService = ApiServices();
  List<FishModel> _fishMdl = [];
  FishResponse? ctRes;
  bool isEdit = false;
  String idFish = '';

  late SharedPreferences logindata;
  String username = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    inital();
  }

  void inital() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username').toString();
      token = logindata.getString('token').toString();
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _jenisCtl.dispose();
    _hargaCtl.dispose();
    _jeniskelaminCtl.dispose();
    super.dispose();
  }

  Future<void> refreshFishList() async {
    final users = await _dataService.getAllFish();
    setState(() {
      if (_fishMdl.isNotEmpty) {
        _fishMdl.clear();
      }
      if (users != null) {
        // Konversi Iterable ke List, kemudian gunakan reversed
        _fishMdl.addAll(users.toList().reversed);
      }
    });
  }

  Widget _buildListFish() {
    return ListView.separated(
        itemBuilder: (context, index) {
          final ctList = _fishMdl[index];
          return Card(
            child: ListTile(
              // leading: Text(user.id),
              title: Text(ctList.namaIkan),
              subtitle: Text(ctList.jenisIkan),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final Fishs = await _dataService.getSingleFish(ctList.id);
                      setState(() {
                        if (Fishs != null) {
                          _nameCtl.text = Fishs.namaIkan;
                          _jenisCtl.text = Fishs.jenisIkan;
                          _hargaCtl.text = Fishs.hargaIkan;
                          _jeniskelaminCtl.text = Fishs.jenisKelamin;
                          isEdit = true;
                          idFish = Fishs.id;
                        }
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(ctList.id, ctList.namaIkan);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10.0),
        itemCount: _fishMdl.length);
  }

  Widget hasilCard(BuildContext context) {
    return Column(children: [
      if (ctRes != null)
        FishCard(
          ctRes: ctRes!,
          onDismissed: () {
            setState(() {
              ctRes = null;
            });
          },
        )
      else
        const Text(''),
    ]);
  }

  String? _validateName(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
      return 'Nomor HP harus berisi angka';
    }
    return null;
  }

  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data $nama ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                FishResponse? res = await _dataService.deleteFish(id);
                setState(() {
                  ctRes = res;
                });
                Navigator.of(context).pop();
                await refreshFishList();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
                Navigator.pushAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  dialogContext,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fishs API'),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 2.0),
                color: Colors.tealAccent,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_circle_rounded),
                          const SizedBox(width: 8.0),
                          Text(
                            'Login sebagai : $username',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 8.0), // Menambahkan jarak antar baris
                      Row(
                        children: [
                          const Icon(Icons.key),
                          const SizedBox(width: 8.0),
                          Text(
                            'Token : $token',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _nameCtl,
                validator: _validateName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nama',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _jenisCtl,
                validator: _validateName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Jenis Ikan',
                  suffixIcon: IconButton(
                    onPressed: _jenisCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              TextFormField(
                controller: _hargaCtl,
                validator: _validateName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Jenis Ikan',
                  suffixIcon: IconButton(
                    onPressed: _hargaCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              TextFormField(
                controller: _jeniskelaminCtl,
                validator: _validateName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Jenis Ikan',
                  suffixIcon: IconButton(
                    onPressed: _jeniskelaminCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final isValidForm = _formKey.currentState!.validate();
                          if (_nameCtl.text.isEmpty ||
                              _jenisCtl.text.isEmpty ||
                              _hargaCtl.text.isEmpty ||
                              _jeniskelaminCtl.text.isEmpty) {
                            displaySnackbar('Semua field harus diisi');
                            return;
                          } else if (!isValidForm) {
                            displaySnackbar('Isi Form dengan Benar');
                            return;
                          }
                          final postModel = FishInput(
                            namaIkan: _nameCtl.text,
                            jenisIkan: _jeniskelaminCtl.text,
                            hargaIkan: _hargaCtl.text,
                            jenisKelamin: _jeniskelaminCtl.text,
                          );
                          FishResponse? res;
                          if (isEdit) {
                            res = await _dataService.putFish(idFish, postModel);
                          } else {
                            res = await _dataService.postFish(postModel);
                          }
                          setState(() {
                            ctRes = res;
                            isEdit = false;
                          });
                          _nameCtl.clear();
                          _jeniskelaminCtl.clear();
                          await refreshFishList();
                        },
                        child: Text(isEdit ? 'UPDATE' : 'POST'),
                      ),
                      if (isEdit)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _nameCtl.clear();
                            _jeniskelaminCtl.clear();
                            setState(() {
                              isEdit = false;
                            });
                          },
                          child: const Text('Cancel Update'),
                        ),
                    ],
                  )
                ],
              ),
              hasilCard(context),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await refreshFishList();
                        setState(() {});
                      },
                      child: const Text('Refresh Data'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _fishMdl.clear();
                        ctRes = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'List Fish',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _fishMdl.isEmpty ? Text(_result) : _buildListFish(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
