class QrModel {
  int? id;
  String? name;
  int? branchID;
  int? companyID;

  QrModel({this.id, this.name, this.branchID, this.companyID});

  factory QrModel.fromJson(Map<String, dynamic> json) => QrModel(
        id: json["id"],
        name: json["name"],
        branchID: json["branch_id"],
        companyID: json["company_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "branch_id": branchID,
        "company_id": companyID,
      };
}
