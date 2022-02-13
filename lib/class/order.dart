class Order {
  String? orreceiptID;
  String? orid;
  String? orcusID;
  String? orpaid;
  String? orstatus;
  String? ordate;
  String? oiquantity;
  String? prid;
  String? prname;
  String? prprice;
  String? prdelfee;

  Order(
      {this.orreceiptID,
      this.orid,
      this.orcusID,
      this.orpaid,
      this.orstatus,
      this.ordate});

  Order.fromJson(Map<String, dynamic> json) {
    orreceiptID = json['orreceiptID'];
    orid = json['orid'];
    orcusID = json['orcusID '];
    orpaid = json['orpaid'];
    orstatus = json['orstatus'];
    ordate = json['ordate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orreceiptID'] = orreceiptID;
    data['orid'] = orid;
    data['orcusID '] = orcusID;
    data['orpaid'] = orpaid;
    data['orstatus'] = orstatus;
    data['ordate'] = ordate;
    return data;
  }
}