dokümanda güncelleme yaparsan:

- docs readme.md

---

gizlilik olarak ASLA vermememiz gereken dosyalar:
.env --> canlıda çalışır --> VERİRSEN TÜM PROJEN ÇÖP OLUR!!!!!!
.env.local --> lokalde çalışır
.key
secret_keys.json
google_services.json

Bağımlılık çöpleri:
/node_modules/
/builds/
/.dart_tool/
/dist/

işletim sisteminin çöpleri:
.DS_Store
Thumbs.db

.env DAHA PROJEYE BAŞLADIĞIN AN İGNORE EDİLMEK ZORUNDADIR!!!!!

bir klasörde git init edip, sonra içinde yeni klasör içinde tekrar git init yaparsan, içerideki klasördeki git init i kapatman gerekir.

gitignore, tüm proje içini yakalar, path path yazmak gerekmez. tüm projedeki .env vs dosyaları yakalar.

versiyonlama
