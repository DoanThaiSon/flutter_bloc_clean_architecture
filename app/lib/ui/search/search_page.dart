import 'dart:async';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import '../../app.dart';
import 'bloc/search.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage, SearchBloc> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(title: const Text('Search Page')),
      body: Container()
    );
  }
}
