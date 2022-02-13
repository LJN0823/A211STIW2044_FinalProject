class Product {
  String? prid;
  String? prname;
  String? prdesc;
  String? prprice;
  String? prquantity;
  String? prdelfee;
  String? prdate;

  Product(
      {required this.prid,
      required this.prname,
      required this.prdesc,
      required this.prprice,
      required this.prquantity,
      required this.prdelfee,
      required this.prdate});

  Product.fromJson(Map<String, dynamic> json) {
    prid = json['prid'];
    prname = json['prname'];
    prdesc = json['prdesc'];
    prprice = json['prprice'];
    prquantity = json['prquantity'];
    prdelfee = json['prdelfee'];
    prdate = json['prdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prid'] = prid;
    data['prname'] = prname;
    data['prdesc'] = prdesc;
    data['prprice'] = prprice;
    data['prquantity'] = prquantity;
    data['prdelfee'] = prdelfee;
    data['prdate'] = prdate;
    return data;
  }
}