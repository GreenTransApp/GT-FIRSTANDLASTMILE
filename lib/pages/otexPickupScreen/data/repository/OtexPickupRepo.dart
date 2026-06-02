import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/pinCodeModel.dart';

abstract class OtexPickupRepo {
  Future<List<CustomerModel>> getCustomerList(Map<String, String> params);
  Future<List<BranchModel>> getBranchList(Map<String, String> params);
  Future<List<PinCodeModel>> getPincodeList(Map<String, String> params);
  Future<List<CngrCngeModel>> getCngrCngeList(Map<String, String> params, String type);
  Future<List<DepartmentModel>> getDepartmentList(Map<String, String> params);
}
