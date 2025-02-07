import 'package:dio_contact/model/fish_model.dart';
import 'package:flutter/material.dart';

class FishCard extends StatelessWidget {
  final FishResponse ctRes;
  final Function() onDismissed;

  const FishCard(
      {super.key, required this.ctRes, required this.onDismissed});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(ctRes.message),
      onDismissed: (direction) {
        onDismissed();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.lightBlue[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ctRes.insertedId !=null) _buildDataRow('ID', ctRes.insertedId),
            _buildDataRow('Message', ctRes.message),
            _buildDataRow('Status', ctRes.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10), // Jarak antara label dan titik dua
        Expanded(
          child: Text(
            ': $value',
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
