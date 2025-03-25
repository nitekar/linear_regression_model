import 'package:flutter/material.dart';
import 'display_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController inputController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0.8,
      upperBound: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    inputController.dispose();
    super.dispose();
  }

  Future<void> makePrediction() async {
    final inputValue = inputController.text;
    if (inputValue.isEmpty) return;

    final response = await http.post(
      Uri.parse('https://linear-regression-model-m6bj.onrender.com/docs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'input': inputValue}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['prediction'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayScreen(prediction: result),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Invalid response from server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Prediction Input')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter input value',
              ),
            ),
            SizedBox(height: 20),
            ScaleTransition(
              scale: _scaleAnimation,
              child: ElevatedButton(
                onPressed: makePrediction,
                child: Text('Predict'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
