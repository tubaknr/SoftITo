/*
1.createState()

2.mounted == true 

3.initState()

4. didChangeDependencies() (widget değişiminde tetiklenir.(Thema.of(context) bu adımda güvenli olarak çalıştırılır.) asenkronlar bu taraftadır.

5.build(BuildContext context) (UI burada döndürür (ASLA İÇİNDE ASENKRON İŞLEM YAPILMAZ!))

6.didUpdateWidget(oldWidget) (üst ebeveyn yeni bir parametre yolladığında çalışır.)

7.deactivite() (hiyerarşi ağacından geçici olarak kopma)

8.dispose() (ağacı kalıcı olarak kapatır. (controller.dispose Stream.cancel) burada yapılır.)

9.mounted==false. ağaç komple kapatılır.


*/







