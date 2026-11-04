import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: StudentPage()),
  );
}

// FIRST SCREEN
class StudentPage extends StatelessWidget {
  const StudentPage({super.key});
  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    final regno = TextEditingController();
    final m1 = TextEditingController();
    final m2 = TextEditingController();
    final m3 = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Input Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: name,

              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: regno,
              decoration: const InputDecoration(labelText: 'Register Number'),
            ),
            TextField(
              controller: m1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mark 1'),
            ),
            TextField(
              controller: m2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mark 2'),
            ),
            TextField(
              controller: m3,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mark 3'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit'),

              onPressed: () {
                final a = double.tryParse(m1.text.trim());
                final b = double.tryParse(m2.text.trim());
                final c = double.tryParse(m3.text.trim());

                if (name.text.trim().isEmpty ||
                    regno.text.trim().isEmpty ||
                    a == null ||
                    b == null ||
                    c == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a name, register number, and valid marks.',
                      ),
                    ),
                  );
                  return;
                }

                // NAVIGATION
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      name: name.text,
                      regno: regno.text,
                      total: a + b + c,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// SECOND SCREEN
class ResultPage extends StatelessWidget {
  final String name;
  final String regno;
  final double total;
  const ResultPage({
    super.key,
    required this.name,
    required this.regno,

    required this.total,
  });
  @override
  Widget build(BuildContext context) {
    double average = total / 3;
    double percentage = (total / 300) * 100;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Result Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Name: $name'),
            Text('Register No: $regno'),
            const SizedBox(height: 20),
            Text('Total Marks: $total'),
            Text('Average: ${average.toStringAsFixed(2)}'),
            Text('Percentage: ${percentage.toStringAsFixed(2)}%'),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
