import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/grList/grListViewModel.dart';
import 'package:gtlmd/pages/grList/model/grListModel.dart';
import 'package:gtlmd/pages/podEntry/podEntry.dart';
import 'package:gtlmd/pages/unDelivery/unDelivery.dart';

class GrList extends StatefulWidget {
  const GrList({super.key});

  @override
  State<GrList> createState() => _GrListState();
}

class _GrListState extends State<GrList> {
  bool _isLoading = true;
  late LoadingAlertService loadingAlertService;
  final GrListViewModel viewModel = GrListViewModel();

  final List<GrListModel> tableData = [
    GrListModel(
      documentNo: 'GR12345',
      date: '2023-10-26',
      origin: 'Mumbai',
      destination: 'Delhi',
      noOfPackages: '10',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR12345',
      date: '2023-10-26',
      origin: 'Mumbai',
      destination: 'Delhi',
      noOfPackages: '10',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR12345',
      date: '2023-10-26',
      origin: 'Mumbai',
      destination: 'Delhi',
      noOfPackages: '10',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
    GrListModel(
      documentNo: 'GR67890',
      date: '2023-10-27',
      origin: 'Bangalore',
      destination: 'Chennai',
      noOfPackages: '5',
    ),
  ];

  String _searchQuery = '';
  List<GrListModel> _filteredData = [];
  List<GrListModel> _grList = [];

  final List<String> columnHeaders = [
    'Sr No.',
    'GRNo',
    'GR Date',
    'Origin',
    'Destination',
    'Packages',
    'Delivery',
    'Undelivered',
  ];

  final cellWidth = 180.0; // Cell width.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    // for testing purposes, using dummy data.
    // _filteredData = tableData;
    setObservers();
    getDrsList();
  }

  void setObservers() {
    viewModel.grListLiveData.stream.listen((list) {
      setState(() {
        _grList = list;
        _filteredData = _grList;
      });
    });

    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredData = _grList;
      } else {
        _filteredData = _grList
            .where((row) =>
                row.documentNo!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void getDrsList() {
    Map<String, String> params = {
      "prmconnstring": companyId,
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmfromdt": '2022-04-01',
      "prmtodt": '2025-01-29'
    };
    viewModel.getGrList(params);
  }

  Widget _buildTableCell(String text, BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.01),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      width: 180, // Adjust column width as needed
      height: MediaQuery.sizeOf(context).height * 0.06,
      child: Text(text, textAlign: TextAlign.center),
    );
  }

  Widget _buildTableCellWithButton(
      String text, ACTIONS action, BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.01),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      width: 180, // Adjust column width as needed
      height: MediaQuery.sizeOf(context).height * 0.06,
      child: OutlinedButton(
        onPressed: () {
          performAction(action);
        },
        child: Text(text),
      ),
    );
  }

  Widget _buildHeaderCell(String header, BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: const Color.fromARGB(
          255,
          41,
          52,
          171,
        ), // Add a background color to the header.
      ),
      width: 180,
      height: MediaQuery.sizeOf(context).height * 0.08,
      child: Text(
        header,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: CommonColors.White,
        ), // Bold header text
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Table'),
          elevation: 2,
          leading: InkWell(
            child: const Icon(Icons.arrow_back),
            onTap: () {
              Get.back();
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              // Add padding for better visual appearance.
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.1,
                  vertical: MediaQuery.sizeOf(context).width * 0.04),
              child: TextField(
                cursorColor: CommonColors.appBarColor,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search GR...',
                  labelStyle: TextStyle(color: CommonColors.appBarColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CommonColors.appBarColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: CommonColors.appBarColor),
                  ),
                ),
                onChanged: (value) => {_filterData(value)},
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.01,
                ),
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  // Ensure the table takes the full horizontal space.
                  width: cellWidth *
                      columnHeaders
                          .length, // Adjust width as needed for all columns.
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: columnHeaders
                            .map(
                              (header) => _buildHeaderCell(header, context),
                            )
                            .toList(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredData.length,
                          itemExtent: MediaQuery.sizeOf(context).height * 0.06,
                          itemBuilder: (context, index) {
                            final row = _filteredData[index];
                            return Row(
                              children: [
                                _buildTableCell(
                                  (index + 1).toString(),
                                  context,
                                ),
                                _buildTableCell(
                                  row.documentNo.toString(),
                                  context,
                                ),
                                _buildTableCell(
                                  row.date.toString(),
                                  context,
                                ),
                                _buildTableCell(
                                  row.origin.toString(),
                                  context,
                                ),
                                _buildTableCell(
                                  row.destination.toString(),
                                  context,
                                ),
                                _buildTableCell(
                                  row.noOfPackages.toString(),
                                  context,
                                ),
                                _buildTableCellWithButton(
                                  'Deliver',
                                  ACTIONS.DELIVER,
                                  context,
                                ),
                                _buildTableCellWithButton(
                                  'Un-deliver',
                                  ACTIONS.UNDELIVER,
                                  context,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void performAction(ACTIONS action) {
    switch (action) {
      case ACTIONS.DELIVER:
      // Get.to(const PodEntry());
      case ACTIONS.UNDELIVER:
      // Get.to(const UnDelivery());
    }
  }
}

enum ACTIONS { DELIVER, UNDELIVER }
