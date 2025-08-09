class StringConstants {
  static StringConstants? _instance;

  static StringConstants get instance => _instance ??= StringConstants._init();

  StringConstants._init();
  final String appName = "PDKS";
  final String begining = "Başlangıç";
  final String choose = "Seçiniz";
  final String email = "Email";
  final String description = "Açıklama";
  final String dontAccount = "Hesabınız yok mu?";
  final String finish = "Bitiş";
  final String mission = "Görev";
  final String monthlyData = "Aylık Verilerim";
  final String name = "Ad - Soyad";
  final String newAccount = "Yeni bir hesap oluşturun!";
  final String inTime = "Giriş Saati";
  final String outTime = "Çıkış Saati";
  final String send = "Gönder";
  final String shift = "Mesai";
  final String password = "Şifre";
  final String passwordConfirm = "Şifre Tekrarı";
  final String phone = "Telefon";
  final String profileLoading = "Profiliniz güncelleniyor...";
  final String companyText = "MaviHost";
  final String splashFooter = " tarafından geliştirilmiştir";
  final String signUp = "Kayıt Ol";
  final String welcome = "Hoşgeldiniz!";
  final String okey = "Tamam";
  final String outSideText = "Kurum Dışı";
  final String splashText1 = 'Personel Devam';
  final String splashText2 = 'Kontrol Sistemi';
  final String welcomeText = "Giriş yapmak için lütfen bilgilerinizi giriniz.";
  final String signUpText =
      "Kayıt olmak için lütfen bilgilerinizi eksiksizce giriniz.";
  final String loginText = "Giriş Yap";
  final String signUpBtnText = "Kayıt Ol";
  final String logOutText = "Çıkış Yap";
  final String profileText = "Profilim";
  final String inAndOutText = "Mesai Hareketleri";
  final String leavelProsedureText = "İzinlerim";
  final String leaveText = 'İzin Tipi';
  final String leaveStartText = 'İzin Başlangıç';
  final String leaveReasonText = 'İzin Sebebi';
  final String moveAddressText = 'İzindeki Adres';
  final String getLeavePermissionText = "İzin Al";
  final String locationError =
      'Lütfen konum bilgilerinin alınmasını bekleyiniz.';
  final String exitInfo =
      "'Çıkış Yap' butonuna tıklarsanız bu cihazdaki tüm bilgileriniz (otomatik giriş bilgileriniz, offline giriş çıkış bilgileriniz, cihaz bilgileriniz vb.) silinecektir!!";
  final String exitTitle = 'PDKS Kullanıcılarının Çıkış Yapması Önerilmez!!\n ';
  final String noLeaveText = 'Henüz Bir İzin İşleminiz Bulunmamaktadır.';
  final String noInAndOutText = 'Henüz Bir Mesai İşleminiz Bulunmamaktadır.';
  final String mockTimeText1 = 'Telefonunuzun saati yanlış\n';
  final String mockTimeTex2 =
      "Telefon saatinin yanlış olması PDKS kurallarını ihlal eder. Lütfen telefon ayarlarından 'Tarih ve Saat' ayarını 'Ağın sağladığı saati kullan' seçiniz!";
  final String appVersionText = "Uygulama versiyonu";
  final String inText = 'Giriş Yapıyorsunuz';
  final String outText = 'Çıkış Yapıyorsunuz';
  final String noOffMode = 'Bu cihazda offline mod bulunmamaktadır.';
  final String lateText = 'Geç Kaldınız!!';
  final String lateDescription = 'Geç kalma sebebinizi açıklar mısınız..';
  final String cancelText = 'İşlem Tamamlanmadı';
  final String successMessage = "İşlem Başarılı";
  final String successMessage2 = "İşleminiz Başarılı";
  final String offModeDialog =
      "Çevrim dışı mod kapalı. Bu işlemi yapamazsınız!! \nYöneticiniz ile iletişime geçiniz..";
  final String earlyText = "Erken Çıkıyorsunuz !!";
  final String earlyDescription = "Erken Çıkma Sebebinizi Açıklar mısınız ..";
  final String cancelText2 = "İşlem İptal Edildi";
  final String networkMsg =
      "İnternetiniz Kapalı.Şu anda işlem gerçekleştirilemiyor.";
  final String warningMessage1 = "İnternetinizi açınız !!";
  final String outSuccessMessage = "Çıkış işlemi başarılı";
  final String qrErrorMessage = "Karekod Ayrıştırılamadı.";
  final String inErrorMessage = "Bugüne ait giriş işleminiz bulunmaktadır.";
  final String outErrorMessage = "Bugüne ait çıkış işleminiz bulunmaktadır.";
  final String approveButtonText = "Onayla";
  final String cancelButtonText = "İptal";
  final String checkInTime = "Giriş Saati";
  final String checkOutTime = "Çıkış Saati";
  final String unSpecified = "Belirtilmedi";
  final String unExpectedError = "Bir şeyler ters gitti";
  final String nonAppRedirect = "Uygulama Dışı Yönlendirme!";
  final String enterTheAdress = "Adresine girmek istediğinize emin misiniz?";
  final String errorMessage = "Beklenmedik bir hata oluştu";
  final String errorMessageContinue = ",Lütfen daha sonra tekrar deneyiniz.";
  final String dialogAlertDescription =
      "Açıklama alanı zorunludur ve minimum 5 karakterden oluşmalıdır.";
  final String isMockLocationPermissionTitle =
      "Sahte konum kullanmak PDKS kurallarını ihlal eder.";
  final String isMockLocationPermissionDescription =
      "PDKS uygulamasını kullanabilmeniz için telefonunuzda sahte konum hizmeti veren uygulama olmadığından emin olun.";
  final String isEnableLocationAlertText =
      "Telefonun Konumu Kapalı Görünüyor\nLütfen Konumunuzu Açın";
  final String isNotEnableLocationAlertText =
      "PDKS'nin Konum İznini Reddettiniz.\nLütfen Uygulama Ayarlarından Konuma İzin Verin.";
  final String hackText =
      "Sistemi Bozmaya Çalıştığınız Tespit Edildi. PDKS Kurallarını İhlal Ettiğiniz İçin Uygulamayı Kullanmaya Devam Etmenize İzin Veremiyoruz.";
  final String dateText = "Tarih";
  final String notEmptyText = "Lütfen Bütün Alanları Doldurunuz!";
  final String reviewText = "İncelenmek üzere gönderildi";
  final String loginErrorMsg = "Email ya da parola boş olamaz";
  final String loginErrorMsg2 =
      "Lütfen sizden istenilen bilgileri eksiksizce giriniz.";
  final String loginSuccessMsg = "Bilgileriniz Onaylandı.";
  final String emailValidMsg = "Lütfen geçerli bir email adresi giriniz.";
  final String passwordValidMsg = "Şifre uzunluğu 6 karakterden az olamaz!";
  final String qrErrorMsg = "Alan esnetme bildiriminize izin verilmemektedir.";
  final String locationErrorMsg = "Konumunuz işlem için uygun değil.";
  final String registerNameErrorMsg =
      "Ad - Soyad alanı en az 5 karakterden oluşmalıdır.";
  final String appMessage =
      "Uygulamayı kullanabilmek için uygulamayı son sürüme güncellemeniz gereklidir.";
  final String offModeandQrAreaDialog =
      "Alan Bildirimi ve Çevrim dışı modları kapalı olabilir. Bu işlemi gerçekleştiremezsiniz \nYöneticiniz ile iletişime geçiniz..";
  final String mapUrl =
      "https://mt0.google.com/vt/lyrs=p&x={x}&y={y}&z={z}&s=Ga";

  String determineString(int index) {
    switch (index) {
      case 0:
        return 'Beklemede';
      case 1:
        return 'Onaylandı';
      case 2:
        return 'Reddedildi';
      default:
        return 'Beklemede';
    }
  }

  final String baseUrl = "https://crm.mavihost.com.tr/api/";
  final String loginUrl = 'auth/login';
  final String logout = 'auth/logout';
  final String profile = "user/profile";
  final String permissionList = "holiday/list";
  final String permissionCreate = "holiday/create";
  final String shiftPing = "pdks/ping";
  final String shiftQR = "pdks/zone";
  final String shiftList = "pdks/list";
  final String isAvalible = "isavailable";
  final String register = "auth/register";
  final String refreshToken = "auth/refresh";
}
