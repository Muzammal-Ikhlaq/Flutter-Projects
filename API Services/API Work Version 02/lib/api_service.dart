import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const GradeSubmissionApp());
}

class GradeSubmissionApp extends StatelessWidget {
  const GradeSubmissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Submission',
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
      home: const GradeSubmissionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GradeSubmissionScreen extends StatefulWidget {
  const GradeSubmissionScreen({super.key});

  @override
  State<GradeSubmissionScreen> createState() => _GradeSubmissionScreenState();
}

class _GradeSubmissionScreenState extends State<GradeSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  String? _selectedSemester;
  String? _selectedCreditHours;
  String _sortOrder = 'oldest';

  String _responseMessage = '';
  bool _isSuccess = false;
  bool _isLoading = false;
  bool _isFetching = false;

  List<dynamic> _submittedData = [];

  static const _submitGradeUrl = 'https://devtechtop.com/management/public/api/grades';
  static const _fetchGradesUrl = 'https://devtechtop.com/management/public/api/select_data';

  static const _semesterOptions = ['1', '2', '3', '4', '5', '6', '7', '8'];
  static const _creditHoursOptions = ['1', '2', '3', '4'];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    try {
      final uri = Uri.parse(_submitGradeUrl).replace(queryParameters: {
        'user_id': _userIdController.text.trim(),
        'course_name': _courseNameController.text.trim(),
        'semester_no': _selectedSemester,
        'credit_hours': _selectedCreditHours,
        'marks': _marksController.text.trim(),
      });

      debugPrint('Submitting to URL: $uri');
      debugPrint('Request Parameters: ${uri.queryParameters}');

      final response = await http.get(uri).timeout(const Duration(seconds: 30));

      debugPrint('Submit Status Code: ${response.statusCode}');
      debugPrint('Submit Body: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _isSuccess = true;
          _responseMessage = 'Grade submitted successfully!';
        });
        _formKey.currentState!.reset();
        _userIdController.clear();
        _courseNameController.clear();
        _marksController.clear();
        _selectedSemester = null;
        _selectedCreditHours = null;
        // Uncomment to auto-refresh list after submission
        // await _fetchSubmittedData();
      } else {
        String errorMsg = 'Error submitting grade: ${response.statusCode}';
        try {
          final jsonResponse = json.decode(response.body);
          errorMsg = jsonResponse['message'] ?? errorMsg;
        } catch (_) {}
        setState(() {
          _isSuccess = false;
          _responseMessage = errorMsg;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSuccess = false;
        _responseMessage = 'Error: ${e.toString().replaceAll(RegExp(r'^Exception: '), '')}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchSubmittedData() async {
    if (_isFetching) return;

    setState(() => _isFetching = true);

    try {
      final response = await http.get(
        Uri.parse(_fetchGradesUrl),
      ).timeout(const Duration(seconds: 30));

      debugPrint('Fetch Status Code: ${response.statusCode}');
      debugPrint('Fetch Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() => _submittedData = data);
        } else if (data is Map && data.containsKey('data') && data['data'] is List) {
          setState(() => _submittedData = data['data']);
        } else {
          setState(() {
            _responseMessage = 'Error: Unexpected data format - ${data.runtimeType}';
          });
        }
      } else {
        setState(() {
          _responseMessage = 'Error fetching grades: ${response.statusCode}';
        });
      }
    } catch (e) {
      debugPrint('Error fetching grades: $e');
      setState(() {
        _responseMessage = 'Error fetching grades: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  List<dynamic> _getSortedData() {
    List<dynamic> sortedData = List.from(_submittedData);
    sortedData.sort((a, b) {
      int idA = int.tryParse(a['id'] ?? '0') ?? 0;
      int idB = int.tryParse(b['id'] ?? '0') ?? 0;
      return _sortOrder == 'oldest' ? idA.compareTo(idB) : idB.compareTo(idA);
    });
    return sortedData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Submission'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isFetching ? null : _fetchSubmittedData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _userIdController,
                    decoration: const InputDecoration(labelText: 'User ID'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter user ID' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _courseNameController,
                    decoration: const InputDecoration(labelText: 'Course Name'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter course name' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSemester,
                    decoration: const InputDecoration(labelText: 'Semester'),
                    items: _semesterOptions
                        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (newValue) => setState(() => _selectedSemester = newValue),
                    validator: (value) => value == null ? 'Please select semester' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCreditHours,
                    decoration: const InputDecoration(labelText: 'Credit Hours'),
                    items: _creditHoursOptions
                        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (newValue) => setState(() => _selectedCreditHours = newValue),
                    validator: (value) => value == null ? 'Please select credit hours' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _marksController,
                    decoration: const InputDecoration(labelText: 'Marks (0-100)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter marks';
                      final marks = int.tryParse(value);
                      if (marks == null || marks < 0 || marks > 100) {
                        return 'Marks must be between 0 and 100';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Submit'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isFetching ? null : _fetchSubmittedData,
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    child: _isFetching
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Show Grades'),
                  ),
                  const SizedBox(height: 16),
                  if (_responseMessage.isNotEmpty)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isSuccess ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _isSuccess ? Colors.green : Colors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isSuccess ? Icons.check_circle : Icons.error,
                            color: _isSuccess ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _responseMessage,
                              style: TextStyle(
                                color: _isSuccess ? Colors.green[800] : Colors.red[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Text('Submitted Grades',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (_isFetching)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sort by:'),
                DropdownButton<String>(
                  value: _sortOrder,
                  items: [
                    DropdownMenuItem(value: 'oldest', child: Text('Oldest First')),
                    DropdownMenuItem(value: 'newest', child: Text('Newest First')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sortOrder = value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _submittedData.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                _isFetching ? 'Loading grades...' : 'No grades fetched yet',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getSortedData().length,
              itemBuilder: (context, index) {
                final grade = _getSortedData()[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(grade['course_name']?.toString() ?? 'Unknown Course'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User ID: ${grade['user_id']}'),
                        Text('Semester: ${grade['semester_no']}'),
                        Text('Credit Hours: ${grade['credit_hours']}'),
                        Text('Marks: ${grade['marks']}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _courseNameController.dispose();
    _marksController.dispose();
    super.dispose();
  }
}