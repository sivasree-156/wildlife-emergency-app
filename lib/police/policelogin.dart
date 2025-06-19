import 'package:flutter/material.dart';
import 'package:vvxplore/police/policereg.dart';
import '../main.dart';
import '../servics/services3.dart';

class PoliceLoginPage extends StatefulWidget {
  const PoliceLoginPage({super.key});

  @override
  State<PoliceLoginPage> createState() => _LoginPageStatee();
}

class _LoginPageStatee extends State<PoliceLoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final HosAuthService authService = HosAuthService();

  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    _animationController.forward();
    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    await authService.userlogin(data, context);
    _animationController.reverse();
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade100, Colors.deepPurple.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 20.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                shadowColor: Colors.deepPurpleAccent.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_police,
                        size: 90.0,
                        color: Colors.purpleAccent,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.deepPurple.shade900,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        'Access your account',
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
                      // Temporary removal of the animation for visibility check
                      Visibility(
                        visible: true, // Ensure button is visible
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 50.0),
                            backgroundColor: Colors.deepPurple.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 8.0,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.deepPurple.shade400,
                          fontSize: 16.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpViewwhos()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.deepPurple.shade900,
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
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
      style: const TextStyle(fontSize: 16.0),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.deepPurple.shade500,
        ),
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade600),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple.shade600, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade100.withOpacity(0.9),
      ),
    );
  }
}
