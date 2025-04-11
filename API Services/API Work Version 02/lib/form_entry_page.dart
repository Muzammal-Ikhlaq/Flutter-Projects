import 'package:flutter/material.dart';
import 'db_helper.dart';

class FormEntryPage extends StatefulWidget {
  const FormEntryPage({super.key});

  @override
  State<FormEntryPage> createState() => _FormEntryPageState();
}

class _FormEntryPageState extends State<FormEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _shiftController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseTitleController = TextEditingController();
  final TextEditingController _creditHoursController = TextEditingController();
  final TextEditingController _obtainedMarksController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _considerStatusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Add Student Record',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade700, Colors.indigo.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(_studentNameController, 'Student Name'),
                        _buildTextField(_fatherNameController, 'Father Name'),
                        _buildTextField(_departmentController, 'Department Name'),
                        _buildTextField(_shiftController, 'Shift'),
                        _buildTextField(_rollNoController, 'Roll No'),
                        _buildTextField(_courseCodeController, 'Course Code'),
                        _buildTextField(_courseTitleController, 'Course Title'),
                        _buildTextField(_creditHoursController, 'Credit Hours',
                            keyboardType: TextInputType.number),
                        _buildTextField(_obtainedMarksController, 'Obtained Marks',
                            keyboardType: TextInputType.number),
                        _buildTextField(_semesterController, 'Semester'),
                        _buildTextField(_considerStatusController, 'Consider Status'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.indigo.shade600,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'Save Record',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.indigo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          filled: true,
          fillColor: Colors.indigo.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, String> data = {
        'student_name': _studentNameController.text,
        'father_name': _fatherNameController.text,
        'department_name': _departmentController.text,
        'shift': _shiftController.text,
        'rollno': _rollNoController.text,
        'course_code': _courseCodeController.text,
        'course_title': _courseTitleController.text,
        'credit_hours': _creditHoursController.text,
        'obtained_marks': _obtainedMarksController.text,
        'semester': _semesterController.text,
        'consider_status': _considerStatusController.text,
      };
      DatabaseHelper.instance.insertData(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data added successfully'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      _clearFields();
    }
  }

  void _clearFields() {
    _studentNameController.clear();
    _fatherNameController.clear();
    _departmentController.clear();
    _shiftController.clear();
    _rollNoController.clear();
    _courseCodeController.clear();
    _courseTitleController.clear();
    _creditHoursController.clear();
    _obtainedMarksController.clear();
    _semesterController.clear();
    _considerStatusController.clear();
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _fatherNameController.dispose();
    _departmentController.dispose();
    _shiftController.dispose();
    _rollNoController.dispose();
    _courseCodeController.dispose();
    _courseTitleController.dispose();
    _creditHoursController.dispose();
    _obtainedMarksController.dispose();
    _semesterController.dispose();
    _considerStatusController.dispose();
    super.dispose();
  }
}