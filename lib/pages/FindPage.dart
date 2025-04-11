import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore for database
import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:intl/intl.dart'; // For formatting date

// Stateful widget for the "Found Something?" form
class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  final _formKey =
      GlobalKey<FormState>(); // Key for the form to validate inputs

  // Controllers to manage input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false; // Loading state to show spinner while submitting

  // Function to upload form data to Firestore
  Future<void> _uploadData() async {
    if (!_formKey.currentState!.validate()) return; // Validate form fields

    setState(() => _isLoading = true); // Show loading indicator

    // Prepare post data as a map
    Map<String, dynamic> postData = {
      "name": _nameController.text,
      "location": _locationController.text,
      "date": _dateController.text,
      "contact": _contactController.text,
      "description": _descriptionController.text,
      "timestamp": FieldValue.serverTimestamp(), // Save server time
    };

    // Add the post to "find_posts" collection in Firestore
    await FirebaseFirestore.instance.collection("find_posts").add(postData);

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post Submitted Successfully!")),
    );

    // Clear form after submission
    _formKey.currentState!.reset();
    _nameController.clear();
    _locationController.clear();
    _dateController.clear();
    _contactController.clear();
    _descriptionController.clear();

    setState(() => _isLoading = false); // Stop loading indicator
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Found Something?")), // AppBar title
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Outer padding
        child: Form(
          key: _formKey, // Assign form key
          child: SingleChildScrollView(
            // Allow scrolling if keyboard overlaps
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name input field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Your Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your name" : null,
                ),

                // Location input field
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter location" : null,
                ),

                // Date input field (opens date picker)
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Prevent manual editing
                  onTap: () async {
                    // Show calendar to pick a date
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      // Format and assign selected date
                      setState(() {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  validator: (value) => value!.isEmpty ? "Pick a date" : null,
                ),

                // Contact info input field
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: "Contact Info"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter contact info" : null,
                ),

                // Description input field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3, // Allow multiline input
                  validator: (value) =>
                      value!.isEmpty ? "Enter a description" : null,
                ),

                const SizedBox(height: 20), // Space before button

                // Show spinner while loading, else show Submit button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _uploadData, // Call upload function
                        child: const Text("Submit Post"),
                      ),

                const SizedBox(height: 20), // Space before Back button

                // Back to home button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                    child: const Text("Back to Home"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
