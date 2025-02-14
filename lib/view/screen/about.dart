import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ABOUT US',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: 'logo',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/logo.jpg',
                      height: 130,
                      width: 130,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildCard(
                title: 'Selamat datang di "BETTA"!',
                content:
                    '"BETTA" merupakan aplikasi penjualan ikan cupang . Kami menyediakan ikan berkualitas tinggi dari peternak terpercaya dengan harga yang kompetitif.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Visi & Misi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              buildCard(
                title: 'Visi:',
                content:
                    'Menjadi solusi utama dalam penjualan ikan cupang berbasis digital, menghubungkan pelanggan dengan sumber ikan terbaik.',
              ),
              buildCard(
                title: 'Misi:',
                content:
                    '- Menyediakan ikan cupang berkualitas tinggi dengan proses distribusi yang efisien.\n- Memberikan pengalaman belanja yang praktis dan nyaman melalui teknologi.\n- Mendukung kesejahteraan nelayan dan peternak ikan lokal dengan membuka pasar yang lebih luas.',
              ),
              const SizedBox(height: 20),
              buildCard(
                title: 'Komitmen Kami',
                content:
                    'Kami berkomitmen untuk menghadirkan produk terbaik dengan pelayanan yang profesional dan transparan. Terima kasih telah mempercayakan kebutuhan ikan cupang Anda kepada kami!',
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.deepPurple,
                    elevation: 5,
                  ),
                  child: const Text(
                    'Hubungi Kami',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard({required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
