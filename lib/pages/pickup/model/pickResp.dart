import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/pickup/model/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/pickupDetailModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';

class PickResp {
  List<PickupDetailModel> pickupList;
  List<ServiceTypeModel> serviceList;
  List<LoadTypeModel> loadList;
  List<DeliveryTypeModel> deliveryList;
  List<BookingTypeModel> bookingList;

  PickResp({
    required this.pickupList,
    required this.serviceList,
    required this.loadList,
    required this.deliveryList,
    required this.bookingList,
  });
}
