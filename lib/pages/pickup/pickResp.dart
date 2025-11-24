import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/pickup/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/pickupDetailModel.dart';
import 'package:gtlmd/pages/pickup/serviceTypeModel.dart';

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
