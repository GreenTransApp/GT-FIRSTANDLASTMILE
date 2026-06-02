import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupInfoModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupSplitInfo.dart';

enum OtexPickupStatus { idle, loading, success, failure }

class OtexPickupState {
  final OtexPickupStatus status;
  final OtexPickupInfoModel? info;
  final List<OtexPickupSplitInfo> splitInfo;
  final String? errorMessage;

  OtexPickupState({
    required this.status,
    this.info,
    this.splitInfo = const [],
    this.errorMessage,
  });

  factory OtexPickupState.initial() {
    return OtexPickupState(
      status: OtexPickupStatus.idle,
      info: null,
      splitInfo: const [],
      errorMessage: null,
    );
  }

  OtexPickupState copyWith({
    OtexPickupStatus? status,
    OtexPickupInfoModel? info,
    List<OtexPickupSplitInfo>? splitInfo,
    String? errorMessage,
  }) {
    return OtexPickupState(
      status: status ?? this.status,
      info: info ?? this.info,
      splitInfo: splitInfo ?? this.splitInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
