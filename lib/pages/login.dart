import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package
import 'package:flutter/material.dart'; // Flutter material design components
import 'package:flutter_app_one/pages/Register.dart'; // Register screen
import 'home.dart'; // Home screen after successful login

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false; // To toggle password visibility
  final _auth = FirebaseAuth.instance; // Firebase Auth instance
  final _formKey = GlobalKey<FormState>(); // Form key to validate form fields
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email input
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for password input
  String? _errorMessage; // Stores error message on failed login

  // Function to perform login using Firebase Auth
  Future<void> _login() async {
    if (!_formKey.currentState!.validate())
      return; // Validate form before proceeding
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(), // Get email from controller
        password:
            _passwordController.text.trim(), // Get password from controller
      );
      // Navigate to home screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      // Catch and show Firebase login errors
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        0,
        0,
        0,
      ), // Set dark background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 50.0,
        ), // Add padding around content
        child: Form(
          key: _formKey, // Assign form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset("images/Banner.jpg", height: 200.0),
              ), // App banner/logo
              const SizedBox(height: 30.0),
              _buildHeader(), // Welcome & login text
              const SizedBox(height: 40.0),
              _buildTextField(
                "Email",
                _emailController,
                Icons.email,
                false,
              ), // Email input field
              const SizedBox(height: 30.0),
              _buildTextField(
                "Password",
                _passwordController,
                Icons.lock,
                true,
              ), // Password input field
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // You can add forgot password logic here
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ), // Show error message
                ),
              _buildLoginButton(), // Login button
              const SizedBox(height: 20.0),
              _buildSignUpOption(), // Link to go to Register screen
            ],
          ),
        ),
      ),
    );
  }

  // Header widget with welcome text
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Welcome To DaffoFind",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 34.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Text field widget for email and password
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isPassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: controller, // Assign controller
          obscureText:
              isPassword
                  ? !_isPasswordVisible
                  : false, // Toggle password visibility
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white10, // Slight background fill
            hintText: "Enter your $label",
            hintStyle: const TextStyle(color: Colors.white54),
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
                      onPressed:
                          () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ), // Toggle icon and text visibility
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              borderSide: const BorderSide(color: Colors.white24),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty'; // Simple validation
            }
            return null;
          },
        ),
      ],
    );
  }

  // Login button widget
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity, // Button width fills parent
      height: 50,
      child: ElevatedButton(
        onPressed: _login, // Call login function on press
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ), // Rounded button
        ),
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Sign up link widget
  Widget _buildSignUpOption() {
    return Center(
      child: GestureDetector(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Register()),
            ), // Navigate to register page
        child: const Text(
          "Don't have an account? Sign Up",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
