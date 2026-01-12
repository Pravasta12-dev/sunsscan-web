import 'package:flutter/material.dart';

class GuestGreetingTable extends StatelessWidget {
  const GuestGreetingTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: DataTable(
          columns: ['Name', 'Type', 'Status', 'Actions'].map((e) {
            return DataColumn(label: Text(e));
          }).toList(),
          rows: [],
        ),
      ),
    );
  }
}
