import 'package:flutter/material.dart';
import 'db_helper.dart';

class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  List<Map<String, dynamic>> _grades = [];
  String _selectedFilter = 'None';
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.fetchData();
    setState(() {
      _grades = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteRow(int id) async {
    await DatabaseHelper.instance.deleteRow(id);
    await _loadData();
  }

  List<Map<String, dynamic>> get _filteredGrades {
    List<Map<String, dynamic>> filtered = [..._grades];

    switch (_selectedFilter) {
      case 'A-Z':
        filtered.sort((a, b) => a['student_name'].compareTo(b['student_name']));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b['student_name'].compareTo(a['student_name']));
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((grade) => grade['student_name']
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          grade['course_title']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

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
                'Student Grade Table',
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
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Field
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name or course...',
                          prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (query) {
                          setState(() => _searchQuery = query);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Filter Dropdown
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<String>(
                          value: _selectedFilter,
                          decoration: const InputDecoration(
                            labelText: 'Sort By',
                            border: InputBorder.none,
                          ),
                          items: ['None', 'A-Z', 'Z-A']
                              .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedFilter = value ?? 'None'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Data Table
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredGrades.isEmpty
                  ? const Center(
                child: Text(
                  'No data found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DataTable(
                    headingRowColor:
                    WidgetStateProperty.all(Colors.indigo.shade50),
                    dataRowColor: WidgetStateProperty.all(Colors.white),
                    columns: const [
                      DataColumn(
                          label: Text('Name',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Father Name',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Department',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Shift',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Roll No',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Course Code',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Course Title',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Credit Hrs',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Marks',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Semester',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Action',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: _filteredGrades.map((grade) {
                      return DataRow(
                        cells: [
                          DataCell(Text(grade['student_name'])),
                          DataCell(Text(grade['father_name'])),
                          DataCell(Text(grade['department_name'])),
                          DataCell(Text(grade['shift'])),
                          DataCell(Text(grade['rollno'])),
                          DataCell(Text(grade['course_code'])),
                          DataCell(Text(grade['course_title'])),
                          DataCell(Text(grade['credit_hours'])),
                          DataCell(Text(grade['obtained_marks'])),
                          DataCell(Text(grade['semester'])),
                          DataCell(
                            Tooltip(
                              message: 'Delete Record',
                              child: IconButton(
                                icon: const Icon(Icons.delete_forever),
                                color: Colors.red.shade400,
                                onPressed: () => _deleteRow(grade['id']),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
