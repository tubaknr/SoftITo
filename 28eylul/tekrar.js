const urunCek = async() => {
    try{
        const resp = await fetch("https");
        if (!resp.ok){
            throw new Error(resp.status);
        }
        const tum = await resp.json();
        const istenen = tum.products.slice(2,7).map(p => ({
            urun: p.title,
            fiyat: p.price,
            aciklama: p.description,
            etiket: p.tags.join(","),
            kategori: p.category,
            stok: p.stock
        }));
    
        console.table(istenen);
    }  catch(err){
        console.warn(err.message);
    }
}

urunCek();

const fetchDr = () => new Promise(res => 
    setTimeout(() => res(["dr.A", "dr.B"]), 1200));
const fetchOda = () => new Promise(res =>
    setTimeout(() => res(["vip oda", "masaj odası"]), 500));

const verileriYukle = async() => {
    try{
        const [dr, odalar] = await Promise.all([
            fetchDr(),
            fetchOda()
        ]);

    }catch(err){
        console.warn(err.message);
    }
}