class User {
  String? id;
  String? phone;
  String? name;
  String? email;
  String? address;
  String? datereg;
  String? loc;
  String? otp;

  User(
      {required this.id,
      required this.phone,
      required this.name,
      required this.email,
      required this.address,
      required this.datereg,
      required this.loc,
      required this.otp});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    datereg = json['datereg'];
    loc = json['loc'];
    otp = json['otp'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['name'] = name;
    data['email'] = email;
    data['address'] = address;
    data['datereg'] = datereg;
    data['loc'] = loc;
    data['otp'] = otp;
    return data;
  }
}
