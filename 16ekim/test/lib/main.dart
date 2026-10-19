import 'package:flutter/material.dart';

import 'pages/assets_page.dart';
import 'pages/overview_page.dart';
import 'pages/transactions_page.dart';
import 'state/wallet_store.dart';
import 'widgets/action_sheets.dart';

void main() => runApp(const KumbaraApp());

class KumbaraApp extends StatelessWidget {
  const KumbaraApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kumbara',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          scaffoldBackgroundColor: const Color(0xFFF3F6F5),
        ),
        home: const AppShell(),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final WalletStore _store = WalletStore();
  int _currentIndex = 0;

  static const _titles = ['Kumbara', 'Varlıklarım', 'İşlemler'];

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  void _openNotifications() {
    _store.markAllRead();
    showNotificationsSheet(context, _store);
  }

  @override
  Widget build(BuildContext context) {
    // Store değişince (bakiye, bildirim sayısı vb.) tüm iskelet yeniden çizilir.
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          title: Text(
            _titles[_currentIndex],
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Badge(
                isLabelVisible: _store.unreadCount > 0,
                label: Text('${_store.unreadCount}'),
                child: IconButton(
                  tooltip: 'Bildirimler',
                  onPressed: _openNotifications,
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: [
              OverviewPage(
                store: _store,
                onSeeAll: () => setState(() => _currentIndex = 2),
              ),
              AssetsPage(store: _store),
              TransactionsPage(store: _store),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'Özet',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Varlıklar',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'İşlemler',
            ),
          ],
        ),
      ),
    );
  }
}
