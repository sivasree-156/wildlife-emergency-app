import 'package:flutter/material.dart';
import 'package:vvxplore/user/userreg.dart';
import '../main.dart';
import '../servics/services1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService authService = AuthService(); // Initialize AuthService

  Future<void> _submitForm() async {
    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    await authService.userlogin(data, context);
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
    );
    return false; // Prevent default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade800],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Card(
                elevation: 15.0, // Increased elevation for a more pronounced shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0), // More rounded corners
                ),
                child: Padding(
                  padding: EdgeInsets.all(40.0), // Increased padding for better spacing
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 80.0,
                        color: Colors.deepPurple.shade700,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28.0, // Larger font size for the title
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Please login to your account',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.deepPurple.shade500,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildTextFormField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20.0), // Increased space between fields
                      _buildTextFormField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      SizedBox(height: 30.0), // Increased space before button
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple.shade700,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // More rounded button
                          ),
                          elevation: 6.0, // Added elevation for the button
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0, letterSpacing: 1.2),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.deepPurple.shade500,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpView()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.deepPurple.shade700,
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
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
      ),
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0), // More rounded corners for the input fields
        ),
        filled: true,
        fillColor: Colors.grey.shade200.withOpacity(0.8), // Subtle grey background color for the input fields
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Padding inside text fields
      ),
    );
  }
}
