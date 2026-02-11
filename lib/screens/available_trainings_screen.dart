import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'database_helper.dart'; 

class TrainingListScreen extends StatefulWidget {
  final String companyName;
  const TrainingListScreen({super.key, required this.companyName});

  @override
  State<TrainingListScreen> createState() => _TrainingListScreenState();
}

class _TrainingListScreenState extends State<TrainingListScreen> {
  final Set<int> _appliedIndexes = {};

  void _showUploadCVSheet(int index, String jobTitle) { 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20, left: 20, right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              const Text("Apply for Training", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Please upload your CV (PDF) to complete the application", 
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: const Color(0xFF3577FF).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF3577FF), style: BorderStyle.solid),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.upload_file_rounded, size: 50, color: Color(0xFF3577FF)),
                    SizedBox(height: 10),
                    Text("Select CV File", style: TextStyle(color: Color(0xFF3577FF), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3577FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); 
                    _confirmApply(index, jobTitle); 
                  },
                  child: const Text("Submit Application", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  
  void _confirmApply(int index, String jobTitle) async {
    final prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('user_email') ?? "Guest";

    Map<String, dynamic> application = {
      'companyName': widget.companyName,
      'jobTitle': jobTitle,
      'applicantName': userEmail, 
      'status': 'Applied'         
    };

    await DatabaseHelper().insertApplication(application);

    setState(() {
      _appliedIndexes.add(index);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application for $jobTitle sent successfully!'),
          backgroundColor: const Color(0xFF3577FF),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> jobTitles = [
      'Mobile App Developer Intern',
      'UI/UX Design Intern',
      'Backend Developer Trainee'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3577FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Trainings at ${widget.companyName}', 
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: jobTitles.length,
        itemBuilder: (context, index) {
          bool isApplied = _appliedIndexes.contains(index);
          String currentTitle = jobTitles[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Duration: 3 Months', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const Text('Type: Remote Opportunity', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 90,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isApplied ? null : () => _showUploadCVSheet(index, currentTitle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApplied ? Colors.grey : const Color(0xFF3577FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(isApplied ? 'Applied' : 'Apply', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}