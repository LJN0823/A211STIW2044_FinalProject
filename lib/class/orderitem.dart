class OrderItem {
  String? prid;
  String? orderid;
  String? prprice;
  String? oiquantity;
  String? oicusid;
  String? prname;
  String? prdesc;
  String? prquantity;
  String? prdelfee;

  OrderItem(
      {this.prid,
      this.orderid,
      this.prprice,
      this.oiquantity,
      this.oicusid,
      this.prname,
      this.prdesc,
      this.prquantity,
      this.prdelfee});

  OrderItem.fromJson(Map<String, dynamic> json) {
    prid = json['prid'];
    orderid = json['orderid'];
    prprice = json['prprice'];
    oiquantity = json['oiquantity'];
    oicusid = json['oicusid'];
    prname = json['prname'];
    prdesc = json['prdesc'];
    prquantity = json['prquantity'];
    prdelfee = json['prdelfee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prid'] = prid;
    data['orderid'] = orderid;
    data['prprice'] = prprice;
    data['oiquantity'] = oiquantity;
    data['oicusid'] = oicusid;
    data['prname'] = prname;
    data['prdesc'] = prdesc;
    data['prquantity'] = prquantity;
    data['prdelfee'] = prdelfee;
    return data;
  }
}