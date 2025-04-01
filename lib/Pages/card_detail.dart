import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pet_app/Constant/constants.dart';
import 'package:pet_app/Models/CardItem.dart';
import 'package:pet_app/Models/Pet.dart';
import 'package:pet_app/Pages/home_page.dart';
import 'package:intl/intl.dart';

class CardDetailScreen extends StatefulWidget {
  final Pet value;
  const CardDetailScreen({super.key, required this.value});

  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> generateRandomValues() {
    final random = Random();
    return {
      'Heart Rate': random.nextInt(20) + 60, // Heart rate between 60-80 bpm
      'Pulse Rate': random.nextInt(10) + 70, // Pulse rate between 70-80 bpm
      'Respiration Rate':
          random.nextInt(5) + 14, // Respiration rate between 14-18 breaths/min
      'Date': DateTime.now(),
    };
  }

  // Function to generate random data for 3 days
  List<Map<String, dynamic>> generateMetricsForThreeDays() {
    List<Map<String, dynamic>> data = [];
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < 3; i++) {
      Map<String, dynamic> metrics = generateRandomValues();
      metrics['Date'] = currentDate.subtract(
        Duration(days: i),
      ); // Subtract days for 3 consecutive days
      data.add(metrics);
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // Close the current screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), // Push main screen again
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.value.name} - Details')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display pet details (name, category, etc.)
              CardItem(pet: widget.value),

              // Display the four action buttons in a Grid layout
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: [
                    _buildActionButton(
                      context,
                      'ProfilePage',
                      Icons.account_circle,
                    ),
                    _buildActionButton(
                      context,
                      'VaccinationDetail',
                      Icons.medical_services,
                    ),
                    _buildActionButton(context, 'Settings', Icons.settings),
                    _buildActionButton(
                      context,
                      'HealthReport',
                      Icons.health_and_safety,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHealthReport(BuildContext context, Pet pet) {
    final metrics = generateRandomValues();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Map<String, dynamic>> metricsData = generateMetricsForThreeDays();
        return AlertDialog(
          title: Text('Health Report '),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Heart Rate (bpm)')),
                      DataColumn(label: Text('Pulse Rate (bpm)')),
                      DataColumn(label: Text('Respiration Rate (breaths/min)')),
                    ],
                    rows:
                        metricsData.map<DataRow>((data) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(data['Date'].toString())),
                              DataCell(Text(data['Heart Rate'].toString())),
                              DataCell(Text(data['Pulse Rate'].toString())),
                              DataCell(
                                Text(data['Respiration Rate'].toString()),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Pet pet) {
    final _vaccinationNameController = TextEditingController(
      text: pet.vaccinationName,
    );
    final _vaccinationDateController = TextEditingController(
      text: pet.vaccinateDate,
    );

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        // Format the date and update the controller text
        final String formattedDate = DateFormat(
          'dd-MM-yyyy',
        ).format(pickedDate);
        _vaccinationDateController.text = formattedDate;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Vaccination Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _vaccinationNameController,
                decoration: InputDecoration(labelText: 'Vaccination Name'),
              ),
              TextField(
                controller: _vaccinationDateController,
                decoration: InputDecoration(labelText: 'Vaccination Date'),
                keyboardType: TextInputType.datetime,
                onTap: () {
                  FocusScope.of(
                    context,
                  ).requestFocus(FocusNode()); // Dismiss keyboard
                  _selectDate(context); // Open the date picker
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Accessing the correct pet based on pet.id and updating vaccination name
                petDetails[pet.id! - 1].vaccinationName =
                    _vaccinationNameController.text;
                petDetails[pet.id! - 1].vaccinateDate =
                    _vaccinationDateController.text;
                // Dismiss the dialog without making changes
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the changes
                setState(() {
                  pet.vaccinationName = _vaccinationNameController.text;
                  pet.vaccinateDate = _vaccinationDateController.text;
                });
                // Optionally, update the petDetails list or persist it
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Vaccination details updated for ${pet.name}',
                    ),
                  ),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon) {
    if (label == ("ProfilePage")) {
      return GestureDetector(
        onTap: () {
          // You can navigate to another screen or show a message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$label button clicked')));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (label == ("HealthReport")) {
      return GestureDetector(
        onTap: () {
          // You can navigate to another screen or show a message
          _showHealthReport(context, widget.value);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (label == ("VaccinationDetail")) {
      return GestureDetector(
        onTap: () {
          _showEditDialog(context, widget.value);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (label == ("Settings")) {
      return GestureDetector(
        onTap: () {
          // You can navigate to another screen or show a message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$label button clicked')));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        // You can navigate to another screen or show a message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label Error')));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
