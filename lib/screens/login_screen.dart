import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart'; 
import 'home_screen.dart';
import 'database_helper.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isObscured = true;
  bool _isLoading = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.school, size: 45, color: Color(0xFF3577FF)),
                ),
              ),
              const SizedBox(height: 30),
              const Text('Welcome Back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Sign in to explore internships and\ntraining opportunities', 
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
              
              const SizedBox(height: 40),

              _buildTextFormField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'name@example.com',
                icon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!value.contains('@')) return 'Enter a valid email address';
                  return null;
                },
              ),
              
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot?', style: TextStyle(color: Color(0xFF3577FF), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your password';
                      return null;
                    },
                    decoration: _inputDecoration(
                      'Enter your password', 
                      Icons.lock_outline, 
                      suffixWidget: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);

                      final user = await DatabaseHelper().loginUser(
                        _emailController.text, 
                        _passwordController.text
                      );

                      if (user != null) {
                       
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('user_email', _emailController.text);
                        await prefs.setBool('isLoggedIn', true);

                        await Future.delayed(const Duration(milliseconds: 500)); 

                        if (mounted) {
                          setState(() => _isLoading = false);
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const HomeScreen())
                          );
                        }
                      } else {
                        
                        setState(() => _isLoading = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid email or password'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3577FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text('Login  →', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 30),
              const Text('OR CONTINUE WITH', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _socialButton(Icons.apple, Colors.black)),
                  const SizedBox(width: 15),
                  Expanded(child: _socialButton(Icons.g_mobiledata_rounded, Colors.red)),
                ],
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: const Text("Create new account", style: TextStyle(color: Color(0xFF3577FF), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

 
  InputDecoration _inputDecoration(String hint, IconData icon, {Widget? suffixWidget}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      suffixIcon: suffixWidget, 
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3577FF))),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }

  Widget _buildTextFormField({required TextEditingController controller, required String label, required String hint, required IconData icon, required String? Function(String?) validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, 
          validator: validator, 
          decoration: _inputDecoration(hint, icon)
        ),
      ],
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      height: 55,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 35, color: color),
    );
  }
}