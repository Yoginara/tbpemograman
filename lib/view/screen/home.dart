import 'package:flutter/material.dart';
import 'login_page.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
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
            onPressed: _logout,
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
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/logo.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'Tim Kami',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
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
              children: [
                _buildTeamMemberTile(
                  name: 'Yoginara Pratama Sitorus',
                  role: 'Front-end Developer',
                  email: 'yoginara2004@gmail.com',
                  phone: '+62 813 6064 0668',
                  imagePath: 'assets/profile1.jpg',
                ),
                const SizedBox(height: 20),
                _buildTeamMemberTile(
                  name: 'Agung Deriko Nainggolan',
                  role: 'Back-end Developer',
                  email: 'agung12@gmail.com',
                  phone: '+62 823-6071-1385',
                  imagePath: 'assets/profile2.jpg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberTile({
    required String name,
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
      shadowColor: Colors.black.withOpacity(0.2),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role: $role',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Email: $email',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Phone: $phone',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
