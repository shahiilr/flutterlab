import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart';
import 'package:flutter_application_1/student.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: StudentPage()),
  );
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final name = TextEditingController();
  final regno = TextEditingController();
  final cgpa = TextEditingController();
  List<Student> students = [];

  Future<void> loadStudents() async {
    final loadedStudents = await DatabaseHelper.getStudents();
    if (!mounted) {
      return;
    }
    setState(() => students = loadedStudents);
  }

  Future<void> saveStudent() async {
    final parsedCgpa = double.tryParse(cgpa.text.trim());
    if (name.text.trim().isEmpty ||
        regno.text.trim().isEmpty ||
        parsedCgpa == null ||
        parsedCgpa < 0 ||
        parsedCgpa > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid details and a CGPA from 0 to 10.'),
        ),
      );
      return;
    }

    await DatabaseHelper.insertStudent(
      Student(name.text.trim(), regno.text.trim(), parsedCgpa),
    );
    name.clear();
    regno.clear();
    cgpa.clear();
    await loadStudents();
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  void dispose() {
    name.dispose();
    regno.dispose();
    cgpa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Info Mgmt'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Enter Student Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: regno,
              decoration: const InputDecoration(
                labelText: 'Enter Student Regno',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cgpa,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Enter Student CGPA',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: saveStudent,
              child: const Text('Save Details'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(student.name.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(student.name),
                    subtitle: Text(
                      'Regno: ${student.regno}, CGPA: ${student.cgpa}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
