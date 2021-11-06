final String tableContracts = 'contracts';

class ContractFields {
  static final List<String> values = [id, code, name, img, address, decimals];

  static final String id = '_id';
  static final String code = 'code';
  static final String name = 'name';
  static final String img = 'img';
  static final String address = 'address';
  static final String decimals = 'decimals';
}

class Contract {
  final int? id;
  final String code;
  final String name;
  final String img;
  final String address;
  final int? decimals;

  const Contract(
      {this.id,
      required this.code,
      required this.name,
      required this.img,
      required this.address,
      this.decimals});

  Contract copy(
          {int? id,
          String? code,
          String? name,
          String? img,
          String? address,
          int? decimals}) =>
      Contract(
          id: id ?? this.id,
          code: code ?? this.code,
          name: name ?? this.name,
          img: img ?? this.img,
          address: address ?? this.address,
          decimals: decimals ?? this.decimals);

  static Contract fromJson(Map<String, Object?> json) => Contract(
        id: json[ContractFields.id] as int,
        code: json[ContractFields.code] as String,
        name: json[ContractFields.name] as String,
        img: json[ContractFields.img] as String,
        address: json[ContractFields.address] as String,
        decimals: json[ContractFields.decimals] as int,
      );

  Map<String, Object?> toJson() => {
        ContractFields.id: id,
        ContractFields.code: code,
        ContractFields.name: name,
        ContractFields.address: address,
        ContractFields.img: img,
        ContractFields.decimals: decimals,
      };
}
