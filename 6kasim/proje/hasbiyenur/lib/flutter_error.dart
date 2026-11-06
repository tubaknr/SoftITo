class HataServisi{





  Future<void> sessizHataKaydet(dynamic hata,StackTree stack) async{
    await _crashlytics.recordError(hata, stack, fatal:true);
  }

  ElevatedButton(
    onPressed: () {
      FirebaseCrashlytics.instance.crash();
    },
    child: const Text('Çökme Testi Gönder');
  )
}