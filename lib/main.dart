import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ScreenSizeCalculator());
}

class ScreenSizeCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenCalculatorPage(),
    );
  }
}

class ScreenCalculatorPage extends StatefulWidget {
  @override
  _ScreenCalculatorPageState createState() => _ScreenCalculatorPageState();
}

class _ScreenCalculatorPageState extends State<ScreenCalculatorPage> {
  final TextEditingController _lengthController = TextEditingController();
  String _selectedRatio = '16:9';
  String _selectedUnit = 'inch';
  double _height = 0.0;
  double _diagonalInInches = 0.0; // Luôn lưu đường chéo theo inch

  void _calculateSize() {
    double length = double.tryParse(_lengthController.text) ?? 0;
    bool isMm = _selectedUnit == 'mm';

    if (isMm) {
      length = length / 25.4; // Chuyển từ mm sang inch
    }

    double widthRatio = _selectedRatio == '16:9' ? 16 : 4;
    double heightRatio = _selectedRatio == '16:9' ? 9 : 3;
    double height = (length / widthRatio) * heightRatio;
    double diagonal =
        sqrt(pow(length, 2) + pow(height, 2)); // Luôn tính theo inch

    setState(() {
      _height = isMm
          ? height * 25.4
          : height; // Chuyển chiều cao về đúng đơn vị (mm hoặc inch)
      _diagonalInInches = diagonal; // Đường chéo luôn ở inch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screen Size Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _lengthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter screen width'),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedUnit,
              items: ['inch', 'mm'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedRatio,
              items: ['16:9', '4:3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRatio = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateSize,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text('Height: ${_height.toStringAsFixed(2)} $_selectedUnit'),
            Text('Diagonal: ${_diagonalInInches.toStringAsFixed(2)} inch'),
          ],
        ),
      ),
    );
  }
}
