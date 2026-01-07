class DepartmentModel {
  final int? custDeptId;
  final String? custDeptName;
  final String? gstNo;
  final String? state;
  final String? billCategory;
  final String? billingBranchCode;
  final String? billingBranch;

  DepartmentModel({
    this.custDeptId,
    this.custDeptName,
    this.gstNo,
    this.state,
    this.billCategory,
    this.billingBranchCode,
    this.billingBranch,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      custDeptId: json['custdeptid'],
      custDeptName: json['custdeptname'],
      gstNo: json['gstno'],
      state: json['state'],
      billCategory: json['billcategory'],
      billingBranchCode: json['billingbranchcode'],
      billingBranch: json['billingbranch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custdeptid': custDeptId,
      'custdeptname': custDeptName,
      'gstno': gstNo,
      'state': state,
      'billcategory': billCategory,
      'billingbranchcode': billingBranchCode,
      'billingbranch': billingBranch,
    };
  }
}
