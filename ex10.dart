import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? firebaseError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    firebaseError = error;
  }
  runApp(StudentRegistrationApp(firebaseError: firebaseError));
}

class StudentRegistrationApp extends StatelessWidget {
  const StudentRegistrationApp({super.key, this.firebaseError});

  final Object? firebaseError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: RegistrationPage(firebaseError: firebaseError),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, this.firebaseError});

  final Object? firebaseError;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final regNoController = TextEditingController();
  final cgpaController = TextEditingController();
  late final AnimationController animationController;
  bool isSaving = false;

  CollectionReference<Map<String, dynamic>> get students =>
      FirebaseFirestore.instance.collection('students');

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    nameController.dispose();
    regNoController.dispose();
    cgpaController.dispose();
    super.dispose();
  }

  Future<void> saveStudent() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => isSaving = true);
    try {
      await students.add({
        'name': nameController.text.trim(),
        'regNo': regNoController.text.trim(),
        'cgpa': double.parse(cgpaController.text.trim()),
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) {
        return;
      }
      nameController.clear();
      regNoController.clear();
      cgpaController.clear();
      showMessage('Student saved to Firestore.');
    } catch (error) {
      if (mounted) {
        showMessage('Could not save student: $error');
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  String? validateCgpa(String? value) {
    final cgpa = double.tryParse(value?.trim() ?? '');
    if (cgpa == null || cgpa < 0 || cgpa > 10) {
      return 'Enter a CGPA from 0 to 10';
    }
    return null;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void openDetails(Map<String, dynamic> data) {
    Navigator.push(
      context,
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            StudentDetailsPage(data: data),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.15, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseReady = widget.firebaseError == null;
    final entrance = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: FadeTransition(
            opacity: entrance,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(entrance),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/apple.jpeg',
                      width: 120,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    if (!firebaseReady)
                      Card(
                        color: Colors.amber.shade100,
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Firebase is not configured. Generate firebase_options.dart to enable saving.',
                          ),
                        ),
                      ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Student name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => requiredText(value, 'Name'),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: regNoController,
                            decoration: const InputDecoration(
                              labelText: 'Register number',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                requiredText(value, 'Register number'),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: cgpaController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'CGPA',
                              border: OutlineInputBorder(),
                            ),
                            validator: validateCgpa,
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: firebaseReady && !isSaving
                                ? saveStudent
                                : null,
                            icon: isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(isSaving ? 'Saving...' : 'Register'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: firebaseReady
                          ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: students
                                  .orderBy('createdAt', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Firestore error: ${snapshot.error}',
                                    ),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final records = snapshot.data!.docs;
                                if (records.isEmpty) {
                                  return const Center(
                                    child: Text('No students registered yet.'),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: records.length,
                                  itemBuilder: (context, index) {
                                    final data = records[index].data();
                                    final studentName =
                                        data['name'] as String? ?? '?';
                                    return Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: Text(
                                            studentName
                                                .substring(0, 1)
                                                .toUpperCase(),
                                          ),
                                        ),
                                        title: Text(studentName),
                                        subtitle: Text(
                                          'Reg no: ${data['regNo'] ?? ''} | CGPA: ${data['cgpa'] ?? ''}',
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                        onTap: () => openDetails(data),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: Text('Firestore is unavailable.'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] as String? ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text('Register number: ${data['regNo'] ?? ''}'),
                Text('CGPA: ${data['cgpa'] ?? ''}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
