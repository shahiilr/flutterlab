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
title: 'Dynamic ListView',
theme: ThemeData(
useMaterial3: false,
scaffoldBackgroundColor: const Color(0xFFFFF7FC),
),
home: const ProductPage(),
);
}
}
// Product class
class Product {
final String name;
final int price;
final int quantity;
const Product(this.name, this.price, this.quantity);
}
class ProductPage extends StatelessWidget {
const ProductPage({super.key});
// List of Product objects
static const List<Product> products = [
Product('Apple Laptop', 100000, 5),
Product('HP Laptop', 80000, 3),
Product('iPhone 16', 70000, 6),
Product('Samsung Mobile', 50000, 2),
Product('Smart TV', 45000, 10),
Product('OnePlus Mobile', 40000, 5),

];
// SnackBar when a product row is tapped
void showProductSnackBar(
BuildContext context, Product product) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('You tapped on ${product.name}'),
duration: const Duration(seconds: 2),
),
);
}
// AlertDialog when Order More is clicked
void showOrderDialog(BuildContext context, Product product) {
showDialog<void>(
context: context,
builder: (dialogContext) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(28),
),
title: const Text('Product Order Form'),
content: Text(
'${product.name} order is placed!!\n\n'
'Price: ₹${product.price}\n'
'Quantity: ${product.quantity}\n'
'Total: ₹${product.price * product.quantity}',
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(dialogContext);
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
'${product.name} order is placed successfully!',
),
duration: const Duration(seconds: 2),
),
);
},
child: const Text('OK'),

),
],
);
},
);
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Dynamic ListView'),
centerTitle: true,
backgroundColor: const Color(0xFFE887A7),
foregroundColor: Colors.black87,
),
// Generate rows dynamically from Product objects
body: ListView.builder(
itemCount: products.length,
itemBuilder: (context, index) {
final product = products[index];
return Column(
children: [
ListTile(
contentPadding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 8,
),
// First letter inside CircleAvatar
leading: CircleAvatar(
radius: 24,
backgroundColor: const Color(0xFFE8D9FA),
child: Text(
product.name[0],
style: const TextStyle(
color: Color(0xFF66508E),
fontSize: 18,
),
),
),

// Tap the row to show a SnackBar
onTap: () {
showProductSnackBar(context, product);
},
title: Text(
product.name,
style: const TextStyle(fontSize: 18),
),
subtitle: Text(
'₹.${product.price},Quantity:${product.quantity}',
style: const TextStyle(fontSize: 14),
),
// Button to open AlertDialog
trailing: ElevatedButton(
onPressed: () {
showOrderDialog(context, product);
},
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF43A847),
foregroundColor: Colors.white,
elevation: 0,
padding: const EdgeInsets.symmetric(
horizontal: 14,
vertical: 11,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(24),
),
),
child: const Text('Order More'),
),
),
const Divider(height: 1),
],
);
},
),
);
}
}