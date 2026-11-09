// Tüm enum'lar: Firestore değeri (value) + Türkçe etiket (label).

enum UserRole {
  citizen('citizen', 'Vatandaş'),
  coordinator('coordinator', 'Koordinatör'),
  volunteer('volunteer', 'Gönüllü');

  const UserRole(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static UserRole? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static UserRole fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum SafetyStatus {
  safe('safe', 'Güvendeyim'),
  danger('danger', 'Tehlikedeyim');

  const SafetyStatus(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static SafetyStatus? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static SafetyStatus fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum HelpType {
  trapped('trapped', 'Enkaz Altında'),
  medical('medical', 'Tıbbi Müdahale'),
  shelter('shelter', 'Çadır / Barınma'),
  water('water', 'Temiz Su'),
  babyFood('baby_food', 'Bebek Maması'),
  heating('heating', 'Isınma');

  const HelpType(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static HelpType? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static HelpType fromValue(Object? v) => tryParse(v) ?? values.first;

  /// Triage kuralı (İş Kuralı 1): enkaz/yaralı = kırmızı, malzeme = 2. ve 3. öncelik.
  RequestPriority get defaultPriority => switch (this) {
        HelpType.trapped || HelpType.medical => RequestPriority.critical,
        HelpType.water || HelpType.babyFood || HelpType.heating => RequestPriority.urgent,
        HelpType.shelter => RequestPriority.normal,
      };
}

enum RequestPriority {
  critical(1, 'Kritik'),
  urgent(2, 'Acil'),
  normal(3, 'Normal');

  const RequestPriority(this.value, this.label);

  /// Firestore'a yazılan değer.
  final int value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static RequestPriority? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static RequestPriority fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum CaseStatus {
  open('open', 'Açık'),
  assigned('assigned', 'Atandı'),
  enRoute('en_route', 'Yola Çıktı'),
  onSite('on_site', 'Olay Yerinde'),
  resolved('resolved', 'Kurtarıldı / Çözüldü'),
  merged('merged', 'Birleştirildi');

  const CaseStatus(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static CaseStatus? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static CaseStatus fromValue(Object? v) => tryParse(v) ?? values.first;

  bool get isActive => this != CaseStatus.resolved && this != CaseStatus.merged;

  /// Durum akışı: Atandı -> Yola Çıktı -> Olay Yerinde -> Çözüldü
  CaseStatus? get next => switch (this) {
        CaseStatus.open => CaseStatus.assigned,
        CaseStatus.assigned => CaseStatus.enRoute,
        CaseStatus.enRoute => CaseStatus.onSite,
        CaseStatus.onSite => CaseStatus.resolved,
        _ => null,
      };
}

enum TeamKind {
  searchRescue('search_rescue', 'Arama Kurtarma'),
  medical('medical', 'Sağlık'),
  courier('courier', 'Kurye'),
  logistics('logistics', 'Lojistik');

  const TeamKind(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static TeamKind? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static TeamKind fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum TeamStatus {
  available('available', 'Müsait'),
  busy('busy', 'Görevde'),
  offline('offline', 'Çevrimdışı');

  const TeamStatus(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static TeamStatus? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static TeamStatus fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum ItemCategory {
  water('water', 'Su'),
  blanket('blanket', 'Battaniye'),
  food('food', 'Gıda'),
  medical('medical', 'Tıbbi Malzeme'),
  generator('generator', 'Jeneratör'),
  tent('tent', 'Çadır'),
  hygiene('hygiene', 'Hijyen'),
  other('other', 'Diğer');

  const ItemCategory(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static ItemCategory? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static ItemCategory fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum StockMovementType {
  inbound('inbound', 'Depoya Giriş'),
  outbound('outbound', 'Depodan Çıkış (Zimmet)');

  const StockMovementType(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static StockMovementType? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static StockMovementType fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum VolunteerSkill {
  firstAid('first_aid', 'İlk Yardımcı'),
  driver('driver', 'Şoför'),
  cook('cook', 'Aşçı'),
  psychosocial('psychosocial', 'Psikososyal Destek'),
  craneOperator('crane_operator', 'Vinç Operatörü'),
  other('other', 'Diğer');

  const VolunteerSkill(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static VolunteerSkill? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static VolunteerSkill fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum VolunteerAvailability {
  available('available', 'Müsait'),
  onShift('on_shift', 'Vardiyada'),
  offDuty('off_duty', 'Mesai Dışı');

  const VolunteerAvailability(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static VolunteerAvailability? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static VolunteerAvailability fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum AssemblyKind {
  assemblyArea('assembly_area', 'Toplanma Alanı'),
  fieldHospital('field_hospital', 'Sahra Hastanesi'),
  shelter('shelter', 'Barınma Alanı');

  const AssemblyKind(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static AssemblyKind? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static AssemblyKind fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum PersonStatus {
  missing('missing', 'Aranıyor'),
  found('found', 'Bulundu'),
  hospitalized('hospitalized', 'Hastanede'),
  evacuated('evacuated', 'Tahliye Edildi');

  const PersonStatus(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static PersonStatus? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static PersonStatus fromValue(Object? v) => tryParse(v) ?? values.first;
}

enum BroadcastType {
  evacuation('evacuation', 'Acil Tahliye'),
  aftershock('aftershock', 'Artçı Sarsıntı Uyarısı'),
  info('info', 'Bilgilendirme');

  const BroadcastType(this.value, this.label);

  /// Firestore'a yazılan değer.
  final String value;

  /// Arayüzde gösterilen Türkçe etiket.
  final String label;

  static BroadcastType? tryParse(Object? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// Bilinmeyen / eksik değerde ilk elemana düşer.
  static BroadcastType fromValue(Object? v) => tryParse(v) ?? values.first;
}
