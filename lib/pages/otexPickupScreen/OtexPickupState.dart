import 'package:gtlmd/pages/otexPickupScreen/models/OtexPickupInfoModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/models/OtexPickupSplitInfo.dart';
import 'package:gtlmd/pages/otexPickupScreen/models/mailDetails.dart';

enum SectionStatus { idle, loading, success, failure }

class OtexPickupState {
  // Header section state
  final SectionStatus headerStatus;

  // Card list section state
  final SectionStatus cardListStatus;

  // Header data
  final OtexPickupInfoModel info;

  // Mail data
  final MailDetails mailDetails;

  // All cards — both server-fetched and locally added
  final List<OtexPickupSplitInfo> splitInfo;

  // Cards confirmed saved on server — this is the floor,
  // user cannot go below this count
  final int permanentCardCount;

  // Running total of all palletQty across all cards
  final int totalPalletQty;

  // Whether a transactionId was passed in — drives disable logic
  final bool hasTransactionId;

  // Mail dialog state
  final bool isMailDialogOpen;

  // One-shot error message for snackbar, null = no error
  final String? errorMessage;
  final String? successMessage;

  final bool openVehicleArrival;

  final String? vehicleArrivalUrl;
  final bool isReadOnly;

  const OtexPickupState({
    required this.headerStatus,
    required this.cardListStatus,
    required this.info,
    required this.mailDetails,
    required this.splitInfo,
    required this.permanentCardCount,
    required this.totalPalletQty,
    required this.hasTransactionId,
    required this.isMailDialogOpen,
    required this.openVehicleArrival,
    required this.vehicleArrivalUrl,
    required this.isReadOnly,
    this.errorMessage,
    this.successMessage,
  });

  factory OtexPickupState.initial() {
    return OtexPickupState(
        headerStatus: SectionStatus.idle,
        cardListStatus: SectionStatus.idle,
        info: OtexPickupInfoModel(),
        mailDetails: MailDetails(),
        splitInfo: [OtexPickupSplitInfo()],
        permanentCardCount: 0,
        totalPalletQty: 0,
        hasTransactionId: false,
        isMailDialogOpen: false,
        errorMessage: null,
        successMessage: null,
        openVehicleArrival: false,
        vehicleArrivalUrl: '',
        isReadOnly: false);
  }

  // Convenience getters — used in UI to decide enable/disable
  bool get isHeaderLocked =>
      hasTransactionId && headerStatus == SectionStatus.success;
  bool get isCardCountLocked => permanentCardCount > 0;

  OtexPickupState copyWith(
      {SectionStatus? headerStatus,
      SectionStatus? cardListStatus,
      OtexPickupInfoModel? info,
      MailDetails? mailDetails,
      List<OtexPickupSplitInfo>? splitInfo,
      int? permanentCardCount,
      int? totalPalletQty,
      bool? hasTransactionId,
      bool? isMailDialogOpen,
      String? errorMessage,
      String? successMessage,
      bool clearError =
          false, // explicit clear without overwriting other fields
      bool openVehicleArrival = false,
      String? vehicleArrivalUrl,
      bool? isReadOnly}) {
    return OtexPickupState(
        headerStatus: headerStatus ?? this.headerStatus,
        cardListStatus: cardListStatus ?? this.cardListStatus,
        info: info ?? this.info,
        mailDetails: mailDetails ?? this.mailDetails,
        splitInfo: splitInfo ?? this.splitInfo,
        permanentCardCount: permanentCardCount ?? this.permanentCardCount,
        totalPalletQty: totalPalletQty ?? this.totalPalletQty,
        hasTransactionId: hasTransactionId ?? this.hasTransactionId,
        isMailDialogOpen: isMailDialogOpen ?? this.isMailDialogOpen,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        successMessage:
            clearError ? null : (successMessage ?? this.successMessage),
        openVehicleArrival: openVehicleArrival,
        vehicleArrivalUrl: vehicleArrivalUrl ?? this.vehicleArrivalUrl,
        isReadOnly: isReadOnly ?? this.isReadOnly);
  }
}
