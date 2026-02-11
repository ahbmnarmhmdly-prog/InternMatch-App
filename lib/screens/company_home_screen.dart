import 'package:flutter/material.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  int _currentIndex = 0;


  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildDashboardContent(), 
      _buildPostJobContent(),    
      _buildMessagesContent(),  
      _buildSettingsContent(),   
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF3577FF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: 'Post Job'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  
  Widget _buildDashboardContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('COMPANY PANEL', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('TechNova Solutions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business_rounded, color: Color(0xFF3577FF)),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                _buildStatCard('Active Ads', '12', Icons.campaign_rounded, Colors.orange),
                const SizedBox(width: 15),
                _buildStatCard('Applicants', '48', Icons.people_alt_rounded, Colors.blue),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Recent Applicants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildApplicantTile('Ahmed Salem', 'UI/UX Designer', '2h ago'),
            _buildApplicantTile('Sara Ali', 'Flutter Developer', '5h ago'),
            _buildApplicantTile('John Doe', 'Backend Engineer', 'Yesterday'),
          ],
        ),
      ),
    );
  }

 
  Widget _buildPostJobContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Post New Internship', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('Find the best talent for your team', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            _buildInputField('Job Title', 'e.g. Flutter Developer', Icons.title),
            _buildInputField('Location', 'e.g. Riyadh or Remote', Icons.location_on_outlined),
            _buildInputField('Duration', 'e.g. 3 Months', Icons.timer_outlined),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe the role...',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Posted!'))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3577FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Publish Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildMessagesContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Messages', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildChatTile('Ahmed Salem', 'When can I start?', '10:30 AM', true),
                _buildChatTile('Sara Ali', 'Sent the portfolio.', 'Yesterday', false),
                _buildChatTile('Fahad Khan', 'Thank you!', 'Feb 1', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. محتوى الإعدادات (Settings) ---
  Widget _buildSettingsContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 45, backgroundColor: Color(0xFF3577FF), child: Icon(Icons.business, color: Colors.white, size: 40)),
            const SizedBox(height: 15),
            const Text('TechNova Solutions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Riyadh, Saudi Arabia', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _buildSettingsItem(Icons.edit, 'Edit Profile'),
            _buildSettingsItem(Icons.notifications_none, 'Notifications'),
            _buildSettingsItem(Icons.security, 'Privacy'),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF3577FF)),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChatTile(String name, String msg, String time, bool unread) {
    return ListTile(
      leading: CircleAvatar(child: Text(name[0])),
      title: Text(name, style: TextStyle(fontWeight: unread ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(msg),
      trailing: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }

  Widget _buildApplicantTile(String name, String role, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(child: Text(name[0])),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(role),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}