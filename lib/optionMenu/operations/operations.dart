import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart' as URL;
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
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
              final width = constraints.maxWidth;

              final crossAxisCount = width > 1200
                  ? 4
                  : width > 700
                      ? 3
                      : 2;

              return Column(
                children: [
                  /// HEADER CARD
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CommonColors.colorPrimary!,
                          CommonColors.colorPrimary2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: CommonColors.colorPrimary!
                              .withOpacity(.20),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: CommonColors.White?.withOpacity(.15),
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          child:  Icon(
                            Icons.apps_rounded,
                            color: CommonColors.White,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                               Text(
                                "Choose Operation",
                                style: TextStyle(
                                  color: CommonColors.White,
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                               SizedBox(height: 2),
                              Text(
                                "${provider.menuList.length} Modules Available",
                                style:  TextStyle(
                                  color: CommonColors.White?.withOpacity(.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// GRID
                  Expanded(
                    child: GridView.builder(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      itemCount:
                          provider.menuList.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.18,
                      ),
                      itemBuilder:
                          (context, index) {
                        final operation =
                            provider.menuList[index];

                        final accentColors = [
                          const Color(0xFF4F46E5),
                          const Color(0xFF0EA5E9),
                          const Color(0xFF10B981),
                          const Color(0xFFF97316),
                          const Color(0xFFEC4899),
                          const Color(0xFF8B5CF6),
                        ];

                        final accentColor =
                            accentColors[index %
                                accentColors.length];

                        return InkWell(
                          borderRadius:
                              BorderRadius.circular(
                                  24),
                          onTap: () async {
                            final url =
                                await provider
                                    .getSingleOperationDetail(
                              operation.menucode ??
                                  '',
                            );

                            if (url != null &&
                                url.isNotEmpty) {
                              try {
                                await launchUrl(
                                  Uri.parse(url),
                                  mode: LaunchMode
                                      .externalApplication,
                                );
                              } catch (_) {
                                if (context
                                    .mounted) {
                                  ScaffoldMessenger.of(
                                          context)
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
                          child: Container(
                            decoration:
                                BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          24),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      accentColor
                                          .withOpacity(
                                              .10),
                                  blurRadius:
                                      18,
                                  offset:
                                      const Offset(
                                          0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                /// TOP ACCENT BAR
                                Container(
                                  height: 6,
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        accentColor,
                                    borderRadius:
                                        const BorderRadius
                                            .only(
                                      topLeft:
                                          Radius
                                              .circular(
                                                  24),
                                      topRight:
                                          Radius
                                              .circular(
                                                  24),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets
                                            .all(
                                                12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                      children: [
                                        /// HERO IMAGE
                                        Stack(
                                          alignment:
                                              Alignment
                                                  .center,
                                          children: [
                                            /// GLOW
                                            Container(
                                              width:
                                                  110,
                                              height:
                                                  110,
                                              decoration:
                                                  BoxDecoration(
                                                shape:
                                                    BoxShape.circle,
                                                color: accentColor.withOpacity(
                                                    .12),
                                              ),
                                            ),

                                            /// IMAGE HOLDER
                                            Container(
                                              width:
                                                  90,
                                              height:
                                                  90,
                                              decoration:
                                                  BoxDecoration(
                                                color:
                                                    Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        24),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: accentColor.withOpacity(
                                                        .20),
                                                    blurRadius:
                                                        15,
                                                    spreadRadius:
                                                        2,
                                                  ),
                                                ],
                                              ),
                                              child:
                                                  Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        8),
                                                child:
                                                    Image.network(
                                                  "${URL.imageBaseUrl}GTINFINITIAPP/${operation.menuname}.png",
                                                  fit: BoxFit
                                                      .contain,
                                                  loadingBuilder:
                                                      (
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
                                                        strokeWidth:
                                                            2,
                                                        color:
                                                            accentColor,
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Image
                                                        .network(
                                                      defaultImagePath,
                                                      fit: BoxFit.contain,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                            height:
                                                8),

                                        Text(
                                          operation
                                                  .menuname ??
                                              '',
                                          textAlign:
                                              TextAlign
                                                  .center,
                                          maxLines:
                                              2,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                15,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                          ),
                                        ),

                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal:
                                                14,
                                            vertical:
                                                6,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color: accentColor
                                                .withOpacity(
                                                    .08),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                          ),
                                          child:
                                              Text(
                                            "Open Module",
                                            style:
                                                TextStyle(
                                              color:
                                                  accentColor,
                                              fontWeight:
                                                  FontWeight.w600,
                                              fontSize:
                                                  12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
