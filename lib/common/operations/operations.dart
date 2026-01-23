import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:gtlmd/common/operations/operationsProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class Operations extends StatefulWidget {
  const Operations({super.key});

  @override
  State<Operations> createState() => _OperationsState();
}

class _OperationsState extends State<Operations> {
  late LoadingAlertService loadingAlertService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      _getOperations();
    });
  }

  Future<void> _getOperations() async {
    Provider.of<OperationsProvider>(context, listen: false).getOperationsList();
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
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          foregroundColor: CommonColors.White,
          title: Text(
            'Operations',
            style: TextStyle(
              fontSize: SizeConfig.largeTextSize,
            ),
          ),
        ),
        body: provider.operationsList.isEmpty &&
                provider.status == ApiCallingStatus.success
            ? Center(
                child: Text(
                  'No data found',
                  style: TextStyle(
                    fontSize: SizeConfig.mediumTextSize,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: provider.operationsList.length,
                itemBuilder: (context, index) {
                  final operation = provider.operationsList[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        operation.menuname ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(operation.menucode ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Symbols.arrow_forward),
                        onPressed: () async {
                          final url = await provider.getSingleOperationDetail(
                              operation.menucode ?? '');
                          if (url != null && url.isNotEmpty) {
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not launch URL')),
                                );
                              }
                            }
                          }
                        },
                      ),
                      onTap: () async {
                        if (operation.pageLink != null &&
                            operation.pageLink!.isNotEmpty) {
                          final uri = Uri.parse(operation.pageLink!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Could not launch URL')),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
              ),
      );
    });
  }
}
