import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart' as URL;
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/device_type.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:gtlmd/optionMenu/operations/operationsProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class Operations extends StatefulWidget {
  const Operations({super.key});

  @override
  State<Operations> createState() => _OperationsState();
}

class _OperationsState extends State<Operations> {
  late LoadingAlertService loadingAlertService;
  String defaultImagePath =
      'https://greentrans.in:446/GreenTransApp/imageplace.jpg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      _getMenuList();
      _getOperations();
    });
  }

  Future<void> _getOperations() async {
    Provider.of<OperationsProvider>(context, listen: false).getOperationsList();
  }

  Future<void> _getMenuList() async {
    Provider.of<OperationsProvider>(context, listen: false).getMenuData();
  }

  Future<void> onRefresh() async {
    _getMenuList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationsProvider>(builder: (_, provider, __) {
      // Handle state changes reactively
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.status == ApiCallingStatus.loading) {
          loadingAlertService.showLoading();
        } else {
          loadingAlertService.hideLoading();
        }

        if (provider.status == ApiCallingStatus.error &&
            provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage!)),
          );
        }
      });

      return Scaffold(
        backgroundColor: CommonColors.pageBackground,

        /// APP BAR
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CommonColors.colorPrimary,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Operations",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: .5,
            ),
          ),
          centerTitle: true,
        ),

        body: provider.menuList.isEmpty &&
                provider.status == ApiCallingStatus.success
            ? Center(
                child: Text(
                  "No Operations Found",
                  style: TextStyle(
                    color: CommonColors.grey600,
                    fontSize: SizeConfig.mediumTextSize,
                  ),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      /// HEADER CARD
                      Container(
                        // margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                       decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter, // Starts at the top
                              end: Alignment.bottomCenter, // Ends at the bottom
                              colors: [
                                CommonColors.colorPrimary!, // Top color
                                CommonColors.colorPrimary!
                                    .withAlpha((0.50 * 255).toInt()!), // Bottom color
                                // You can add more colors here if needed
                              ],
                            ),
                          ),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: CommonColors.colorPrimary2,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                // height: 40,
                                // width: 40,
                                decoration: BoxDecoration(
                                  color: CommonColors.White?.withOpacity(.15),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  Icons.apps_rounded,
                                  color: CommonColors.White,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Choose Operation",
                                      style: TextStyle(
                                        color: CommonColors.White,
                                        fontSize: SizeConfig.mediumTextSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "${provider.menuList.length} Modules Available",
                                      style: TextStyle(
                                        color:
                                            CommonColors.White?.withOpacity(.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// GRID
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: onRefresh,
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.smallHorizontalPadding,
                              vertical: SizeConfig.smallVerticalPadding,
                            ),
                            itemCount: provider.menuList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              //    crossAxisCount: 2,
                              // crossAxisSpacing: SizeConfig.smallTextSize,
                              // mainAxisSpacing: SizeConfig.smallTextSize,
                              // childAspectRatio: 0.92,
                            crossAxisCount: 2,
                            crossAxisSpacing: SizeConfig.smallTextSize,
                            mainAxisSpacing: SizeConfig.smallTextSize,
                            childAspectRatio: 1.4,

                            // childAspectRatio: 1.1,
                            ),
                            itemBuilder: (context, index) {
                              final operation = provider.menuList[index];

                            
                              return InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () async {
                                  final url =
                                      await provider.getSingleOperationDetail(
                                    operation.menucode ?? '',
                                  );

                                  if (url != null && url.isNotEmpty) {
                                    try {
                                      await launchUrl(
                                        Uri.parse(url),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } catch (_) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Could not launch URL',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.smallHorizontalPadding,
                                      vertical: SizeConfig.smallVerticalPadding,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
                                     
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        /// HERO IMAGE
                                        SizedBox(
                                          height: SizeConfig.deviceType ==
                                                  DeviceType.smallPhone
                                              ? 80
                                              : 100,
                                          child: Image.network(
                                            // "${URL.imageBaseUrl}GTINFINITIAPP/${operation.menuname}.png",
                                            "${operation.menuimage}",
                                            fit: BoxFit.contain,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              progress,
                                            ) {
                                              if (progress ==
                                                  null) {
                                                return child;
                                              }
                                                                          
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color:
                                                      CommonColors.colorPrimary,
                                                ),
                                              );
                                            },
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return SizedBox(
                                                 height: SizeConfig.deviceType ==
                                                  DeviceType.smallPhone
                                              ? 80
                                              : 100,
                                                child: Image.network(
                                                  defaultImagePath,
                                                  fit: BoxFit.contain,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                                                  
                                       
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                  .extraSmallHorizontalPadding),
                                          child: Text(
                                            operation.menuname ?? '',
                                            
                                            textAlign: TextAlign.center,
                                            maxLines:
                                                SizeConfig.deviceType ==
                                                        DeviceType
                                                            .smallPhone
                                                    ? 3
                                                    : 2,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: SizeConfig
                                                  .smallTextSize,
                                              fontWeight:
                                                  FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                                                  
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: SizeConfig
                                                .extraSmallVerticalPadding,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            
                                            horizontal: SizeConfig
                                                .smallHorizontalPadding,
                                            vertical: SizeConfig
                                                .extraSmallVerticalPadding,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CommonColors.colorPrimary
                                              ,
                                            borderRadius:
                                                BorderRadius.circular(SizeConfig.largeRadius),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Open Module",
                                                style: TextStyle(
                                                  color: CommonColors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: SizeConfig
                                                      .smallTextSize,
                                                ),
                                              ),
                                            CircleAvatar(
                                              backgroundColor: CommonColors.white,
                                              
                                              child: Icon(
                                                Symbols.arrow_forward_ios,
                                                size: 16,
                                                color: CommonColors.colorPrimary,
                                              ),
                                            )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      );
    });
  }
}
