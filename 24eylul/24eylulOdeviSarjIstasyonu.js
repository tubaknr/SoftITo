// şarj süresi tahmin motoru DK cinsinden
const sarjSuresi = (mevcutYuzde, hedefYuzde, bataryaKW, istasyonKW) => {
    const farkYuzde = hedefYuzde - mevcutYuzde;
    const farkOndalik = farkYuzde/100;
    const gerekliEnerji = farkOndalik*100;
    let sureSaat = 0;
    if (istasyonKW > bataryaKW){
        sureSaat = gerekliEnerji/bataryaKW;
    } else{
        sureSaat = gerekliEnerji/istasyonKW;
    }
    const sureDk = sureSaat*60;
    return sureDk;
}

// gee gündüz tarifesi ekle fiyatlandırma ekle
// bilgisayarın saatini okuyacak sistem. 
// fiyat ekle
// gece gündüz fiyat ekle fiyat dönsün 
