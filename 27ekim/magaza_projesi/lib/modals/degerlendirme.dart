class Degerlendirme{
  final double puan;
  final int oySayisi;

  const Degerlendirme({required this.puan, required this.oySayisi});

  factory Degerlendirme.fromJson(Map<String, dynamic> json) {
    return Degerlendirme(
      puan:( json['puan'] as num?)?.toDouble() ?? 0.0,
      oySayisi: (json['oySayisi'] as num?)?.toInt() ?? 0,
    );
  }
}