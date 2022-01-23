class MetalRates {
  final double silverRate;
  final double goldRate;

  MetalRates({
    this.silverRate,
    this.goldRate,
  });

  factory MetalRates.fromJson(Map<String, dynamic> json) {
    return MetalRates(
      silverRate:
          json['items'][0]['xagPrice'] / 31.1034768, //convert ounce to gm
      goldRate: json['items'][0]['xauPrice'] / 31.1034768, //convert ounce to gm
    );
  }
}
