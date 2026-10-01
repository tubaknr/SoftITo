
class CanSistemi{
  final String karakterAdi;
  double _canPuani = 100.0;

  CanSistemi({
    required this.karakterAdi,
  });

  double get canPuani => _canPuani;

  set canPuani(double yeniCan){
    if (yeniCan <= 0.0){
      _canPuani = 10;
    } 
  }
}


abstract class Canavar{
  final String isim;

  Canavar({
    required this.isim,
  });

  void kukre();
}

class EjderhaCanavari extends Canavar{
  EjderhaCanavari({
    required super.isim
  });

  @override 
  void kukre(){
    print("Grrrrr");
  }
}

class KurtCanavari extends Canavar{
  KurtCanavari({
    required super.isim
  });

  @override
  void kukre(){
    print("Uuuuu");
  }
}


void main(){
  final dissiz = EjderhaCanavari(isim: "Dişsiz");
  dissiz.kukre();

  final bozkurt = KurtCanavari(isim: "Bozkurt");
  bozkurt.kukre();
}


