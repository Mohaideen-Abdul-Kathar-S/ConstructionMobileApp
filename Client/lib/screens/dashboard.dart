import 'package:flutter/material.dart';
import '../widgets/rounded_card.dart';
import '../routes.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onNavTap(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primary,
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => setState(() => _selectedIndex = 2),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 36, backgroundColor: scheme.primaryContainer, child: const Icon(Icons.person, size: 36)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('UserName', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Employee ID: 1001', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 3.6,
                    mainAxisSpacing: 12,
                    children: [
                      RoundedCard(
                        onTap: () => setState(() => _selectedIndex = 1),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 36),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Attendance Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                SizedBox(height: 4),
                                Text('View attendance records and export'),
                              ],
                            )
                          ],
                        ),
                      ),
                      RoundedCard(
                        onTap: () => Navigator.pushNamed(context, Routes.salary),
                        child: Row(
                          children: [
                            const Icon(Icons.payments, size: 36),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Salary Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                SizedBox(height: 4),
                                Text('View salary breakdowns and export'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Reports tab
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              RoundedCard(
                onTap: () => Navigator.pushNamed(context, Routes.attendance),
                child: Row(children: const [Icon(Icons.calendar_today), SizedBox(width: 12), Text('Attendance Report')]),
              ),
              const SizedBox(height: 12),
              RoundedCard(
                onTap: () => Navigator.pushNamed(context, Routes.salary),
                child: Row(children: const [Icon(Icons.payments), SizedBox(width: 12), Text('Salary Report')]),
              ),
            ]),
          ),
          // Profile tab
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
