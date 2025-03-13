import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'muzammal_e09',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/calculator': (context) => CalculatorPage(),
        '/gradebook': (context) => GradeBookPage(),
        '/myprofile': (context) => MyProfilePage(),
        '/input': (context) => InputPage(),
        '/display': (context) => DisplayPage(),
        '/userform': (context) => UserFormPage(),
        '/userdisplay': (context) => UserDisplayPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/university_logo.png', height: 40),
            SizedBox(width: 8),
            Text('Baba Guru Nanak University, Nankana Sahib'),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Muzammal_E09',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home (Campus Information)'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calculator'),
              onTap: () {
                Navigator.pushNamed(context, '/calculator');
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Grade Book'),
              onTap: () {
                Navigator.pushNamed(context, '/gradebook');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/myprofile');
              },
            ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Input'),
              onTap: () {
                Navigator.pushNamed(context, '/input');
              },
            ),
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('Display'),
              onTap: () {
                Navigator.pushNamed(context, '/display');
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_ind),
              title: Text('User Form'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/userform');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_pin_circle),
              title: Text('User Display'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/userdisplay');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BGNU, Campus Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Baba Guru Nanak University (BGNU) is a Public sector university located in District Nankana Sahib, in the Punjab region of Pakistan. It plans to facilitate between 10,000 to 15,000 students from all over the world at the university. The foundation stone of the university was laid on October 28, 2019 ahead of 550th of Guru Nanak Gurpurab by the Prime Minister of Pakistan. On July, 02, 2020 Government of Punjab has formally passed Baba Guru Nanak University Nankana Sahib Act 2020 (X of 2020). The plan behind the establishment of this university to be modeled along the lines of world renowned universities with focus on languages and Punjab Studies offering faculties in "Medicine", "Pharmacy", "Engineering", "Computer science”, “Languages", "Music" and "Social sciences". The initial cost Rupees 6 billion has already been allocated in the budget for this project to be spent in three phases on construction of Baba Guru Nanak University Nankana Sahib. The development work of Phase-I has already been started by Communication and Works Department of Government of Punjab.',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/vc_image.png'),
              ),
              SizedBox(height: 10),
              Text('Vice-Chancellor'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 Baba Guru Nanak University, Nankana Sahib. All rights reserved.',
              ),
              Text('Contact: info@bgnu.edu.pk'),
            ],
          ),
        ),
      ),
    );
  }
}



class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  CalculatorPageState createState() => CalculatorPageState(); // Made public
}

class CalculatorPageState extends State<CalculatorPage> { // Made public
  double num1 = 0;
  double num2 = 0;
  String operation = '+';
  double result = 0;

  void calculate() {
    setState(() {
      switch (operation) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            result = double.infinity;
          }
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.blue, // Change AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Result: $result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Enter first Number:'),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => num1 = double.tryParse(value) ?? 0,
            ),
            Text('Enter second Number:'),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => num2 = double.tryParse(value) ?? 0,
            ),
            Text('Choose operation'),
            DropdownButton<String>(
              value: operation,
              items:
                  <String>['+', '-', '*', '/'].map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  operation = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              // Center the button
              child: ElevatedButton(
                onPressed: calculate,
                child: Text('Calculate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradeBookPage extends StatefulWidget {
  const GradeBookPage({super.key});

  @override
  GradeBookPageState createState() => GradeBookPageState(); // Made public
}

class GradeBookPageState extends State<GradeBookPage> { // Made public
  List<Map<String, dynamic>> grades = [];
  TextEditingController subjectController = TextEditingController();
  TextEditingController marksController = TextEditingController();

  void addGrade() {
    if (subjectController.text.isEmpty || marksController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
      return;
    }

    double marks = double.tryParse(marksController.text) ?? 0;
    int roundedMarks = marks.round();

    if (roundedMarks > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Marks cannot be greater than 100')),
      );
      return;
    }

    String grade;
    if (roundedMarks >= 85) {
      grade = 'A+';
    } else if (roundedMarks >= 80) {
      grade = 'A';
    } else if (roundedMarks >= 65) {
      grade = 'B';
    } else if (roundedMarks >= 50) {
      grade = 'C';
    } else if (roundedMarks >= 40) {
      grade = 'D';
    } else {
      grade = 'F';
    }

    setState(() {
      grades.add({
        'subject': subjectController.text,
        'marks': roundedMarks,
        'grade': grade,
      });
      subjectController.clear();
      marksController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grade Book'), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.subject),
                Icon(Icons.format_list_numbered),
                Icon(Icons.grade),
              ],
            ),
            SizedBox(height: 10),
            Text("Enter Subject Name:"),
            TextField(controller: subjectController),
            Text("Enter Marks:"),
            TextField(
              controller: marksController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(onPressed: addGrade, child: Text('Result')),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Subject')),
                        DataColumn(label: Text('Marks')),
                        DataColumn(label: Text('Grade')),
                      ],
                      rows:
                          grades
                              .map(
                                (grade) => DataRow(
                                  cells: [
                                    DataCell(Text(grade['subject'])),
                                    DataCell(Text(grade['marks'].toString())),
                                    DataCell(Text(grade['grade'])),
                                  ],
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Center(
        child: Text('Muzammal_E09', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Submit')),
          ],
        ),
      ),
    );
  }
}

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  DisplayPageState createState() => DisplayPageState();
}

class DisplayPageState extends State<DisplayPage> {
  String submittedText = '';
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  submittedText = textController.text;
                });
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text('Submitted Text: $submittedText'),
          ],
        ),
      ),
    );
  }
}

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  UserFormPageState createState() => UserFormPageState();
}

class UserFormPageState extends State<UserFormPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _status = 'Active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Active',
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                Text('Active'),
                Radio<String>(
                  value: 'Deactive',
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                Text('Deactive'),
              ],
            ),
            SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (!mounted) return; // Check if widget is still mounted
            prefs.setString('email', _emailController.text);
            prefs.setString('phone', _phoneController.text);
            prefs.setString('status', _status);
            if (!mounted) return; // Check again after SharedPreferences operation
            Navigator.pushNamed(context, '/userdisplay');
          },
          child: Text('Submit'),
        ),
          ],
        ),
      ),
    );
  }
}

class UserDisplayPage extends StatefulWidget {
  const UserDisplayPage({super.key});

  @override
  UserDisplayPageState createState() => UserDisplayPageState();
}

class UserDisplayPageState extends State<UserDisplayPage> {
  String _email = '';
  String _phone = '';
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // Check if widget is still mounted
    setState(() {
      _email = prefs.getString('email') ?? 'No Email';
      _phone = prefs.getString('phone') ?? 'No Phone';
      _status = prefs.getString('status') ?? 'No Status';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Field')),
                DataColumn(label: Text('Value')),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Email')),
                    DataCell(Text(_email)),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Phone Number')),
                    DataCell(Text(_phone)),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Status')),
                    DataCell(
                      Row(
                        children: [
                          Text(_status),
                          SizedBox(width: 8),
                          if (_status == 'Active')
                            Icon(Icons.check_circle, color: Colors.green)
                          else
                            Icon(Icons.cancel, color: Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}