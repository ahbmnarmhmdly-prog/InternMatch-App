import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'company_details_screen.dart';
import 'database_helper.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _userEmail = "User";

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      
      _userEmail = prefs.getString('user_email') ?? "User"; 
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      _buildAppliedContent(), 
      _buildSavedContent(),    
      _buildProfileContent(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
           
            if (index == 1 || index == 2) {
              _loadUserEmail(); 
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Applied'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  
  Widget _buildAppliedContent() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Applied Internships", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true, 
        elevation: 0, 
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
       
        future: DatabaseHelper().getStudentApplications(_userEmail), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          
          final allData = snapshot.data ?? [];
          final appliedList = allData.where((item) => item['status'] == 'Applied').toList();

          if (appliedList.isEmpty) {
            return _buildEmptyState(Icons.assignment_late_outlined, "No applications found");
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: appliedList.length,
            itemBuilder: (context, index) {
              final app = appliedList[index];
              return _buildStatusTile(
                app['companyName'] ?? 'Unknown',
                app['jobTitle'] ?? 'Training',
                app['status'] ?? 'Applied',
                Colors.blue, 
              );
            },
          );
        },
      ),
    );
  }

  
  Widget _buildSavedContent() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Saved", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true, 
        elevation: 0, 
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getStudentApplications(_userEmail), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          final allData = snapshot.data ?? [];
          final savedList = allData.where((item) => item['status'] == 'Saved').toList();

          if (savedList.isEmpty) {
            return _buildEmptyState(Icons.bookmark_border, "No saved companies yet");
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: savedList.length,
            itemBuilder: (context, index) {
              final app = savedList[index];
              return _buildStatusTile(
                app['companyName'] ?? 'Unknown',
                "Saved for later",
                "Saved",
                Colors.green, 
              );
            },
          );
        },
      ),
    );
  }

  
  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  
  
  Widget _buildStatusTile(String company, String job, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey.shade100)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(job, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(company, style: const TextStyle(color: Colors.blue, fontSize: 13)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }

  
  
  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recommended Companies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See all', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildCompanyCard(context, 'TechNova Solutions', 'Leading the way in AI and cloud solutions...', 'San Francisco, CA', 'TECH', 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=500&q=80'),
                const SizedBox(height: 20),
                _buildCompanyCard(context, 'GreenPulse Energy', 'Renewable energy firm looking for passionate...', 'Remote Available', 'ENERGY', 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=500&q=80'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
          const SizedBox(height: 15),
          Text(_userEmail, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Computer Science Student", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          _profileOption(Icons.person, "Personal Information"),
          _profileOption(Icons.file_copy, "My Resume / CV"),
          _profileOption(Icons.settings, "App Settings"),
          const Spacer(),
          _profileOption(Icons.logout, "Logout", color: Colors.red, onTap: _logout),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar(radius: 25, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('STUDENT HOME', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('Hello, ${_userEmail.split('@')[0]}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          _iconContainer(Icons.notifications_none_outlined),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('Search companies...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _iconContainer(Icons.tune, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _profileOption(IconData icon, String title, {Color color = Colors.black, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ?? () {},
    );
  }

  Widget _iconContainer(IconData icon, {Color color = Colors.black}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 22, color: color),
    );
  }

  Widget _buildCompanyCard(BuildContext context, String name, String desc, String location, String tag, String imageUrl) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)), child: Text(tag, style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 2),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyDetailsScreen(companyName: name, companyImage: imageUrl)));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                      child: const Text('View', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}