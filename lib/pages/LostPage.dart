import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore for storing data
import 'package:flutter/material.dart'; // Flutter UI toolkit
import 'package:intl/intl.dart'; // For formatting date

// The screen for reporting lost items
class LostPage extends StatefulWidget {
  const LostPage({super.key});

  @override
  State<LostPage> createState() => _LostPageState();
}

class _LostPageState extends State<LostPage> {
  final _formKey =
      GlobalKey<FormState>(); // Key to manage and validate the form

  // Controllers for the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading =
      false; // Boolean to track loading state during post submission

  // Function to submit the lost item data to Firestore
  Future<void> _uploadLostPost() async {
    if (!_formKey.currentState!.validate())
      return; // Validate form before submitting

    setState(() => _isLoading = true); // Show loading indicator

    // Collect form data into a map
    Map<String, dynamic> postData = {
      "name": _nameController.text,
      "location": _locationController.text,
      "date": _dateController.text,
      "contact": _contactController.text,
      "description": _descriptionController.text,
      "timestamp": FieldValue.serverTimestamp(), // Add server-side timestamp
    };

    // Add post to the 'lost_posts' Firestore collection
    await FirebaseFirestore.instance.collection("lost_posts").add(postData);

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lost Item Reported Successfully!")),
    );

    // Reset the form and clear input fields
    _formKey.currentState!.reset();
    _nameController.clear();
    _locationController.clear();
    _dateController.clear();
    _contactController.clear();
    _descriptionController.clear();

    setState(() => _isLoading = false); // Hide loading indicator
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost Something?"), // Title in AppBar
        backgroundColor: Colors.redAccent, // AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to the whole form
        child: Form(
          key: _formKey, // Attach the form key
          child: SingleChildScrollView(
            // Allow scrolling if keyboard appears
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input for Name
                _buildTextField(
                  controller: _nameController,
                  label: "Your Name",
                  icon: Icons.person,
                ),
                // Input for Location
                _buildTextField(
                  controller: _locationController,
                  label: "Location",
                  icon: Icons.location_on,
                ),
                // Input for Date (with calendar)
                _buildDateField(),
                // Input for Contact
                _buildTextField(
                  controller: _contactController,
                  label: "Contact Info",
                  icon: Icons.phone,
                ),
                // Input for Description (multiline)
                _buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Show loading indicator or Submit Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                      onPressed: _uploadLostPost, // Call submit function
                      icon: const Icon(Icons.report_problem),
                      label: const Text("Report Lost Item"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                const SizedBox(height: 20),

                // Back to home button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("Back to Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Text Field Widget with validation and styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
      ),
    );
  }

  // Custom Date Picker Field
  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: "Date",
          suffixIcon: Icon(Icons.calendar_today, color: Colors.redAccent),
          border: OutlineInputBorder(),
        ),
        readOnly: true, // Make field non-editable
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            // Format the picked date and display it
            setState(() {
              _dateController.text = DateFormat(
                'yyyy-MM-dd',
              ).format(pickedDate);
            });
          }
        },
        validator: (value) => value!.isEmpty ? "Pick a date" : null,
      ),
    );
  }
}
