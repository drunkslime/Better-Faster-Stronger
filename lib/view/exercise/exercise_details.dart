import 'package:flutter/material.dart';

class ExerciseDetails extends StatefulWidget {
  final Map<String, dynamic> exerciseData;
  const ExerciseDetails({super.key, required this.exerciseData});

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
                SafeArea(
                  child: Text(widget.exerciseData.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n'))
                ),
              ],
          )
        ),
      ),
    );
  }
}