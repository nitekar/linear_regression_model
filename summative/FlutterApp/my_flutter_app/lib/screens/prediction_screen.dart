import 'package:flutter/material.dart';
import 'display_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // Controllers for input fields
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _currentJobLevelController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _startingSalaryController = TextEditingController();
  final TextEditingController _educationLevelController = TextEditingController();
  final TextEditingController _workExperienceController = TextEditingController();

  // Dropdown for categorical variables
  String _selectedIndustry = 'Technology';
  List<String> _industryOptions = [
    'Technology', 
    'Finance', 
    'Healthcare', 
    'Education', 
    'Marketing', 
    'Engineering'
  ];

  bool _isLoading = false;

  Future<void> _makePrediction() async {
    // Validate inputs
    if (_validateInputs()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('https://linear-regression-model-m6bj.onrender.com/docs'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'age': int.parse(_ageController.text),
            'current_job_level': int.parse(_currentJobLevelController.text),
            'field_of_study': _fieldOfStudyController.text,
            'starting_salary': int.parse(_startingSalaryController.text),
            'education_level': _educationLevelController.text,
            'work_experience': int.parse(_workExperienceController.text),
            'industry': _selectedIndustry,
          }),
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          
          // Navigate to Display Screen with prediction result
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayScreen(
                predictionResult: result['prediction'],
              ),
            ),
          );
        } else {
          _showErrorDialog('Error processing prediction');
        }
      } catch (e) {
        _showErrorDialog('Error: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  bool _validateInputs() {
    // Check if all fields are filled
    final controllers = [
      _ageController,
      _currentJobLevelController,
      _fieldOfStudyController,
      _startingSalaryController,
      _educationLevelController,
      _workExperienceController,
    ];

    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        _showErrorDialog('Please fill in all fields');
        return false;
      }
    }

    // Additional numeric validation
    try {
      int.parse(_ageController.text);
      int.parse(_currentJobLevelController.text);
      int.parse(_startingSalaryController.text);
      int.parse(_workExperienceController.text);
    } catch (e) {
      _showErrorDialog('Please enter valid numeric values');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Career Prediction Input'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_ageController, 'Age'),
            SizedBox(height: 10),
            _buildTextField(_currentJobLevelController, 'Current Job Level (1-10)'),
            SizedBox(height: 10),
            _buildTextField(_fieldOfStudyController, 'Field of Study'),
            SizedBox(height: 10),
            _buildTextField(_startingSalaryController, 'Starting Salary'),
            SizedBox(height: 10),
            _buildTextField(_educationLevelController, 'Education Level'),
            SizedBox(height: 10),
            _buildTextField(_workExperienceController, 'Work Experience (Years)'),
            SizedBox(height: 10),
            // Industry Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Industry',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              value: _selectedIndustry,
              items: _industryOptions.map((String industry) {
                return DropdownMenuItem<String>(
                  value: industry,
                  child: Text(industry),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIndustry = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _makePrediction,
              child: _isLoading 
                ? CircularProgressIndicator() 
                : Text('Predict', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: label == 'Field of Study' || label == 'Education Level' 
        ? TextInputType.text 
        : TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}