import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/textFormatter/upperCaseTextFormatter.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/utils.dart';
import 'package:gtlmd/pages/pickup/ContentModel.dart';

// class CommonDataModel<T> {
//   String title;
//   T model;

//   CommonDataModel(this.title, this.model);
// }

class ContentSelectionBs extends StatefulWidget {
  final String title;
  final void Function(dynamic) callBack;
  const ContentSelectionBs(
      {super.key,
      required this.title,
      // required this.dataList,
      required this.callBack});
  @override
  State<ContentSelectionBs> createState() => _ContentSelectionBs();
}

class _ContentSelectionBs<T> extends State<ContentSelectionBs> {
  TextEditingController searchController = TextEditingController();
  dynamic currentModel;
  List<ContentModel> dataList = [];

  List<ContentModel> filterList = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    filterList.addAll(dataList);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (filterList.isNotEmpty) {
          searchController.text = filterList.elementAt(0).itemName!;
          currentModel = filterList.elementAt(0);
        }
      });
    });
    // getBranchList();
    // setObservers();
    getContentList();
  }

  void getContentList() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode
          .toString(), // because we are not selecting branch in LMD
      "prmcharstr": searchController.text
    };

    try {
      CommonResponse response =
          await apiGet("${bookingUrl}getContentsV2", params);

      if (response.commandStatus != 1) {
        failToast(response.commandMessage ?? "Something went wrong");
      }

      Map<String, dynamic> table = jsonDecode(response.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<ContentModel> resultList = List.generate(
          list.length, (index) => ContentModel.fromJson(list[index]));

      setState(() {
        dataList = resultList;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void hideProgressDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // hide progress dialog
    });
  }

  void filterData(String str) {
    filterList.clear();
    List<ContentModel> currentFilterList = List.empty(growable: true);
    if (str == "") {
      currentFilterList.addAll(dataList);
    } else {
      debugPrint(dataList.length.toString());
      for (int i = 0; i < dataList.length; i++) {
        if (dataList
            .elementAt(i)
            .itemName!
            .toLowerCase()
            .contains(str.toLowerCase())) {
          currentFilterList.add(dataList.elementAt(i));
        }
      }
    }
    setState(() {
      filterList.addAll(currentFilterList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: ScreenDimension.height / 1.5,
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            // width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(color: Colors.blueAccent,

            decoration: BoxDecoration(
                color: CommonColors.colorPrimary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                  TextField(
                    // autofocus: true,
                    controller: searchController,
                    onChanged: (data) {
                      getContentList();
                    },
                    inputFormatters: [UpperCaseTextFormatter()],
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    obscureText: false,
                    onTap: () {},
                    onEditingComplete: () {
                      getContentList();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            filterData(searchController.text);
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),

                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.black)), // hintText:,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              // height: ScreenDimension.height/3,
              child: ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: filterList.length,
            itemBuilder: (context, index) {
              return ListTile(
                selected: (filterList.elementAt(index).itemName ==
                    searchController.text),
                selectedColor: Colors.green,
                title: Text(filterList.elementAt(index).itemName!,
                    textAlign: TextAlign.center),
                onTap: () {
                  searchController.text = filterList.elementAt(index).itemName!;
                  currentModel = filterList.elementAt(index);
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(thickness: 0.5, color: Colors.black54);
            },
          )),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonButton(
                title: "submit",
                onTap: () {
                  if (searchController.text.isEmpty) {
                    failToast("Nothing selected.");
                  } else if (currentModel != null) {
                    widget.callBack.call(currentModel.model);
                    // Navigator.pop(context);
                    Get.back();
                  }
                },
                color: CommonColors.successColor!),
          )
          // SizedBox(
          //   // height: 50,
          //   width: MediaQuery.of(context).size.width / 1.1,
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //         backgroundColor:
          //             MaterialStatePropertyAll(CommonColors.success)),
          //     onPressed: () {
          //       if (searchController.text.isEmpty) {
          //         failToast("Nothing selected.");
          //       } else if (currentModel != null) {
          //         widget.callBack.call(currentModel.model);
          //       }
          //     },
          //     child: Text(
          //       'Submit',
          //       style: TextStyle(color: Colors.black),
          //     ),
          //   ),
          // )
        ]));
  }
}

Future<void> showContentSelectionBs<T>(
    BuildContext context, String title, void Function(dynamic) callBack) async {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              // padding: EdgeInsets.only(
              //   bottom: MediaQuery.of(context).viewInsets.bottom,),
              // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ContentSelectionBs(
                title: title,
                // dataList: data,
                callBack: callBack,
              )),
        );
      });
}
