import 'package:flutter/material.dart'; 
void main() { 
runApp(const MyApp()); 
} 
class MyApp extends StatelessWidget { 
const MyApp({super.key}); 
@override 
Widget build(BuildContext context) { 
return const MaterialApp( 
debugShowCheckedModeBanner: false, 
home: MarkPage(), 
); 
} 
} 
class MarkPage extends StatefulWidget { 
const MarkPage({super.key}); 
@override 
State<MarkPage> createState() => _MarkPageState(); } 
class _MarkPageState extends State<MarkPage> { final mark1 = TextEditingController(); 
final mark2 = TextEditingController(); 
final mark3 = TextEditingController(); 
String result = ''; 
void calculate() { 
double m1 = double.tryParse(mark1.text) ?? -1; double m2 = double.tryParse(mark2.text) ?? -1; double m3 = double.tryParse(mark3.text) ?? -1; 
setState(() { 
if (m1 < 0 || m1 > 100 || 
m2 < 0 || m2 > 100 || 
m3 < 0 || m3 > 100) { 
result = 'Enter valid marks between 0 and 100!'; } else {
double percentage = (m1 + m2 + m3) / 3; 
result = 
'Total Marks: ${m1 + m2 + m3} / 300\n' 
'Percentage: ${percentage.toStringAsFixed(2)}%'; } 
}); 
} 
@override 
void dispose() { 
mark1.dispose(); 
mark2.dispose(); 
mark3.dispose(); 
super.dispose(); 
} 
@override 
Widget build(BuildContext context) { 
return Scaffold( 
appBar: AppBar( 
title: const Text('Student Mark Calculator'), backgroundColor: Colors.pink, 
), 
body: Padding( 
padding: const EdgeInsets.all(20), 
child: SingleChildScrollView( 
child: Column( 
children: [ 
Image.asset( 
'assets/images/student.png', 
height: 130, 
), 
const SizedBox(height: 15), 
const Text( 
'Student Mark Percentage', 
style: TextStyle( 
fontSize: 23, 
fontWeight: FontWeight.bold, 
color: Colors.deepPurple, 
), 
),
const SizedBox(height: 25), 
TextField( 
controller: mark1, 
keyboardType: TextInputType.number, decoration: const InputDecoration( labelText: 'Subject 1 Marks (out of 100)', border: OutlineInputBorder(), 
), 
), 
const SizedBox(height: 15), 
TextField( 
controller: mark2, 
keyboardType: TextInputType.number, decoration: const InputDecoration( labelText: 'Subject 2 Marks (out of 100)', border: OutlineInputBorder(), 
), 
), 
const SizedBox(height: 15), 
TextField( 
controller: mark3, 
keyboardType: TextInputType.number, decoration: const InputDecoration( labelText: 'Subject 3 Marks (out of 100)', border: OutlineInputBorder(), 
), 
), 
const SizedBox(height: 20), 
ElevatedButton( 
onPressed: calculate, 
child: const Text('Calculate Percentage'), ), 
const SizedBox(height: 20), 
Text( 
result,
textAlign: TextAlign.center, 
style: const TextStyle( 
fontSize: 20, 
color: Colors.deepPurple, 
), 
), 
], 
), 
), 
), 
); 
} 
}
