import '../modals/kategori.dart';
import '../modals/urun.dart';

// INTERFACE
abstract class IUrunServisi{

    Future<List<Urun>> tumUrunleriGetir();

    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);

    Future<List<Urun>> adaGoreAra(String aramaMetni);


}
