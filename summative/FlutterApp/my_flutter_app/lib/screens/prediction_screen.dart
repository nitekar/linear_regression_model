import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController inputController = TextEditingController();
  String result = "";

  void makePrediction() {
    setState(() {
      result = "https://linear-regression-model-m6bj.onrender.com/docs"; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prediction Page")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter value"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: makePrediction,
              child: Text("Predict"),
            ),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
