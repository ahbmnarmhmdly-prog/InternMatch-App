import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import 'company_home_screen.dart'; 
import 'database_helper.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isStudent = true; 
  bool _isObscured = true; 

  
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> userData = {
          'email': _emailController.text.trim(),
          'password': _passwordController.text, 
          'role': isStudent ? 'student' : 'company',
        };

        
        await DatabaseHelper().insertUser(userData);

       
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Created Successfully!'), backgroundColor: Colors.green),
        );

        
        Widget destinationScreen = isStudent 
            ? const HomeScreen() 
            : const CompanyHomeScreen();

        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => destinationScreen),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

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
        title: const Text('Register', style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Join our community to explore internships.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: _buildRoleCard(
                      title: 'Student',
                      icon: Icons.school_outlined,
                      isSelected: isStudent,
                      onTap: () => setState(() => isStudent = true),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildRoleCard(
                      title: 'Company',
                      icon: Icons.business_outlined,
                      isSelected: !isStudent,
                      onTap: () => setState(() => isStudent = false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildInputField(
                label: 'EMAIL ADDRESS',
                hint: 'email@example.com',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
                  if (!value.contains('@')) return 'بريد إلكتروني غير صالح';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildInputField(
                label: 'PASSWORD',
                hint: 'Minimum 8 characters',
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة المرور';
                  if (value.length < 8) return 'يجب أن تكون 8 خانات على الأقل';
                  return null;
                },
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleRegister, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3577FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(text: 'Log In', style: TextStyle(color: Color(0xFF3577FF), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F5FF) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? const Color(0xFF3577FF) : Colors.grey.shade200, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF3577FF) : Colors.grey, size: 35),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(color: isSelected ? const Color(0xFF3577FF) : Colors.grey, fontWeight: FontWeight.bold)),
            if (isSelected) const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.check_circle, size: 18, color: Color(0xFF3577FF)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label, 
    required String hint, 
    bool isPassword = false, 
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: isPassword ? _isObscured : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(_isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 20),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                ) 
              : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}