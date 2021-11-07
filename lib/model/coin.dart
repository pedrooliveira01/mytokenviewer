class CoinFields {
  static final List<String> values = [name, png32, allTimeHighUSD, rate];

  static final String name = 'name';
  static final String png32 = 'png32';
  static final String allTimeHighUSD = 'allTimeHighUSD';
  static final String rate = 'rate';
}

class Coin {
  final String name;
  final String png32;
  final double allTimeHighUSD;
  final double rate;

  const Coin(
      {required this.name,
      required this.png32,
      required this.allTimeHighUSD,
      required this.rate});

  static Coin fromJson(Map<String, Object?> json) => Coin(
        name: json[CoinFields.name] as String,
        png32: json[CoinFields.png32] as String,
        allTimeHighUSD: json[CoinFields.allTimeHighUSD] as double,
        rate: json[CoinFields.rate] as double,
      );

  Map<String, Object?> toJson() => {
        CoinFields.name: name,
        CoinFields.allTimeHighUSD: allTimeHighUSD,
        CoinFields.png32: png32,
        CoinFields.rate: rate,
      };
}

List<Coin> coinList = [];
