import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package
import 'package:flutter/material.dart'; // Flutter UI toolkit
import 'home.dart'; // Home screen (after successful registration)
import 'login.dart'; // Login screen (for already registered users)

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>(); // Key to validate the form

  // Controllers to retrieve user input from text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // To toggle visibility of password fields
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Function to register a new user using Firebase
  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Validate form fields first
      try {
        // Create user with Firebase using email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Successful"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle Firebase registration errors
        String message = "An error occurred.";
        if (e.code == 'weak-password') {
          message = "Password is too weak.";
        } else if (e.code == 'email-already-in-use') {
          message = "Account already exists.";
        }

        // Show error message in a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 50,
        ), // Padding around content
        child: Form(
          key: _formKey, // Assign form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset("images/Banner.jpg", height: 200),
              ), // App banner
              const SizedBox(height: 30),
              // Title text
              Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Input fields
              _buildTextField("Name", Icons.person, nameController, false),
              _buildTextField("Email", Icons.email, emailController, false),
              _buildTextField("Password", Icons.lock, passwordController, true),
              _buildTextField(
                "Confirm Password",
                Icons.lock,
                confirmPasswordController,
                true,
              ),
              const SizedBox(height: 30),
              // Sign Up button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: registerUser, // Call registration function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Already have account? Login link
              Center(
                child: GestureDetector(
                  onTap:
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      ), // Navigate to login
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable function to create a labeled text field
  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above input field
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 20)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller, // Assign controller
          obscureText:
              isPassword
                  ? !_isPasswordVisible
                  : false, // Obscure password if needed
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white10, // Light background
            hintText: "Enter your $label", // Placeholder text
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(icon, color: Colors.white), // Icon on the left
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Toggle visibility
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (value) {
            // Validation logic
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            if (label == "Email" &&
                !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
              return 'Enter a valid email';
            }
            if (label == "Confirm Password" &&
                value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
