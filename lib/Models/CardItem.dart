import 'package:flutter/material.dart';
import 'package:pet_app/Models/Pet.dart';
import 'package:intl/intl.dart';

class CardItem extends StatelessWidget {
  final Pet pet;

  const CardItem({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    String displayMessage = '';
    if (pet.vaccinateDate != null) {
      DateTime vaccinateDateTime = DateFormat(
        'dd-MM-yyyy',
      ).parse(pet.vaccinateDate.toString());

      // Get today's date
      DateTime today = DateTime.now();

      // Calculate the difference in days
      int differenceInDays = today.difference(vaccinateDateTime).inDays;

      // Generate the message to display

      if (differenceInDays > 0) {
        displayMessage = '$differenceInDays days ago';
      } else if (differenceInDays < 0) {
        displayMessage = '${-differenceInDays} days more';
      } else {
        displayMessage = 'Today';
      }
    }
    return Container(
      height: 220,
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        elevation: 5, // Shadow effect
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  // Pet Name (Bold, Larger font)
                  if (pet.vaccinateDate != null && pet.vaccinationName != null)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Vacc Nme: ${pet.vaccinationName}',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            displayMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    pet.name,
                    style: TextStyle(
                      fontSize: 22, // Larger font size
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Container(),
                  ), // Space between name and the next text
                  // Pet Category and Age (Smaller font)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category: ${pet.category}',
                              style: TextStyle(
                                fontSize: 16, // Smaller font size
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ), // Space between category and age
                            Text(
                              'Age: ${pet.age}',
                              style: TextStyle(
                                fontSize: 16, // Smaller font size
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Positioned Heart Rate and Pulse Rate
              Positioned(
                top:
                    70, // Adjust this value based on where you want to place it
                right: 10, // Position at the right edge
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Heart rate
                    Text(
                      'Heart Rate: ${pet.heartRate} bpm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.red, // Use a color to indicate importance
                      ),
                    ),
                    SizedBox(height: 8),
                    // Pulse rate
                    Text(
                      'Pulse Rate: ${pet.pulseRate} bpm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue, // Use blue for pulse rate
                      ),
                    ),
                    SizedBox(height: 8),
                    // Pulse rate
                    Text(
                      'Respiration Rate: ${pet.respRate} bpm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue, // Use blue for pulse rate
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: ClipOval(
                  child: Image.network(
                    '${pet.imageUrl}', // assuming your Pet model has a property imageUrl
                    width: 50, // Image size
                    height: 50, // Image size
                    fit: BoxFit.cover, // Make sure the image fits in the circle
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
