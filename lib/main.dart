import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ScreenSizeCalculator());
}

class ScreenSizeCalculator extends StatelessWidget {
  const ScreenSizeCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _selectedInput = 'Width'; // Tùy chọn nhập: Width hoặc Height
  String _selectedRatio = '16:9';
  String _selectedUnit = 'inch';
  double _width = 0.0; // Chiều ngang
  double _height = 0.0; // Chiều cao
  double _diagonalInInches = 0.0; // Đường chéo theo inch

  void _calculateSize() {
    double inputValue = 0.0;
    bool isMm = _selectedUnit == 'mm';

    // Lấy giá trị đầu vào dựa trên tùy chọn
    if (_selectedInput == 'Width') {
      inputValue = double.tryParse(_widthController.text) ?? 0;
    } else {
      inputValue = double.tryParse(_heightController.text) ?? 0;
    }

    if (inputValue == 0) return; // Không tính nếu giá trị nhập vào không hợp lệ

    if (isMm) {
      inputValue = inputValue / 25.4; // Chuyển từ mm sang inch
    }

    double widthRatio = _selectedRatio == '16:9' ? 16 : 4;
    double heightRatio = _selectedRatio == '16:9' ? 9 : 3;

    double width, height, diagonal;

    if (_selectedInput == 'Width') {
      // Nhập chiều ngang, tính chiều cao
      width = inputValue;
      height = (width / widthRatio) * heightRatio;
    } else {
      // Nhập chiều cao, tính chiều ngang
      height = inputValue;
      width = (height / heightRatio) * widthRatio;
    }

    // Tính đường chéo (luôn theo inch)
    diagonal = sqrt(pow(width, 2) + pow(height, 2));

    setState(() {
      _width = isMm ? width * 25.4 : width; // Chuyển về đơn vị người dùng chọn
      _height = isMm ? height * 25.4 : height;
      _diagonalInInches = diagonal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Máy tính màn chiếu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown chọn loại đầu vào
            DropdownButton<String>(
              value: _selectedInput,
              items: ['Width', 'Height'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Nhập $value'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedInput = newValue!;
                  _widthController.clear();
                  _heightController.clear();
                  _width = 0.0;
                  _height = 0.0;
                  _diagonalInInches = 0.0;
                });
              },
            ),
            const SizedBox(height: 10),
            // Trường nhập dựa trên tùy chọn
            if (_selectedInput == 'Width')
              TextField(
                controller: _widthController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Nhập chiều ngang:'),
              )
            else
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nhập chiều cao:'),
              ),
            const SizedBox(height: 10),
            // Dropdown chọn đơn vị
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
            const SizedBox(height: 10),
            // Dropdown chọn tỷ lệ
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateSize,
              child: const Text('Tính'),
            ),
            const SizedBox(height: 20),
            Text('Chiều ngang: ${_width.toStringAsFixed(2)} $_selectedUnit'),
            Text('Chiều cao: ${_height.toStringAsFixed(2)} $_selectedUnit'),
            Text('Đường chéo: ${_diagonalInInches.toStringAsFixed(2)} inch'),
            if (_selectedInput == 'Width' && _widthController.text.isNotEmpty)
              Text(
                'Khoảng cách: ${((double.parse(_widthController.text) * 1.34) / 1000).toStringAsFixed(2)} - ${((double.parse(_widthController.text) * 2.22) / 1000).toStringAsFixed(2)} m',
              )
            else if (_selectedInput == 'Height' &&
                _heightController.text.isNotEmpty)
              Text(
                'Khoảng cách: ${((_width * 1.34) / 1000).toStringAsFixed(2)} - ${((_width * 2.22) / 1000).toStringAsFixed(2)} m',
              ),
          ],
        ),
      ),
    );
  }
}
