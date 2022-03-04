import 'dart:async';

import 'package:amodeus_api/amodeus_api.dart' show Person;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/api.dart';
import '../utils/storage.dart' as storage;

class SearchScreen extends StatefulWidget {
  final VoidCallback onSearchFinished;

  const SearchScreen({
    Key? key,
    required this.onSearchFinished,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _results = <Person>[];
  final _query = TextEditingController();
  final _refresh = GlobalKey<RefreshIndicatorState>();
  Timer? _t;

  Future<void> _search(String query) async {
    final api = (await getApi()).getSearchApi();
    try {
      final res = await api.search(personName: query);
      setState(() {
        _results = res.data!.toList();
      });
    } on DioError {
      // FIXME (2022-02-20): due to bug in API, when nothing found, 500 is returned.
      setState(() {
        _results = [];
      });
    }
  }

  ListTile _transform(Person e) => ListTile(
        title: Text(e.fullName),
        onTap: () async {
          storage.personUUID.set(e.id);
          Navigator.pop(context);
          widget.onSearchFinished();
        },
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _query,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Введите ФИО",
            ),
            onChanged: (value) {
              _t?.cancel();
              _t = Timer(const Duration(milliseconds: 500), () => _refresh.currentState!.show());
            },
            onSubmitted: (value) {
              _t?.cancel();
              _refresh.currentState!.show();
            },
          ),
        ),
        body: RefreshIndicator(
          key: _refresh,
          child: ListView(
            children: _results.map(_transform).toList(),
          ),
          onRefresh: () => _search(_query.text),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _t?.cancel();
    _query.dispose();
    super.dispose();
  }
}
