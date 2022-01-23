class Country {
  final String name;
  final String isoCode;
  final String iso3Code;
  final String phoneCode;
  final String currencyCode;
  final String currencySymbol;
  final String currencyName;

  Country({this.isoCode, this.iso3Code, this.phoneCode, this.name, this.currencyCode, this.currencyName,this.currencySymbol});

  factory Country.fromMap(Map<String, String> map) => Country(
    name: map['name'],
    isoCode: map['isoCode'],
    iso3Code: map['iso3Code'],
    phoneCode: map['phoneCode'],
    currencyCode: map['currencyCode'],
    currencySymbol: map['currencySymbol'],
    currencyName: map['currencyName'],

  );
}