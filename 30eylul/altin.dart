class Kasa{
  final String oyuncuAdi;
  int _altin = 0;

  Kasa({
    required this.oyuncuAdi,
  }); 

  int get altin => _altin;

  set altinMiktari(int yeniAltin){
     if(yeniAltin < 0){
      print("sahte altın eklenemez");
    } else {
      _altin = yeniAltin;
    }
  }
}

void main(){
  final oyunKasasi = Kasa(oyuncuAdi: "Ali Ay");
  print("altın miktarı: ${oyunKasasi.altin}");

  oyunKasasi.altinMiktari = 50;
  print("altın miktarı: ${oyunKasasi.altin}");

  oyunKasasi.altinMiktari = -50;
  print("altın miktarı: ${oyunKasasi.altin}");

}