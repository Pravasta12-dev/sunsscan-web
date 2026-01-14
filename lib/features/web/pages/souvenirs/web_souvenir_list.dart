import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/guest/bloc/souvenir/souvenir_bloc.dart';
import 'package:sun_scan/features/web/pages/souvenirs/section/web_souvenir_table.dart';

class WebSouvenirList extends StatefulWidget {
  const WebSouvenirList({super.key, required this.eventId});

  final String eventId;

  @override
  State<WebSouvenirList> createState() => _WebSouvenirListState();
}

class _WebSouvenirListState extends State<WebSouvenirList> {
  @override
  void initState() {
    super.initState();

    context.read<SouvenirBloc>().loadSouvenirs(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 49.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const WebSouvenirTable(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
