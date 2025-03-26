import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'display_screen.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // Define all required controllers
  final TextEditingController input1Controller = TextEditingController();
  final TextEditingController input2Controller = TextEditingController();
  final TextEditingController input3Controller = TextEditingController();
  final TextEditingController input4Controller = TextEditingController();
  final TextEditingController input5Controller = TextEditingController();
  final TextEditingController input6Controller = TextEditingController();
  final TextEditingController input7Controller = TextEditingController();
  final TextEditingController input8Controller = TextEditingController();
  final TextEditingController input9Controller = TextEditingController();
  final TextEditingController input10Controller = TextEditingController();

  String _result = ''; // Store the prediction result

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    input1Controller.dispose();
    input2Controller.dispose();
    input3Controller.dispose();
    input4Controller.dispose();
    input5Controller.dispose();
    input6Controller.dispose();
    input7Controller.dispose();
    input8Controller.dispose();
    input9Controller.dispose();
    input10Controller.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    final Uri apiUrl = Uri.parse('https://linear-regression-model-m6bj.onrender.com/docs');

    // Collect all inputs in a JSON format
    final Map<String, dynamic> inputData = {
      "age": input1Controller.text,
      "gender": input2Controller.text,
      "university_gpa": input3Controller.text,
      "job_offers": input4Controller.text,
      "internships": input5Controller.text,
      "projects_completed": input6Controller.text,
      "field_of_study": input7Controller.text,
      "soft_skills_score": input8Controller.text,
      "network_score": input9Controller.text,
      "career_satisfaction": input10Controller.text,
    };

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _result = 'Predicted Value: ${responseData['prediction']}';
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayScreen(prediction: _result),
          ),
        );
      } else {
        setState(() {
          _result = 'Error: Unable to get prediction';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: Failed to connect to the API';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Career Prediction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Fix Overflow Issue
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: input1Controller, decoration: InputDecoration(labelText: "Age")),
              TextField(controller: input2Controller, decoration: InputDecoration(labelText: "Gender")),
              TextField(controller: input3Controller, decoration: InputDecoration(labelText: "University GPA")),
              TextField(controller: input4Controller, decoration: InputDecoration(labelText: "Job Offers")),
              TextField(controller: input5Controller, decoration: InputDecoration(labelText: "Internships Completed")),
              TextField(controller: input6Controller, decoration: InputDecoration(labelText: "Projects Completed")),
              TextField(controller: input7Controller, decoration: InputDecoration(labelText: "Field of Study")),
              TextField(controller: input8Controller, decoration: InputDecoration(labelText: "Soft Skills Score")),
              TextField(controller: input9Controller, decoration: InputDecoration(labelText: "Network Score")),
              TextField(controller: input10Controller, decoration: InputDecoration(labelText: "Career Satisfaction")),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _predict,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Predict', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              Text(_result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
