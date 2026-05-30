import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/textFormatter/upperCaseTextFormatter.dart';

class GenericApiBottomSheet<T> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function(String query) fetchItems;
  final String Function(T item) itemTitle; // How to display the key on the UI
  final String Function(T item)?
      itemSubtitle; // Optional subtitle (e.g. city, code)
  final void Function(T selectedItem) onSelected; // What data to return

  const GenericApiBottomSheet({
    Key? key,
    required this.title,
    required this.fetchItems,
    required this.itemTitle,
    this.itemSubtitle,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<GenericApiBottomSheet<T>> createState() =>
      _GenericApiBottomSheetState<T>();
}

class _GenericApiBottomSheetState<T> extends State<GenericApiBottomSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Fetch initial list with empty query when bottom sheet opens
    // _performSearch("");
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Wait for 500ms of inactivity before firing API request
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await widget.fetchItems(query);
      setState(() {
        _results = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Search error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Header & Search Box
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: CommonColors.colorPrimary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  inputFormatters: [UpperCaseTextFormatter()],
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.grey),
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _performSearch("");
                            },
                            icon: const Icon(Icons.clear),
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Type to search...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results list
          Expanded(
            child: _isLoading && _results.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(child: Text("No items found"))
                    : ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: _results.length,
                        separatorBuilder: (context, index) => const Divider(
                            thickness: 0.5, color: Colors.black26),
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          return ListTile(
                            title: Text(
                              widget.itemTitle(item),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: widget.itemSubtitle != null
                                ? Text(widget.itemSubtitle!(item))
                                : null,
                            onTap: () {
                              widget.onSelected(item);
                              Get.back(); // Close sheet
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// Global invocation helper
Future<void> showGenericApiBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Future<List<T>> Function(String query) fetchItems,
  required String Function(T item) itemTitle,
  String Function(T item)? itemSubtitle,
  required void Function(T selectedItem) onSelected,
}) async {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.85,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: GenericApiBottomSheet<T>(
            title: title,
            fetchItems: fetchItems,
            itemTitle: itemTitle,
            itemSubtitle: itemSubtitle,
            onSelected: onSelected,
          ),
        ),
      );
    },
  );
}
