import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int round = 0; // changes to replay the animation
  final liked = <int>{}; // liked fruit indexes
  final fruits = const [
    {'name': 'Apple', 'price': '₹180', 'image': 'assets/apple.jpeg'},
    {'name': 'Orange', 'price': '₹100', 'image': 'assets/orange.jpeg'},
    {'name': 'Mango', 'price': '₹70', 'image': 'assets/mango.jpeg'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits')),
      // Replay button
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => round++),
        child: const Icon(Icons.replay),
      ),
      body: ListView.builder(
        key: ValueKey(round), // new key = animation restarts
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          // ANIMATION: slide up + fade in, one by one
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 800 + index * 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 100 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: Image.asset(
                  fruit['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 400),
                          child: child,
                        );
                      },
                ),
                title: Text(fruit['name']!),
                subtitle: Text(fruit['price']!),
                // TRANSITION: icon scales when it changes
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      liked.contains(index)
                          ? liked.remove(index)
                          : liked.add(index);
                    });
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, anim) {
                      return ScaleTransition(scale: anim, child: child);
                    },
                    child: Icon(
                      liked.contains(index)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      key: ValueKey(liked.contains(index)),
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
