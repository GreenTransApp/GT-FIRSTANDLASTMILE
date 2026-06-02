import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/widgets/collapsible_header_section.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/widgets/otex_pickup_card.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/controller/OtexPickupProvider.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/controller/state/OtexPickupState.dart';

class OtexPickupScreen extends StatelessWidget {
  final String?
      transactionId; // Optional pre-fill transaction ID passed from previous screen

  const OtexPickupScreen({
    super.key,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OtexPickupProvider>(
      create: (_) => OtexPickupProvider(),
      child: _OtexPickupScreenBody(transactionId: transactionId),
    );
  }
}

class _OtexPickupScreenBody extends StatefulWidget {
  final String? transactionId;

  const _OtexPickupScreenBody({
    super.key,
    this.transactionId,
  });

  @override
  State<_OtexPickupScreenBody> createState() => _OtexPickupScreenBodyState();
}

class _OtexPickupScreenBodyState extends State<_OtexPickupScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardCountController = TextEditingController();
  OtexPickupProvider? _provider;

  @override
  void initState() {
    super.initState();
    _cardCountController.text = "1";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<OtexPickupProvider>(context, listen: false);
      _provider!.addListener(_onProviderChanged);
      _provider!.initializeForm(transactionId: widget.transactionId);
    });
  }

  void _onProviderChanged() {
    final provider = _provider;
    if (provider == null || !mounted) return;
    final errorMsg = provider.state.errorMessage;
    if (errorMsg != null && errorMsg.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMsg,
                    style: const TextStyle(fontSize: 13),
                  ),
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
        provider.clearError();
      });
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

        // Dynamically adjust local controller text if count is synchronized by API or updates
        if (state.splitInfo.isNotEmpty &&
            _cardCountController.text != state.splitInfo.length.toString()) {
          _cardCountController.text = state.splitInfo.length.toString();
        }

        // Dynamically evaluate if freight input is conditionally visible
        final bool isFreightVisible = state.info?.bookingTypeCode == "PP";

        if (state.status == OtexPickupStatus.loading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: CommonColors.colorPrimary,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
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
                          CollapsibleHeaderSection(controller: provider),
                          SizedBox(height: SizeConfig.mediumVerticalSpacing),

                          // Card Count Dynamic Control Form Row
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.mediumHorizontalSpacing),
                              child: Row(
                                children: [
                                  const Icon(Icons.copy_outlined,
                                      color: Colors.blueGrey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Number of dynamic entries required",
                                      style: TextStyle(
                                        fontSize: SizeConfig.smallTextSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueGrey.shade800,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: TextFormField(
                                      controller: _cardCountController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 4),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      onChanged: (val) {
                                        final count = int.tryParse(val) ?? 1;
                                        provider.setCardCount(count);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.smallVerticalPadding),

                          // Section 2: Dynamically Rendered Card List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.splitInfo.length,
                            itemBuilder: (context, index) {
                              return OtexPickupCard(
                                key: ValueKey(
                                    "otex_card_${index}_${state.splitInfo.length}"), // Recycle correctly
                                controller: provider,
                                index: index,
                                isFreightVisible: isFreightVisible,
                                onDelete: state.splitInfo.length > 1
                                    ? () => provider.removeCardEntry(index)
                                    : null,
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
        );
      },
    );
  }
}
