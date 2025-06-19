import 'package:flutter/material.dart';

import '../servics/services2.dart';
import 'amblogin.dart';


class SignUpVieww extends StatefulWidget {
  const SignUpVieww({Key? key}) : super(key: key);

  @override
  State<SignUpVieww> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpVieww> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _hospitalnameController = TextEditingController();


  var isLoader = false;
  final HAuthService psyAuthService = HAuthService();

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
        "AmbulanceType": _hospitalnameController.text,
        "location": _locationController.text,
        "latitude": _latitudeController.text,
        "longitude": _longitudeController.text,

      };

      // Perform registration and handle navigation

      await psyAuthService.createUsers(data, context); // Correct service usage

      setState(() {
        isLoader = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HLoginPage()),
        );
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pinkAccent.shade400,
                      Colors.deepPurple.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20.0,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
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
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 1.5,
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
                          _hospitalnameController,
                          'Ambulance Type',
                          Icons.type_specimen_sharp,
                          TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 18.0),
                        _buildTextFormField(
                          _latitudeController,
                          'Latitude',
                          Icons.location_on,
                          TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 18.0),
                        _buildTextFormField(
                          _longitudeController,
                          'Longitude',
                          Icons.location_on,
                          TextInputType.streetAddress,
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
                                  builder: (context) => const HLoginPage()),
                            );
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.white,
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
                                color: Colors.white,
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
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      cursorColor: Colors.white,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.2),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontFamily: 'Poppins',
        ),
        labelText: label,
        suffixIcon: Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
