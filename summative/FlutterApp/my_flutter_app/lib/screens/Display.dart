import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  final dynamic predictionResult;

  DisplayScreen({required this.predictionResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Career Prediction Icon
              Icon(
                _getIconForPrediction(),
                size: 100,
                color: _getColorForPrediction(),
              ),
              
              SizedBox(height: 20),
              
              // Prediction Title
              Text(
                _getPredictionTitle(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getColorForPrediction(),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 20),
              
              // Detailed Prediction Description
              Text(
                _getPredictionDescription(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 40),
              
              // Buttons for further action
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                    ),
                    child: Text('Back to Home'),
                  ),
                  SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {
                      // Potential future feature like detailed report
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Detailed report feature coming soon!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[700],
                    ),
                    child: Text('More Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to interpret prediction
  IconData _getIconForPrediction() {
    switch (predictionResult) {
      case 0:
        return Icons.trending_down;
      case 1:
        return Icons.trending_flat;
      case 2:
        return Icons.trending_up;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForPrediction() {
    switch (predictionResult) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPredictionTitle() {
    switch (predictionResult) {
      case 0:
        return 'Low Potential';
      case 1:
        return 'Moderate Potential';
      case 2:
        return 'High Potential';
      default:
        return 'Inconclusive';
    }
  }

  String _getPredictionDescription() {
    switch (predictionResult) {
      case 0:
        return 'Based on the provided information, your career potential appears to be limited. Consider additional training or exploring alternative career paths.';
      case 1:
        return 'You have moderate career potential. With some strategic improvements and continued learning, you can enhance your career trajectory.';
      case 2:
        return 'Congratulations! Your career potential looks promising. Continue to leverage your strengths and pursue growth opportunities.';
      default:
        return 'Unable to provide a definitive prediction based on the given information.';
    }
  }
}