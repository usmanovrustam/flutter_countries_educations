import 'package:flutter/material.dart';
import 'package:flutter_countries_educations/data/model/selectable_item.dart';

class BottomSheetBuilder<T extends SelectableItem> extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  final Widget Function(BuildContext, T) foregroundItemBuilder;
  final Future<List<T>> Function() load;
  final String title;
  final T? initialValue;
  final void Function(T?)? onItemSelect;

  const BottomSheetBuilder({
    super.key,
    required this.builder,
    required this.load,
    this.onItemSelect,
    required this.foregroundItemBuilder,
    required this.title,
    this.initialValue,
  });

  List<T> _filterData(List<T> data, String query) {
    return data
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _showCountrySelector(BuildContext context) async {
    List<T>? filteredData;

    await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return Column(
            children: [
              const SizedBox(height: 16.0),
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8.0),
              const Divider(),
              Expanded(
                child: FutureBuilder<List<T>>(
                  future: load(),
                  builder: (context, snapshot) {
                    final List<T>? data = filteredData ?? snapshot.data;

                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting;

                    final isLoaded =
                        !isLoading && snapshot.hasData && data != null;

                    final isFailed = !isLoading && snapshot.hasError;

                    return Column(
                      children: [
                        _SearchField(
                          onChanged: (value) {
                            if (data != null) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  filteredData = _filterData(data, value);
                                } else {
                                  filteredData = null;
                                }
                              });
                            }
                          },
                        ),
                        if (isLoading) const _LoadingIndicator(),
                        if (isFailed) const _FailedView(),
                        if (isLoaded)
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Navigator.of(context).pop(
                                    data.elementAt(index),
                                  ),
                                  child: foregroundItemBuilder(
                                    context,
                                    data.elementAt(index),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        });
      },
    ).then((result) {
      if (initialValue != null) {
        onItemSelect?.call(result ?? initialValue);
      } else {
        onItemSelect?.call(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCountrySelector(context),
      child: builder(context),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _SearchField extends StatelessWidget {
  final Function(String) onChanged;

  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[300],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Qidiruv...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _FailedView extends StatelessWidget {
  const _FailedView();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 48, color: Colors.red),
          SizedBox(height: 10),
          Text(
            "Failed to load data",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
