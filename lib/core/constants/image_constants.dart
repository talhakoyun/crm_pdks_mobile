class ImageConstants {
  static ImageConstants? _instance;

  static ImageConstants get instance => _instance ??= ImageConstants._init();

  ImageConstants._init();
  // PNG ALANI
  String get alarm => toPNG('alarm');
  String get error => toPNG('error');
  String get female => toPNG('female');
  String get getPerm => toPNG('getPerm');
  String get logo => toPNG('logo');
  String get male => toPNG('male');
  String get marker => toPNG('marker');
  String get splashBG => toPNG('splashBG');
  String get splashLogo => toPNG('splashLogo');
  String get success => toPNG('success');
  String get userWhite => toPNG('userWhite'); //xx
  String get warning => toPNG('warning');

  // SVG ALANI
  String get administrative => toSVG('administrative');
  String get annualpermit => toSVG('annualPermit');
  String get approved => toSVG('approved');
  String get birthPerm => toSVG('birthPerm');
  String get breastfeeding => toSVG('breastfeeding');
  String get ddIcon => toSVG('ddIcon'); //xx
  String get death => toSVG('death');
  String get denied => toSVG('denied');
  String get description => toSVG('description');
  String get free => toSVG('free');
  String get health => toSVG('health');
  String get logout => toSVG('logout');
  String get maternity => toSVG('maternity');
  String get noLocation => toSVG('noLocation');
  String get offMode => toSVG('offMode');
  String get onHold => toSVG('onHold');
  String get paternity => toSVG('paternity');
  String get permission => toSVG('permission');
  String get qr => toSVG('qr');
  String get start => toSVG('start');
  String get stop => toSVG('stop');
  String get user => toSVG('user');
  String get wedding => toSVG('wedding');
  String get zoneQR => toSVG('zoneQR');

  String toPNG(String name) => 'assets/images/png/ic_$name.png';
  String toSVG(String name) => 'assets/images/svg/ic_$name.svg';
}
