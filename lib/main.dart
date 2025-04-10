import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ScreenSizeCalculator()); // Thêm const
}

class ScreenSizeCalculator extends StatelessWidget {
  const ScreenSizeCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Thêm const
      debugShowCheckedModeBanner: false,
      home: ScreenCalculatorPage(),
    );
  }
}

class ScreenCalculatorPage extends StatefulWidget {
  const ScreenCalculatorPage({super.key});

  @override
  ScreenCalculatorPageState createState() => ScreenCalculatorPageState();
}

class ScreenCalculatorPageState extends State<ScreenCalculatorPage> {
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
      appBar: AppBar(title: const Text('Máy tính màn chiếu')), // Thêm const
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Đã có const từ trước
        child: Column(
          children: [
            TextField(
              controller: _lengthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Nhập chiều ngang: '), // Thêm const
            ),
            const SizedBox(height: 10), // Thêm const
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
            const SizedBox(height: 10), // Thêm const
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
            const SizedBox(height: 20), // Thêm const
            ElevatedButton(
              onPressed: _calculateSize,
              child: const Text('Tính'), // Thêm const
            ),
            const SizedBox(height: 20), // Thêm const
            Text('Chiều cao: ${_height.toStringAsFixed(2)} $_selectedUnit'),
            Text('Đường chéo: ${_diagonalInInches.toStringAsFixed(2)} inch'),
            if (_lengthController.text.isNotEmpty)
              Text(
                  'Khoảng cách:  ${((int.parse(_lengthController.text.toString()) * 1.34) / 1000).toStringAsFixed(2)} - ${((int.parse(_lengthController.text.toString()) * 2.22) / 1000).toStringAsFixed(2)} m'),
          ],
        ),
      ),
    );
  }
}
