import 'package:flutter/material.dart';

class SearchCityWidget extends StatefulWidget {
  final String city;
  final ValueChanged<String> onChanged;
  final VoidCallback onSearch;

  const SearchCityWidget({
    super.key,
    required this.city,
    required this.onChanged,
    required this.onSearch,
  });

  @override
  State<SearchCityWidget> createState() => _SearchCityWidgetState();
}

class _SearchCityWidgetState extends State<SearchCityWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.city);
  }

  @override
  void didUpdateWidget(SearchCityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller when city changes from parent
    if (widget.city != oldWidget.city) {
      _controller.text = widget.city;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: (_) => widget.onSearch(),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          hintText: 'Enter city name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: Icon(Icons.search),
          labelText: 'Search',
          labelStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}