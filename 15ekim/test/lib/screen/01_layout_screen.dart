import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transation_model.dart';
import '02_markets_list_screen.dart';
import '03_transfer_form_screen.dart';
import '04_top_up_screen.dart';
import '05_more_screen.dart';

class LayoutStylingScreen extends StatefulWidget{
  const LayoutStylingScreen({super.key});

  @override 
  State<LayoutStylingScreen> createState() => _LayoutStylingScreenState();


}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> {
  bool _isBalanceVisible = true;
  String _lastAction = 'Hazır - Butonlara Tıklayabilirsiniz';

  @override 
  Widget build(BuildContext context){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //.Profil online rozeti;
          _buildProfileHeader(),

          // Cüzdan Kartı
          _buildWalletCard(),

          // aksiyon butonları
          _buildQuickActions(),

          // istatistik bölümü
          _buildFlexStatistics(),

          // notification bildirim banner
          _buildNotificationBanner(),

          // Canlı Durum Bildirimi
          Center( // İÇ İÇE HİYERARŞİDENN DOLAYI BU ŞEKİLDE SIRALANIYORLAR: EN DIŞTAKİ İÇİNDEKİ HEPSİN KAPSAMIŞ OLUR. 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Son İşlem: $_lastAction',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontStyle: FontStyle.italic
                ),
            ),
          ),
          )
        ],
      ),
    );
  } // Widget kapandığı yer


// -------------  BUILD PROFILE HEADER  -------------------------------------------------------------
  /*Widget _buildProfileHeader(){
    return Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: 
      Row(children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
             Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x1F6366F1),
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
              ),
             )
          ],
        )
      ],
      ),
    );
  }
  */

  // 1. Profil ve Online Rozeti Başlığı
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hoş Geldiniz,',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'Zeynep Demir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _lastAction = 'Bildirimler simgesine tıklandı';
              });
            },
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }

  // 2. Cüzdan Kartı (Bakiye Gizleme Özellikli)
  Widget _buildWalletCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Toplam Varlık / Bakiye',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                    _lastAction = _isBalanceVisible ? 'Bakiye gösterildi' : 'Bakiye gizlendi';
                  });
                },
                child: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isBalanceVisible ? '₺48.750,50' : '••••••••',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '**** **** **** 4589',
                style: TextStyle(color: Colors.white70, letterSpacing: 2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Aktif Kart',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Aksiyon Butonları
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _actionButton(Icons.arrow_upward, 'Gönder', Colors.orange, () {
            setState(() => _lastAction = 'Para Gönder sayfasına gidiliyor');
            
            // Transfer Form Ekranına Yönlendirme
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferFormScreen()),
            );
          }),
          _actionButton(Icons.arrow_downward, 'İste', Colors.green, () {
            setState(() => _lastAction = 'Piyasalar sayfasına gidiliyor');
            
            // Piyasalar / Markets Ekranına Yönlendirme
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarketsGridListScreen()),
            );
          }),
                    _actionButton(Icons.add, 'Yükle', Colors.blue, () {
            setState(() => _lastAction = 'Bakiye Yükle sayfasına gidiliyor');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TopUpScreen()),
            );
          }),
          _actionButton(Icons.more_horiz, 'Diğer', Colors.purple, () {
            setState(() => _lastAction = 'Diğer Menü açıldı');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoreScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
          ),
        ],
      ),
    );
  }

  // 4. İstatistik Bölümü (Flex Yapısı)
  Widget _buildFlexStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aylık Özet',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statItem('Gelen', '₺12.400', Colors.green, Icons.trending_up),
              ),
              Container(width: 1, height: 35, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _statItem('Giden', '₺4.150', Colors.red, Icons.trending_down),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String title, String amount, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ],
    );
  }

  // 5. Bildirim Banner Alanı
  Widget _buildNotificationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2563EB)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Kampanya: Arkadaşını davet et, 150 TL nakit kazan!',
              style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _lastAction = 'Kampanya detaylarına tıklandı';
              });
            },
            child: const Text('İncele', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

}



