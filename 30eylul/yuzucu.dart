
mixin yuzmeYetisi{
  void dalisYap(){
    print("Suya daldı.");
  }
}

class Denizci with yuzmeYetisi{
  Denizci();
}

void main(){
  final yuzucu = Denizci();
  yuzucu.dalisYap();
}


