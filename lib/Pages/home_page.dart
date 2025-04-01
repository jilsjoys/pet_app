import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/Constant/constants.dart';
import 'package:pet_app/Models/CardItem.dart';
import 'package:pet_app/Models/Pet.dart';
import 'package:pet_app/Pages/card_detail.dart';
import 'package:pet_app/Screens/welcome_screen.dart';
import 'package:pet_app/Widgets/button_widget.dart';
import 'package:pet_app/Widgets/text_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showAddItemDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    String selectedCategory = 'Dog'; // Default category
    List<String> categories = ['Dog', 'Cat', 'Cow', 'Goat'];

    String getImageUrl(String category) {
      switch (category) {
        case 'Dog':
          return 'https://cdn.shopify.com/s/files/1/0086/0795/7054/files/Golden-Retriever.jpg?v=1645179525';
        case 'Cat':
          return 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3V0ZSUyMGNhdHxlbnwwfHwwfHx8MA%3D%3D';
        case 'Goat':
          return 'https://images.unsplash.com/photo-1593750439808-958d28558592?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z29hdHN8ZW58MHx8MHx8fDA%3D';
        case 'Cow':
          return 'https://media.istockphoto.com/id/1282514444/photo/cow-udder-large-and-full-and-with-horns-in-the-green-pasture-and-a-blue-sky.jpg?s=612x612&w=0&k=20&c=a2TuO1u4H4wKW7aSizBh7Df8CLA70MEPTcadLfc35bk=';
      }
      return 'https://cdn.shopify.com/s/files/1/0086/0795/7054/files/Golden-Retriever.jpg?v=1645179525';
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Enter Pet Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Pet Name'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Age'),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items:
                      categories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty) {
                    setState(() {
                      petDetails.add(
                        Pet(
                          id: petDetails.length + 1,
                          name: nameController.text,
                          category: selectedCategory,
                          age:
                              ageController.text.isNotEmpty
                                  ? int.tryParse(ageController.text)
                                  : null,
                          imageUrl: getImageUrl(selectedCategory),
                          pulseRate: 12,
                          heartRate: 23,
                          respRate: 24,
                        ),
                      );
                    });
                    Navigator.pop(context); // Close dialog
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  void _openDetailPage(Pet value) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardDetailScreen(value: value)),
    );
  }

  void _signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (route) => false, // Removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        title: Text('PHM'),
        actions: [
          TextButton(
            onPressed: () => _signOut(context),
            child: Text("Sign Out"),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: petDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _openDetailPage(petDetails[index]),
            child: CardItem(pet: petDetails[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
