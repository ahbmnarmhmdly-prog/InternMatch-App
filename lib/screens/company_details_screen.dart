import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'available_trainings_screen.dart'; 
import 'database_helper.dart'; 

class CompanyDetailsScreen extends StatefulWidget {
  final String companyName;
  final String companyImage;

  const CompanyDetailsScreen({
    super.key,
    required this.companyName,
    required this.companyImage,
  });

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  String _userEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email') ?? "Guest";
    });
  }

  void _saveCompany(BuildContext context) async {
    Map<String, dynamic> row = {
      'companyName': widget.companyName,
      'jobTitle': 'Internship Program',
      'applicantName': _userEmail, 
      'status': 'Saved' 
    };

    await DatabaseHelper().insertApplication(row);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved ${widget.companyName} to bookmarks!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 16, color: Color(0xFF3577FF)),
          label: const Text('Search', style: TextStyle(color: Color(0xFF3577FF), fontWeight: FontWeight.bold)),
        ),
        actions: [
          IconButton(
            onPressed: () => _saveCompany(context),
            icon: const Icon(Icons.bookmark_border, color: Color(0xFF3577FF)),
          ),
          const SizedBox(width: 10),
        ],
        title: const Text('Details', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Hero(
              tag: widget.companyName,
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 100, width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.companyImage, 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.companyName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('Innovation & Technology', style: TextStyle(color: Color(0xFF3577FF), fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSmallInfo(Icons.location_on, 'California'),
                const SizedBox(width: 25),
                _buildSmallInfo(Icons.people, '500+ Staff'),
              ],
            ),
            const SizedBox(height: 35),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('About the Company', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.companyName} is a leading software development firm specializing in cloud computing and AI-driven analytics.',
              style: TextStyle(color: Colors.grey.shade700, height: 1.6, fontSize: 14),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: _buildInfoCard('PROGRAMS', '12 Available', Icons.workspace_premium, Colors.blue)),
                const SizedBox(width: 15),
                Expanded(child: _buildInfoCard('RATING', '4.9 / 5.0', Icons.star, Colors.orange)),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingListScreen(companyName: widget.companyName),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3577FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text('View Trainings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }
}