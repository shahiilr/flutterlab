import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? startupError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    startupError = error;
  }
  runApp(StudentApp(startupError: startupError));
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key, this.startupError});

  final Object? startupError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Firestore App',
      home: StudentPage(startupError: startupError),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key, this.startupError});

  final Object? startupError;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final nameController = TextEditingController();
  final regNoController = TextEditingController();
  final cgpaController = TextEditingController();

  CollectionReference<Map<String, dynamic>> get students =>
      FirebaseFirestore.instance.collection('students');

  @override
  void dispose() {
    nameController.dispose();
    regNoController.dispose();
    cgpaController.dispose();
    super.dispose();
  }

  Future<void> saveStudent() async {
    final name = nameController.text.trim();
    final regNo = regNoController.text.trim();
    final cgpa = double.tryParse(cgpaController.text.trim());

    if (name.isEmpty ||
        regNo.isEmpty ||
        cgpa == null ||
        cgpa < 0 ||
        cgpa > 10) {
      showMessage('Enter a name, register number, and CGPA from 0 to 10.');
      return;
    }

    await students.add({
      'name': name,
      'regNo': regNo,
      'cgpa': cgpa,
      'createdAt': FieldValue.serverTimestamp(),
    });
    nameController.clear();
    regNoController.clear();
    cgpaController.clear();
    showMessage('Student saved.');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isConfigured = widget.startupError == null;
    return Scaffold(
      appBar: AppBar(title: const Text('Student Firestore Database')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isConfigured)
              const Card(
                color: Colors.amber,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Firebase is not configured. Complete the Firebase setup, then restart the app.',
                  ),
                ),
              ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student name'),
            ),
            TextField(
              controller: regNoController,
              decoration: const InputDecoration(labelText: 'Register number'),
            ),
            TextField(
              controller: cgpaController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'CGPA'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isConfigured ? saveStudent : null,
              child: const Text('Save student'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isConfigured
                  ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: students
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Firestore error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final records = snapshot.data!.docs;
                        if (records.isEmpty) {
                          return const Center(
                            child: Text('No students saved.'),
                          );
                        }
                        return ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final data = records[index].data();
                            return ListTile(
                              title: Text(data['name'] as String? ?? ''),
                              subtitle: Text(
                                'Reg no: ${data['regNo'] ?? ''} | CGPA: ${data['cgpa'] ?? ''}',
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text('Configure Firebase to use Firestore.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
