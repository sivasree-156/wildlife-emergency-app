import 'package:flutter/material.dart';

class WildlifeGuidelinesScreen extends StatelessWidget {
  const WildlifeGuidelinesScreen({super.key});

  final List<Map<String, dynamic>> dos = const [
    {
      'icon': Icons.visibility,
      'text': 'Observe animals from a distance',
      'color': Colors.green
    },
    {
      'icon': Icons.recycling,
      'text': 'Dispose of waste properly',
      'color': Colors.green
    },
    {
      'icon': Icons.directions_walk,
      'text': 'Stay on marked trails',
      'color': Colors.green
    },
    {
      'icon': Icons.volume_off,
      'text': 'Keep noise levels low',
      'color': Colors.green
    },
    {
      'icon': Icons.camera_alt,
      'text': 'Use zoom lens for photography',
      'color': Colors.green
    },
    {
      'icon': Icons.info,
      'text': 'Read and follow local guidelines',
      'color': Colors.green
    },
    {
      'icon': Icons.wb_sunny,
      'text': 'Wear appropriate clothing for the terrain',
      'color': Colors.green
    },
    {
      'icon': Icons.flash_on,
      'text': 'Carry a flashlight during evening treks',
      'color': Colors.green
    },
    {
      'icon': Icons.health_and_safety,
      'text': 'Carry a basic first-aid kit',
      'color': Colors.green
    },
    {
      'icon': Icons.group,
      'text': 'Travel in groups when exploring',
      'color': Colors.green
    },
  ];

  final List<Map<String, dynamic>> donts = const [
    {
      'icon': Icons.no_food,
      'text': 'Don’t feed wild animals',
      'color': Colors.red
    },
    {
      'icon': Icons.delete,
      'text': 'Don’t litter in natural areas',
      'color': Colors.red
    },
    {
      'icon': Icons.surround_sound,
      'text': 'Don’t use loudspeakers or honk',
      'color': Colors.red
    },
    {
      'icon': Icons.photo_camera_front,
      'text': 'Don’t take selfies close to animals',
      'color': Colors.red
    },
    {
      'icon': Icons.account_balance_wallet_sharp,
      'text': 'Don’t damage or remove natural objects',
      'color': Colors.red
    },
    {
      'icon': Icons.cabin,
      'text': 'Don’t camp in unauthorized zones',
      'color': Colors.red
    },
    {
      'icon': Icons.local_fire_department,
      'text': 'Don’t light campfires without permission',
      'color': Colors.red
    },
    {
      'icon': Icons.light_mode,
      'text': 'Don’t use flash while photographing animals',
      'color': Colors.red
    },
    {
      'icon': Icons.pets,
      'text': 'Don’t bring pets into wildlife zones',
      'color': Colors.red
    },
    {
      'icon': Icons.smoke_free,
      'text': 'Don’t smoke in forested areas',
      'color': Colors.red
    },
  ];

  Widget buildCard(Map<String, dynamic> item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: Icon(item['icon'], color: item['color'], size: 30),
        title: Text(
          item['text'],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        tileColor: item['color'].withOpacity(0.05),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(" Do's & Don'ts"),
          backgroundColor: Colors.teal,
          bottom: const TabBar(
            tabs: [
              Tab(text: "✅ Do's"),
              Tab(text: "❌ Don'ts"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(children: dos.map(buildCard).toList()),
            ListView(children: donts.map(buildCard).toList()),
          ],
        ),
      ),
    );
  }
}
