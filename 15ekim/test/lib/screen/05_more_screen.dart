import 'package:flutter/material.dart';
import '02_markets_list_screen.dart';
import '03_transfer_form_screen.dart';
import '04_top_up_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(Icons.arrow_upward, 'Para Gönder', Colors.orange,
          const TransferFormScreen()),
      _MenuItem(Icons.show_chart, 'Piyasalar ve İşlemler', Colors.green,
          const MarketsGridListScreen()),
      _MenuItem(Icons.add, 'Bakiye Yükle', Colors.blue, const TopUpScreen()),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Diğer İşlemler',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          // Son eleman: sayfa olmayan ayarlar öğesi
          if (index == items.length) {
            return _tile(
              icon: Icons.settings,
              color: Colors.purple,
              title: 'Ayarlar',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ayarlar yakında eklenecek')),
              ),
            );
          }
          final item = items[index];
          return _tile(
            icon: item.icon,
            color: item.color,
            title: item.title,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item.page),
            ),
          );
        },
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final Color color;
  final Widget page;
  _MenuItem(this.icon, this.title, this.color, this.page);
}