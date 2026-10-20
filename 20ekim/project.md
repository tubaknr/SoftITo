# Yörünge — Girişimcilik Platformu

Bu doküman Flutter projesinde geliştirme yapacak olan Ajan (AntiGravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

---

## 1. Projenin Kimliği ve Vizyonu

- **Uygulama Adı:** Yörünge (girişimciler için uçtan uca destek platformu)
- **Ne yapar:** Fikir veya iş planı olan girişimcileri; mentorlara, yatırımcılara, destek programlarına ve diğer girişimcilere bağlar. Kullanıcı eğer kendi iş planını da sisteme göndermek isterse bir buton ile forma bağlanır, iş planını detaylı bir analiz formuyla gönderir, eğer istemezse noraml uygulamadan devam eder. Uzman ekip planı inceler, onaylanan fikirler sisteme dahil edilir. Onaylanan girişimciler için hukuki süreç (şirket kuruluşu, tescil, sözleşmeler vb. Türkiye Cumhuriyeti mevzuatına göre) platform tarafından atanan **ücretsiz avukat** ile yürütülür ve platform **gelir destek taahhüdü** sağlar.
- **Kime hitap eder:** Türkiye'deki fikir aşamasından büyüme aşamasına kadar tüm girişimciler.
- **Hedef Platformlar:** iOS ve Android öncelikli; ardından web ve masaüstü.
- **Flutter SDK:** 3.27.x
- **Dart SDK:** 3.6.0
- **Dil:** Arayüz metinleri Türkçe.

---

## 2. Mimari Desen ve Dizin Haritası

Mimari: **Özellik bazlı (feature-first)** + katmanlı ayrım (controller / model / view / widget). Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
    main.dart
    test/
    core/
        constants/
        theme/
        extensions/
        widgets/
    features/
        shell/
            controller/
            view/
            widget/
        fikir_durumu/
            controller/
            models/
            view/
            widget/
        destek_takibi/
            controller/
            models/
            view/
            widget/
        mentor/
            controller/
            models/
            view/
            widget/
        yatirimci/
            controller/
            models/
            view/
            widget/
        programlar/
            controller/
            models/
            view/
            widget/
        topluluk/
            controller/
            models/
            view/
            widget/
```

