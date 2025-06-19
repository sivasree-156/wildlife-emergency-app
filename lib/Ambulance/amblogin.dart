
import 'package:flutter/material.dart';
import '../main.dart';
import '../servics/services2.dart';
import 'ambreg.dart';


class HLoginPage extends StatefulWidget {
  const HLoginPage({super.key});

  @override
  State<HLoginPage> createState() => _LoginPageStatee();
}

class _LoginPageStatee extends State<HLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final HAuthService authService = HAuthService(); // Initialize AuthService

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
              colors: [Colors.blueAccent.shade100, Colors.purpleAccent.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 12.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.drive_eta_sharp,
                        size: 80.0,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Please login to your account',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.deepPurple.shade400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      _buildTextFormField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20.0),
                      _buildTextFormField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 6.0,
                          shadowColor: Colors.deepPurpleAccent,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.deepPurple.shade400,
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpVieww()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.deepPurple.shade700,
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
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
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade100.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
}
