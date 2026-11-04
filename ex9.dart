import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: UserPage()),
  );
}

class User {
  const User({required this.name, required this.email, required this.company});

  final String name;
  final String email;
  final String company;

  factory User.fromJson(Map<String, dynamic> json) {
    final companyData = json['company'];
    return User(
      name: json['name'] as String? ?? 'Unknown user',
      email: json['email'] as String? ?? 'No email',
      company: companyData is Map<String, dynamic>
          ? companyData['name'] as String? ?? 'Unknown company'
          : 'Unknown company',
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  static final _usersUrl = Uri.parse(
    'https://jsonplaceholder.typicode.com/users',
  );

  List<User> users = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(_usersUrl);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('The server returned HTTP ${response.statusCode}.');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('The API returned an invalid response.');
      }

      final loadedUsers = decoded
          .whereType<Map<String, dynamic>>()
          .map(User.fromJson)
          .toList();

      if (!mounted) {
        return;
      }
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } on http.ClientException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        errorMessage = 'Network error: ${error.message}';
      });
    } on FormatException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        errorMessage = 'Response error: ${error.message}';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        errorMessage = 'Unable to load users: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: isLoading ? null : fetchUsers,
            child: Text(isLoading ? 'Loading...' : 'Fetch Users'),
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : users.isEmpty
                ? const Center(child: Text('Press Fetch Users to load data.'))
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(user.name),
                        subtitle: Text('${user.email}\n${user.company}'),
                        isThreeLine: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
