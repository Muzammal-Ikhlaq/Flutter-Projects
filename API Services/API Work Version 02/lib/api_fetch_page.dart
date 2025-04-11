import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'db_helper.dart';

class ApiFetchPage extends StatefulWidget {
  const ApiFetchPage({super.key});

  @override
  State<ApiFetchPage> createState() => _ApiFetchPageState();
}

class _ApiFetchPageState extends State<ApiFetchPage> {
  bool _loading = false;

  // Function to fetch data from the API and insert it into the local database
  Future<void> _fetchAndSaveData() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(Uri.parse('https://bgnuerp.online/api/gradeapi'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Resetting the local database before inserting new data
        await DatabaseHelper.instance.resetDatabase();

        // Inserting fetched data into the local database
        for (var item in data) {
          await DatabaseHelper.instance.insertData({
            'student_name': item['studentname'] ?? 'Unknown',
            'father_name': item['fathername'] ?? 'Unknown',
            'department_name': item['progname'] ?? 'Unknown',
            'shift': item['shift'] ?? 'Unknown',
            'rollno': item['rollno'] ?? 'Unknown',
            'course_code': item['coursecode'] ?? 'Unknown',
            'course_title': item['coursetitle'] ?? 'Unknown',
            'credit_hours': item['credithours'] ?? 'Unknown',
            'obtained_marks': item['obtainedmarks'] ?? 'Unknown',
            'semester': item['mysemester'] ?? 'Unknown',
            'consider_status': item['consider_status'] ?? 'Unknown',
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data fetched successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  // Function to erase all data from the local database
  Future<void> _eraseData() async {
    await DatabaseHelper.instance.resetDatabase();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All data erased'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Data Fetch"),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator() // Show loading indicator if data is being fetched
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _fetchAndSaveData, // Load data button
              child: const Text("Load API Data"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _eraseData, // Erase data button
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Replaces 'primary' with 'backgroundColor'
              ),
              child: const Text("Erase Data"), // 'child' argument last
            ),
          ],
        ),
      ),
    );
  }
}
