import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final List<Map<String, String>> fruits = const [
    {'name': 'Apple', 'price': '₹180.00', 'image': 'assets/apple.jpeg'},
    {'name': 'Orange', 'price': '₹100.00', 'image': 'assets/orange.jpeg'},
    {'name': 'Mango', 'price': '₹70.00', 'image': 'assets/mango.jpeg'},
    {
      'name': 'Pomegranate',
      'price': '₹250.00',
      'image': 'assets/pomegranate.jpeg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom List View'), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double imageSize = constraints.maxWidth < 600 ? 100 : 150;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: fruits.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // Image
                      Image.asset(
                        fruits[index]['image']!,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 15),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fruits[index]['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(fruits[index]['price']!),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Buy Now'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
