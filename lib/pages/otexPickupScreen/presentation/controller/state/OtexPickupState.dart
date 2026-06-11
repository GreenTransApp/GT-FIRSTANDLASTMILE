import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupInfoModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupSplitInfo.dart';

enum SectionStatus { idle, loading, success, failure }

class OtexPickupState {
  // Header section state
  final SectionStatus headerStatus;

  // Card list section state
  final SectionStatus cardListStatus;

  // Header data
  final OtexPickupInfoModel info;

  // All cards — both server-fetched and locally added
  final List<OtexPickupSplitInfo> splitInfo;

  // Cards confirmed saved on server — this is the floor,
  // user cannot go below this count
  final int permanentCardCount;

  // Running total of all palletQty across all cards
  final int totalPalletQty;

  // Whether a transactionId was passed in — drives disable logic
  final bool hasTransactionId;

  // One-shot error message for snackbar, null = no error
  final String? errorMessage;

  const OtexPickupState({
    required this.headerStatus,
    required this.cardListStatus,
    required this.info,
    required this.splitInfo,
    required this.permanentCardCount,
    required this.totalPalletQty,
    required this.hasTransactionId,
    this.errorMessage,
  });

  factory OtexPickupState.initial() {
    return OtexPickupState(
      headerStatus: SectionStatus.idle,
      cardListStatus: SectionStatus.idle,
      info: OtexPickupInfoModel(),
      splitInfo: [OtexPickupSplitInfo()],
      permanentCardCount: 0,
      totalPalletQty: 0,
      hasTransactionId: false,
      errorMessage: null,
    );
  }

  // Convenience getters — used in UI to decide enable/disable
  bool get isHeaderLocked =>
      hasTransactionId && headerStatus == SectionStatus.success;
  bool get isCardCountLocked => permanentCardCount > 0;

  OtexPickupState copyWith({
    SectionStatus? headerStatus,
    SectionStatus? cardListStatus,
    OtexPickupInfoModel? info,
    List<OtexPickupSplitInfo>? splitInfo,
    int? permanentCardCount,
    int? totalPalletQty,
    bool? hasTransactionId,
    String? errorMessage,
    bool clearError = false, // explicit clear without overwriting other fields
  }) {
    return OtexPickupState(
      headerStatus: headerStatus ?? this.headerStatus,
      cardListStatus: cardListStatus ?? this.cardListStatus,
      info: info ?? this.info,
      splitInfo: splitInfo ?? this.splitInfo,
      permanentCardCount: permanentCardCount ?? this.permanentCardCount,
      totalPalletQty: totalPalletQty ?? this.totalPalletQty,
      hasTransactionId: hasTransactionId ?? this.hasTransactionId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
