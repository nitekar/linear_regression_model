import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

void main() {
  runApp(WorkLifeBalanceApp());
}

class WorkLifeBalanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work-Life Balance Predictor',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> with SingleTickerProviderStateMixin {
  // Input controllers
  final TextEditingController _workHoursController = TextEditingController();
  final TextEditingController _stressLevelController = TextEditingController();
  final TextEditingController _sleepHoursController = TextEditingController();
  final TextEditingController _personalTimeController = TextEditingController();
  final TextEditingController _workSatisfactionController = TextEditingController();

  String _predictionResult = '';
  bool _isLoading = false;

  // Animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _workHoursController.dispose();
    _stressLevelController.dispose();
    _sleepHoursController.dispose();
    _personalTimeController.dispose();
    _workSatisfactionController.dispose();
    super.dispose();
  }

  Future<void> _predictWorkLifeBalance() async {
    // Validate inputs
    if (_validateInputs()) {
      setState(() {
        _isLoading = true;
        _predictionResult = '';
      });

      try {
        // Replace with your actual API endpoint
        final response = await http.post(
          Uri.parse('http://YOUR_API_ENDPOINT/predict'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'work_hours': int.parse(_workHoursController.text),
            'stress_level': int.parse(_stressLevelController.text),
            'sleep_hours': int.parse(_sleepHoursController.text),
            'personal_time': int.parse(_personalTimeController.text),
            'work_satisfaction': int.parse(_workSatisfactionController.text),
          }),
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          setState(() {
            _predictionResult = _interpretPrediction(result['prediction']);
            _animationController.forward(from: 0.0);
          });
        } else {
          setState(() {
            _predictionResult = 'Error processing prediction';
          });
        }
      } catch (e) {
        setState(() {
          _predictionResult = 'Error: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _interpretPrediction(int prediction) {
    switch (prediction) {
      case 0:
        return 'Poor Work-Life Balance\nConsider making significant changes';
      case 1:
        return 'Moderate Work-Life Balance\nSome improvements needed';
      case 2:
        return 'Excellent Work-Life Balance\nKeep up the great work!';
      default:
        return 'Unable to determine';
    }
  }

  bool _validateInputs() {
    final controllers = [
      _workHoursController,
      _stressLevelController,
      _sleepHoursController,
      _personalTimeController,
      _workSatisfactionController
    ];

    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        setState(() {
          _predictionResult = 'Please fill in all fields';
        });
        return false;
      }
    }

    try {
      int.parse(_workHoursController.text);
      int.parse(_stressLevelController.text);
      int.parse(_sleepHoursController.text);
      int.parse(_personalTimeController.text);
      int.parse(_workSatisfactionController.text);
    } catch (e) {
      setState(() {
        _predictionResult = 'Invalid input. Please enter numeric values.';
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work-Life Balance Predictor'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInDown(
              child: _buildTextField(_workHoursController, 'Weekly Work Hours'),
            ),
            SizedBox(height: 10),
            FadeInDown(
              delay: Duration(milliseconds: 100),
              child: _buildTextField(_stressLevelController, 'Stress Level (1-10)'),
            ),
            SizedBox(height: 10),
            FadeInDown(
              delay: Duration(milliseconds: 200),
              child: _buildTextField(_sleepHoursController, 'Daily Sleep Hours'),
            ),
            SizedBox(height: 10),
            FadeInDown(
              delay: Duration(milliseconds: 300),
              child: _buildTextField(_personalTimeController, 'Daily Personal Time (Hours)'),
            ),
            SizedBox(height: 10),
            FadeInDown(
              delay: Duration(milliseconds: 400),
              child: _buildTextField(_workSatisfactionController, 'Work Satisfaction (1-10)'),
            ),
            SizedBox(height: 20),
            FadeInUp(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _predictWorkLifeBalance,
                child: _isLoading 
                  ? CircularProgressIndicator() 
                  : Text('Predict Balance', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildResultDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.teal[50],
      ),
    );
  }

  Widget _buildResultDisplay() {
    return FadeIn(
      controller: _animationController,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getPredictionColor(),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Text(
          _predictionResult,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getPredictionColor() {
    if (_predictionResult.contains('Poor')) return Colors.red;
    if (_predictionResult.contains('Moderate')) return Colors.orange;
    if (_predictionResult.contains('Excellent')) return Colors.green;
    return Colors.grey;
  }
}
