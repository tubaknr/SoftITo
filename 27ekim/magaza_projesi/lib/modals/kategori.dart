enum Kategori{
    hepsi('tümü', 'H'),
    elektronik('Elektornik', 'E'),
    giyim('Giyim', 'G'),
    evYasam('Ev & Yaşam', 'EY'),
    kozmetik('Kozmetik', 'K'),
    oto('Oto', 'O');

    final String baslik;
    final String ikon;

    const Kategori(this.baslik, this.ikon);
}


