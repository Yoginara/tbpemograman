import 'package:dio_contact/view/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dio_contact/services/auth_manager.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String _username = "Guest";
  List<Map<String, String>> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? username = await AuthManager.getUsername();
    setState(() {
      _username = username ?? "Guest";
      _teamMembers = [
        {
          "name": "Yoginara Pratama Sitorus",
          "npm": "714220043",
          "role": "Front-end Developer",
          "email": "yoginara2004@gmail.com",
          "phone": "+62 813 6064 0668",
          "imagePath": "assets/profile1.jpg"
        },
        {
          "name": "Agung Deriko Nainggolan",
          "npm": "714220039",
          "role": "Back-end Developer",
          "email": "agung12@gmail.com",
          "phone": "+62 823-6071-1385",
          "imagePath": "assets/profile2.jpg"
        }
      ];
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Anda yakin ingin logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _buildTeamMemberTile({
    required String name,
    required String npm,
    required String role,
    required String email,
    required String phone,
    required String imagePath,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Npm: $npm"),
            Text("Role: $role"),
            Text("Email: $email"),
            Text("Phone: $phone"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tim Kami',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/logo.jpg'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome, $_username",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bersama Mewujudkan Tujuan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: _teamMembers.map((member) {
                return _buildTeamMemberTile(
                  name: member["name"]!,
                  npm: member["npm"]!,
                  role: member["role"]!,
                  email: member["email"]!,
                  phone: member["phone"]!,
                  imagePath: member["imagePath"]!,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
