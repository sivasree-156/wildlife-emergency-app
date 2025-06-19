import 'package:flutter/material.dart';
import 'package:vvxplore/user/userlogin.dart';

import '../servics/services1.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();


  var isLoader = false;
  final AuthService authService = AuthService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
        "name": _usernameController.text,
        "contact": _phoneController.text,
        "location": _locationController.text,

      };

      await authService.createUsers(data, context);

      setState(() {
        isLoader = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade700, Colors.purple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Foreground Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15.0,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create Your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.deepPurple.shade700,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        _buildTextFormField(
                          _emailController,
                          'Email',
                          Icons.email,
                          TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18.0),
                        _buildTextFormField(
                          _passwordController,
                          'Password',
                          Icons.lock,
                          TextInputType.visiblePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 18.0),
                        _buildTextFormField(
                          _usernameController,
                          'Name',
                          Icons.person,
                          TextInputType.name,
                        ),
                        const SizedBox(height: 18.0),
                        _buildTextFormField(
                          _phoneController,
                          'Contact',
                          Icons.phone,
                          TextInputType.phone,
                        ),

                        const SizedBox(height: 18.0),
                        _buildTextFormField(
                          _locationController,
                          'Location',
                          Icons.location_on,
                          TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 35.0),
                        ElevatedButton(
                          onPressed: isLoader ? null : _submitForm,
                          child: isLoader
                              ? const Center(child: CircularProgressIndicator())
                              : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.deepPurple.shade700,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 25.0,
                            ),
                            minimumSize: const Size(160, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller,
      String label,
      IconData icon,
      TextInputType keyboardType, {
        bool obscureText = false,
      }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      cursorColor: Colors.deepPurple.shade700,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontFamily: 'Poppins',
        ),
        labelText: label,
        suffixIcon: Icon(
          icon,
          color: Colors.grey.shade600,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.deepPurple.shade700),
        ),
      ),
    );
  }
}
