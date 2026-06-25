import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/dialogs/mailDialog.dart';
import 'package:gtlmd/common/dialogs/model/MailDialogResult.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/otexPickupScreen/OtexPickupProvider.dart';
import 'package:gtlmd/pages/otexPickupScreen/widgets/collapsible_header_section.dart';
import 'package:gtlmd/pages/otexPickupScreen/widgets/otex_pickup_card.dart';
import 'package:provider/provider.dart';

class OtexPickupScreen extends StatelessWidget {
  final String? transactionId;
  final String? grno;
  final String? orderid;
  final bool isReadOnly;

  const OtexPickupScreen(
      {super.key, this.transactionId, this.grno, this.orderid, this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OtexPickupProvider>(
      create: (_) => OtexPickupProvider(),
      child: _OtexPickupScreenBody(
        transactionId: transactionId,
        grno: grno,
        orderid: orderid,
        isReadOnly: isReadOnly,
      ),
    );
  }
}

class _OtexPickupScreenBody extends StatefulWidget {
  final String? transactionId;
  final String? grno;
  final String? orderid;
  final bool isReadOnly;

  const _OtexPickupScreenBody({
    super.key,
    this.transactionId,
    this.grno,
    this.orderid,
    this.isReadOnly = false,
  });

  @override
  State<_OtexPickupScreenBody> createState() => _OtexPickupScreenBodyState();
}

class _OtexPickupScreenBodyState extends State<_OtexPickupScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardCountController = TextEditingController();
  OtexPickupProvider? _provider;
  bool _isShowingError = false;
  bool _isShowingSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _cardCountController.text = "1";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<OtexPickupProvider>(context, listen: false);
      _provider!.addListener(_onProviderChanged);
      _provider!.initializeForm(
          transactionId: widget.transactionId,
          grno: widget.grno,
          orderid: widget.orderid,
          isReadOnly: widget.isReadOnly);
    });
  }

  // void _onProviderChanged() {
  //   final provider = _provider;
  //   if (provider == null || !mounted) return;
  //   final errorMsg = provider.state.errorMessage;
  //   if (errorMsg != null && errorMsg.isNotEmpty) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Row(
  //             children: [
  //               const Icon(Icons.error_outline, color: Colors.white, size: 20),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: Text(
  //                   errorMsg,
  //                   style: const TextStyle(fontSize: 13),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           backgroundColor: Colors.red.shade700,
  //           behavior: SnackBarBehavior.floating,
  //           margin: const EdgeInsets.all(12),
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //       provider.clearError();
  //     });
  //   }
  // }

  void _onProviderChanged() {
    if (!mounted || _provider == null) return;

    // Sync card count controller
    final providerCount = _provider!.state.splitInfo.length;
    if (_cardCountController.text != providerCount.toString()) {
      _cardCountController.text = providerCount.toString();
    }

    if (_provider!.state.isMailDialogOpen) {
      // Clear immediately to prevent re-opening on subsequent changes
      _provider!.closeMailDialog();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final result = await showDialog<MailDialogResult>(
            context: context,
            builder: (_) =>
                MailDialog(mailDetails: _provider!.state.mailDetails));
        if (result != null && mounted) {
          _provider!.sendMail(
              email: result.email,
              sendLabel: result.sendLabel,
              ccemails: result.ccemails);
        }
      });
    }

    // Error handling block
    if (!_isShowingError) {
      final errorMsg = _provider!.state.errorMessage;
      if (errorMsg != null && errorMsg.isNotEmpty) {
        _isShowingError = true;
        _provider!.clearError();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(errorMsg, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              duration: const Duration(seconds: 3),
            ),
          );
          _isShowingError = false;
        });
      }
    }

    // Success handling block
    if (!_isShowingSuccessMessage) {
      final successMessage = _provider!.state.successMessage;
      if (successMessage != null && successMessage.isNotEmpty) {
        _isShowingSuccessMessage = true;
        _provider!.clearError();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(successMessage,
                        style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              duration: const Duration(seconds: 3),
            ),
          );
          _isShowingSuccessMessage = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_onProviderChanged);
    _cardCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtexPickupProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        if (state.splitInfo.isNotEmpty &&
            _cardCountController.text != state.splitInfo.length.toString()) {
          _cardCountController.text = state.splitInfo.length.toString();
        }

        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: CommonColors.colorPrimary,
                title: Text(
                  widget.transactionId == null || widget.transactionId == "0"
                      ? 'OTEX Auto waybill entry'
                      : 'Edit Booking #${widget.transactionId}',
                  style: TextStyle(
                    color: CommonColors.White,
                    fontSize: SizeConfig.mediumTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: CommonColors.White,
                    size: SizeConfig.largeIconSize,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                elevation: 0,
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context)
                    .unfocus(), // Automatically dismiss keyboard on outside tap
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Main Scrollable Area
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.smallVerticalPadding,
                            horizontal: SizeConfig.smallHorizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section 1: Collapsible Header Card
                              CollapsibleHeaderSection(),
                              SizedBox(height: SizeConfig.mediumVerticalSpacing),

                              // Card Count Dynamic Control Form Row
                              // Card(\r\n                           //   surfaceTintColor: CommonColors.White,\r\n                           //   elevation: 1,\r\n                           //   shape: RoundedRectangleBorder(\r\n                           //       borderRadius: BorderRadius.circular(8)),\r\n                           //   child: Padding(\r\n                           //     padding: EdgeInsets.all(\r\n                           //         SizeConfig.mediumHorizontalSpacing),\r\n                           //     child: Row(\r\n                           //       children: [\r\n                           //         const Icon(Icons.copy_outlined,\r\n                           //             color: Colors.blueGrey),\r\n                           //         const SizedBox(width: 8),\r\n                           //         Expanded(\r\n                           //           child: Text(\r\n                           //             \"Number Of Destinations\",\r\n                           //             style: TextStyle(\r\n                           //               fontSize: SizeConfig.smallTextSize,\r\n                           //               fontWeight: FontWeight.w500,\r\n                           //               color: Colors.blueGrey.shade800,\r\n                           //             ),\r\n                           //           ),\r\n                           //         ),\r\n                           //         SizedBox(\r\n                           //           width: 70,\r\n                           //           child: TextFormField(\r\n                           //             controller: _cardCountController,\r\n                           //             keyboardType: TextInputType.number,\r\n                           //             textAlign: TextAlign.center,\r\n                           //             inputFormatters: [\r\n                           //               FilteringTextInputFormatter.digitsOnly\r\n                           //             ],\r\n                           //             style: const TextStyle(\r\n                           //                 fontWeight: FontWeight.bold),\r\n                           //             decoration: InputDecoration(\r\n                           //               contentPadding:\r\n                           //                   const EdgeInsets.symmetric(\r\n                           //                       vertical: 8, horizontal: 4),\r\n                           //               border: OutlineInputBorder(\r\n                           //                   borderRadius:\r\n                           //                       BorderRadius.circular(8)),\r\n                           //             ),\r\n                           //             onChanged: (val) {\r\n                           //               final count = int.tryParse(val) ?? 1;\r\n                           //               provider.setCardCount(count);\r\n                           //             },\r\n                           //           ),\r\n                           //         ),\r\n                           //       ],\r\n                           //     ),\r\n                           //   ),\r\n                           // ),\r\n                           // SizedBox(height: SizeConfig.smallVerticalPadding),

// Section 2: Card count input  ← ADD THIS
                              // _buildCardCountRow(provider, state),
                              SizedBox(height: SizeConfig.smallVerticalPadding),

                              // Section 2: Dynamically Rendered Card List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.splitInfo.length,
                                itemBuilder: (context, index) {
                                  return OtexPickupCard(
                                    key: ValueKey("card_$index"),
                                    index: index,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Mail sending loading overlay
            if (state.isSendingMail)
              AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: CommonColors.colorPrimary,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sending Mail...',
                            style: TextStyle(
                              fontSize: SizeConfig.mediumTextSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please wait, do not go back.',
                            style: TextStyle(
                              fontSize: SizeConfig.smallTextSize,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Widget _buildCardCountRow(
  //     OtexPickupProvider provider, OtexPickupState state) {
  //   final floor = state.permanentCardCount > 0 ? state.permanentCardCount : 1;
  //   final isLocked = state.isHeaderLocked && state.permanentCardCount > 0;

  //   return Card(
  //     elevation: 1,
  //     color: Colors.white,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     child: Padding(
  //       padding: EdgeInsets.all(SizeConfig.mediumHorizontalSpacing),
  //       child: Row(
  //         children: [
  //           const Icon(Icons.copy_outlined, color: Colors.blueGrey),
  //           const SizedBox(width: 8),
  // Expanded(
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Number of Destinations",
  //         style: TextStyle(
  //           fontSize: SizeConfig.smallTextSize,
  //           fontWeight: FontWeight.w500,
  //           color: Colors.blueGrey.shade800,
  //         ),
  //       ),
  //       if (floor > 1)
  //         Text(
  //           "Minimum $floor (${floor} booking${floor > 1 ? 's' : ''} saved)",
  //           style: TextStyle(
  //             fontSize: SizeConfig.extraSmallTextSize,
  //             color: Colors.orange.shade700,
  //           ),
  //         ),
  //     ],
  //   ),
  // ),
  // SizedBox(
  //   width: 70,
  //   child: TextFormField(
  //     controller: _cardCountController,
  //     enabled: true,
  //     keyboardType: TextInputType.number,
  //     textAlign: TextAlign.center,
  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //     style: const TextStyle(fontWeight: FontWeight.bold),
  //     decoration: InputDecoration(
  //       contentPadding:
  //           const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //       border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8)),
  //       disabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide(color: Colors.grey.shade300),
  //       ),
  //       filled: isLocked,
  //       fillColor: Colors.grey.shade100,
  //     ),
  //     onChanged: (val) {
  //       if (val.isEmpty) return;
  //       final parsed = int.tryParse(val);
  //       if (parsed == null) return;
  //       if (parsed < floor || parsed > 100) return;
  //       provider.setCardCount(parsed);
  //     },
  //     onEditingComplete: () {
  //       final parsed =
  //           int.tryParse(_cardCountController.text) ?? floor;
  //       final clamped = parsed.clamp(floor, 100);
  //       _cardCountController.text = clamped.toString();
  //       provider.setCardCount(clamped);
  //       FocusScope.of(context).unfocus();
  //     },
  //   ),
  // ),
  //       ],
  //     ),
  //   ),
  // );
  // }
}
